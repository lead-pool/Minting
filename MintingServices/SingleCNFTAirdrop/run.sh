while read line
do
  databaseName=$line
done < database.txt

network=$(psql -U ubuntu -d $databaseName -t -A -c "select network from settings;")
nftProject=$(psql -U ubuntu -d $databaseName -t -A -c "select nftProject from settings;")
nftCount=$(psql -U ubuntu -d $databaseName -t -A -c "select nftCount from settings;")
batch=$(psql -U ubuntu -d $databaseName -t -A -c "select entriesPerFile from settings;")
randomSetting=$(psql -U ubuntu -d $databaseName -t -A -c "select randomSetting from settings;")
sessions=$(psql -U ubuntu -d $databaseName -t -A -c "select sessions from settings;")
originalPolicy=$(psql -U ubuntu -d $databaseName -t -A -c "select originalPolicy from settings;")
CNFTHoldings=$(psql -U ubuntu -d $databaseName -t -A -c "select CNFTHoldings from settings;")
minterFee=$(psql -U ubuntu -d $databaseName -t -A -c "select minterFee from settings;")
minterAddress=$(psql -U ubuntu -d $databaseName -t -A -c "select minterAddress from settings;")

hexName=$(echo -n "${nftProject}" | xxd -b -ps -c 80 | tr -d '\n')

walletAddress=$(cat sendingKeys/payment.addr)
walletSigningKey="sendingKeys/payment.skey"


if [ "$network" == "testnet" ]
then
  networkParam="--testnet-magic 1097911063"
  db="testnet"
else
  networkParam="--mainnet"
  db="cexplorer"
fi

./airdrop.sh $databaseName $originalPolicy $CNFTHoldings $db

cardano-cli query protocol-parameters $networkParam --out-file protocol.json

policyID=$(cat policy/${nftProject}.policy.id)
policyScriptFile=policy/${nftProject}.policy.script
policyTTL=$(cat $policyScriptFile | jq -r ".scripts[] | select(.type == \"before\") | .slot" 2> /dev/null || echo "unlimited")
policyKeyFile=policy/${nftProject}.policy.skey

era="--alonzo-era"


counter=0
first=1
minValTotal=0
outString=""
minterFeeTotal=0

airdrop=$(psql -U ubuntu -d ${databaseName} -t -c "select address from airdrop;")

for address in $airdrop;
do
  echo $address
  counter=$(expr $counter + 1)
  minterFeeTotal=$(expr $minterFeeTotal + $minterFee)

  if [ $first -eq 1 ]
  then
    multiAsset=$(echo "${address}+200000+1 ${policyID}.${hexName}")
    abc=""
    while [ "$abc" = "" ]
    do
      calcMinVal=$(cardano-cli transaction calculate-min-required-utxo --protocol-params-file protocol.json --tx-out "${multiAsset}" $era)
      abc="abc"
      if [ $? -ne 0 ]; then abc=""; fi
    done
    minVal=$(echo ${calcMinVal} | cut -d' ' -f 2)
    first=2
  fi

  minValTotal=$(expr $minValTotal + $minVal)

  if [ "outString" = "" ]
  then
    outString="--tx-out \"$address+$minVal+1 ${policyID}.${hexName}\""
  else
    outString="${outString} --tx-out \"$address+$minVal+1 ${policyID}.${hexName}\""
  fi

  if [ $counter -eq $batch ]
  then


    utxoJSON=""
    while [ "$utxoJSON" = "" ]
    do
      utxoJSON=$(cardano-cli query utxo ${networkParam} --address ${walletAddress} --out-file /dev/stdout); if [ $? -ne 0 ]; then utxoJSON=""; fi;
    done

    txcnt=$(jq length <<< ${utxoJSON})

    for (( tmpCnt=0; tmpCnt<${txcnt}; tmpCnt++ ))
    do

      utxoHashIndex=$(jq -r "keys_unsorted[${tmpCnt}]" <<< ${utxoJSON})
      utxoHashIndexTrunc=${utxoHashIndex%#*}    
      txInString=""
      txInString="--tx-in ${utxoHashIndex}"

      totalLovelaces=0
      utxoAmount=$(jq -r ".\"${utxoHashIndex}\".value.lovelace" <<< ${utxoJSON})
      totalLovelaces=$(bc <<< "${totalLovelaces} + ${utxoAmount}" )

    done



    mintString="$counter ${policyID}.${hexName}"
    mintString="\"${mintString}\""

    metaString="--metadata-json-file /home/ubuntu/${nftProject}/JSON/${nftProject}.json"

    outCount=$(expr $counter + 2)

    abc=""
    while [ "$abc" = "" ]
    do
      b="cardano-cli transaction build-raw ${txInString} --tx-out ${walletAddress}+200000 --tx-out ${minterAddress}+${minterFeeTotal} "$outString" --mint ${mintString} --minting-script-file $policyScriptFile --invalid-hereafter $policyTTL $metaString --fee 0 --out-file tx.raw $era"
      eval $b
      abc="abc"
      if [ $? -ne 0 ]; then abc=""; fi
    done
    
    abc=""
    while [ "$abc" = "" ]
    do
      minfee=$(cardano-cli transaction calculate-min-fee --tx-body-file tx.raw --tx-in-count 1 --tx-out-count $outCount --witness-count 1 --byron-witness-count 0 $networkParam --protocol-params-file protocol.json | awk '{ print $1 }');
      abc="abc"
      if [ $? -ne 0 ]; then abc=""; fi
    done

    remainder=$(expr ${totalLovelaces} - ${minfee} - ${minValTotal} - ${minterFeeTotal});

    abc=""
    while [ "$abc" = "" ]
    do
      c="cardano-cli transaction build-raw ${txInString} --tx-out ${walletAddress}+${remainder} --tx-out ${minterAddress}+${minterFeeTotal} "$outString" --mint ${mintString} --minting-script-file $policyScriptFile --invalid-hereafter $policyTTL $metaString --fee ${minfee} --out-file tx.raw $era"
      eval $c
      abc="abc"
      if [ $? -ne 0 ]; then abc=""; fi
    done


    abc=""
    while [ "$abc" = "" ]
    do
      cardano-cli transaction sign --tx-body-file tx.raw --signing-key-file $walletSigningKey --signing-key-file ${policyKeyFile} $networkParam --out-file tx.signed
      abc="abc"
      if [ $? -ne 0 ]; then abc=""; fi
    done

    submit=""
    abc=""
    while [ "$abc" = "" ]
    do
      submit=$(cardano-cli transaction submit --tx-file tx.signed $networkParam)
      abc="abc"
      if [ $? -ne 0 ]; then abc=""; fi
    done


    while [ "$submit" != "Transaction successfully submitted." ]
    do
      submit=$(cardano-cli transaction submit --tx-file tx.signed $networkParam)
      if [ $? -ne 0 ]; then submit="abc"; fi
    done

    echo $submit

    totalLovelacesCheck=$totalLovelaces
    while [ $totalLovelacesCheck -eq $totalLovelaces ]
    do
      sleep 1

      utxoJSON=""
      while [ "$utxoJSON" = "" ]
      do
        utxoJSON=$(cardano-cli query utxo ${networkParam} --address ${walletAddress} --out-file /dev/stdout); if [ $? -ne 0 ]; then utxoJSON=""; fi;
      done

      txcnt=$(jq length <<< ${utxoJSON})

      for (( tmpCnt=0; tmpCnt<${txcnt}; tmpCnt++ ))
      do
        utxoHashIndex=$(jq -r "keys_unsorted[${tmpCnt}]" <<< ${utxoJSON})
        totalLovelacesCheck=0
        utxoAmount=$(jq -r ".\"${utxoHashIndex}\".value.lovelace" <<< ${utxoJSON})
        totalLovelacesCheck=$(bc <<< "${totalLovelacesCheck} + ${utxoAmount}" )
      done 
    done


    counter=0
    minValTotal=0
    outString=""
    minterFeeTotal=0
  fi

done



if [ $counter -gt 0 ]
then

    utxoJSON=""
    while [ "$utxoJSON" = "" ]
    do
      utxoJSON=$(cardano-cli query utxo ${networkParam} --address ${walletAddress} --out-file /dev/stdout); if [ $? -ne 0 ]; then utxoJSON=""; fi;
    done

    txcnt=$(jq length <<< ${utxoJSON})

    for (( tmpCnt=0; tmpCnt<${txcnt}; tmpCnt++ ))
    do

      utxoHashIndex=$(jq -r "keys_unsorted[${tmpCnt}]" <<< ${utxoJSON})
      utxoHashIndexTrunc=${utxoHashIndex%#*}    
      txInString=""
      txInString="--tx-in ${utxoHashIndex}"

      totalLovelaces=0
      utxoAmount=$(jq -r ".\"${utxoHashIndex}\".value.lovelace" <<< ${utxoJSON})
      totalLovelaces=$(bc <<< "${totalLovelaces} + ${utxoAmount}" )

    done



    mintString="$counter ${policyID}.${hexName}"
    mintString="\"${mintString}\""

    metaString="--metadata-json-file /home/ubuntu/${nftProject}/JSON/${nftProject}.json"

    outCount=$(expr $counter + 1)

    abc=""
    while [ "$abc" = "" ]
    do
      b="cardano-cli transaction build-raw ${txInString} --tx-out ${walletAddress}+200000 --tx-out ${minterAddress}+${minterFeeTotal} "$outString" --mint ${mintString} --minting-script-file $policyScriptFile --invalid-hereafter $policyTTL $metaString --fee 0 --out-file tx.raw $era"
      eval $b
      abc="abc"
      if [ $? -ne 0 ]; then abc=""; fi
    done

    abc=""
    while [ "$abc" = "" ]
    do
      minfee=$(cardano-cli transaction calculate-min-fee --tx-body-file tx.raw --tx-in-count 1 --tx-out-count $outCount --witness-count 1 --byron-witness-count 0 $networkParam --protocol-params-file protocol.json | awk '{ print $1 }');
      abc="abc"
      if [ $? -ne 0 ]; then abc=""; fi
    done

    remainder=$(expr ${totalLovelaces} - ${minfee} - ${minValTotal} - ${minterFeeTotal});

    abc=""
    while [ "$abc" = "" ]
    do
      c="cardano-cli transaction build-raw ${txInString} --tx-out ${walletAddress}+${remainder} --tx-out ${minterAddress}+${minterFeeTotal} "$outString" --mint ${mintString} --minting-script-file $policyScriptFile --invalid-hereafter $policyTTL $metaString --fee ${minfee} --out-file tx.raw $era"
      eval $c
      abc="abc"
      if [ $? -ne 0 ]; then abc=""; fi
    done


    abc=""
    while [ "$abc" = "" ]
    do
      cardano-cli transaction sign --tx-body-file tx.raw --signing-key-file $walletSigningKey --signing-key-file ${policyKeyFile} $networkParam --out-file tx.signed
      abc="abc"
      if [ $? -ne 0 ]; then abc=""; fi
    done

    submit=""
    abc=""
    while [ "$abc" = "" ]
    do
      submit=$(cardano-cli transaction submit --tx-file tx.signed $networkParam)
      abc="abc"
      if [ $? -ne 0 ]; then abc=""; fi
    done


    while [ "$submit" != "Transaction successfully submitted." ]
    do
      submit=$(cardano-cli transaction submit --tx-file tx.signed $networkParam)
      if [ $? -ne 0 ]; then submit="abc"; fi
    done

    echo $submit



fi