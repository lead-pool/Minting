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

./createDB.sh $nftProject $databaseName
./airdrop.sh $databaseName $originalPolicy $CNFTHoldings $db

cardano-cli query protocol-parameters $networkParam --out-file protocol.json

policyID=$(cat policy/${nftProject}.policy.id)
policyScriptFile=policy/${nftProject}.policy.script
policyTTL=$(cat $policyScriptFile | jq -r ".scripts[] | select(.type == \"before\") | .slot" 2> /dev/null || echo "unlimited")
policyKeyFile=policy/${nftProject}.policy.skey

era="--alonzo-era"


counter=0
minValTotal=0
outString=""
mintString=""
fileCounter=0
minterFeeTotal=0

airdrop=$(psql -U ubuntu -d ${databaseName} -t -c "select address from airdrop;")


for address in $airdrop
do
  echo $address
  counter=$(expr $counter + 1)
  minterFeeTotal=$(expr $minterFeeTotal + $minterFee)

  if [ $counter -eq 1 ]
  then
    fileCounter=$(expr $fileCounter + 1)
    echo -n "{\"721\": {\"$policyID\":" > /home/ubuntu/${nftProject}/JSON/${nftProject}${fileCounter}.json
  fi

  #Get random number
  nftOk=0
  while [ $nftOk -eq 0 ]
  do
    if ! mkdir script.lock 2>/dev/null; then
      sleep 1
    else
      randomNo=$(psql -U ubuntu -d ${databaseName} -t -c "select random from random order by random() limit 1;")
      for number in $randomNo
      do
        random=$number
      done
      delete=$(psql -U ubuntu -d ${databaseName} -t -c "delete from random where random = $random;")
      nftOk=1
      rmdir script.lock
    fi
  done

  #IPFS HOST AND PIN
  CID=$(psql -U ubuntu -d ${databaseName} -t -A -c "select hash from ipfs where nftNumber = $random;")
  ipfsDetail="ipfs://ipfs/$CID"
  deleteCID=$(psql -U ubuntu -d ${databaseName} -t -c "delete from ipfs where nftNumber = $random;")


  #CREATE META JSON
  attr1=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field1 from metadata limit 1;")\"
  attr2=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field2 from metadata limit 1;")\"
  attr3=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field3 from metadata limit 1;")\"
  attr4=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field4 from metadata limit 1;")\"
  attr5=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field5 from metadata limit 1;")\"
  attr6=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field6 from metadata limit 1;")\"
  attr7=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field7 from metadata limit 1;")\"
  attr8=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field8 from metadata limit 1;")\"
  attr9=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field9 from metadata limit 1;")\"
  attr10=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field10 from metadata limit 1;")\"
  attr11=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field11 from metadata limit 1;")\"
  attr12=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field12 from metadata limit 1;")\"
  attr13=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field13 from metadata limit 1;")\"
  attr14=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field14 from metadata limit 1;")\"
  attr15=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field15 from metadata limit 1;")\"
  attr16=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field16 from metadata limit 1;")\"
  attr17=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field17 from metadata limit 1;")\"
  attr18=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field18 from metadata limit 1;")\"
  attr19=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field19 from metadata limit 1;")\"
  attr20=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field20 from metadata limit 1;")\"


  line1=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field1 from metadata where field1 = '${nftProject}${random}';")\"
  line2=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field2 from metadata where field1 = '${nftProject}${random}';")\"
  line3=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field3 from metadata where field1 = '${nftProject}${random}';")\"
  line4=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field4 from metadata where field1 = '${nftProject}${random}';")\"
  line5=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field5 from metadata where field1 = '${nftProject}${random}';")\"
  line6=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field6 from metadata where field1 = '${nftProject}${random}';")\"
  line7=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field7 from metadata where field1 = '${nftProject}${random}';")\"
  line8=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field8 from metadata where field1 = '${nftProject}${random}';")\"
  line9=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field9 from metadata where field1 = '${nftProject}${random}';")\"
  line10=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field10 from metadata where field1 = '${nftProject}${random}';")\"
  line11=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field11 from metadata where field1 = '${nftProject}${random}';")\"
  line12=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field12 from metadata where field1 = '${nftProject}${random}';")\"
  line13=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field13 from metadata where field1 = '${nftProject}${random}';")\"
  line14=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field14 from metadata where field1 = '${nftProject}${random}';")\"
  line15=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field15 from metadata where field1 = '${nftProject}${random}';")\"
  line16=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field16 from metadata where field1 = '${nftProject}${random}';")\"
  line17=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field17 from metadata where field1 = '${nftProject}${random}';")\"
  line18=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field18 from metadata where field1 = '${nftProject}${random}';")\"
  line19=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field19 from metadata where field1 = '${nftProject}${random}';")\"
  line20=\"$(psql -U ubuntu -d ${databaseName} -t -A -c "select field20 from metadata where field1 = '${nftProject}${random}';")\"
        
  if [ $counter -eq 1 ]
  then
    echo -n " {$line1: {$attr2: $line2, \"image\": \"$ipfsDetail\"" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${fileCounter}.json 
  else
    echo -n ", $line1: {$attr2: $line2, \"image\": \"$ipfsDetail\"" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${fileCounter}.json 
  fi
        

  if [ "${attr3}" != '""' ]
  then
    echo -n ", $attr3: $line3" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${fileCounter}.json
  fi
  if [ "${attr4}" != '""' ]
  then
    echo -n ", $attr4: $line4" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${fileCounter}.json
  fi
  if [ "${attr5}" != '""' ]
  then
    echo -n ", $attr5: $line5" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${fileCounter}.json 
  fi
  if [ "${attr6}" != '""' ]
  then
    echo -n ", $attr6: $line6" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${fileCounter}.json
  fi
  if [ "${attr7}" != '""' ]
  then
    echo -n ", $attr7: $line7" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${fileCounter}.json
  fi
  if [ "${attr8}" != '""' ]
  then
    echo -n ", $attr8: $line8" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${fileCounter}.json
  fi
  if [ "${attr9}" != '""' ]
  then
    echo -n ", $attr9: $line9" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${fileCounter}.json 
  fi
  if [ "${attr10}" != '""' ]
  then
    echo -n ", $attr10: $line10" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${fileCounter}.json
  fi
  if [ "${attr11}" != '""' ]
  then
    echo -n ", $attr11: $line11" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${fileCounter}.json
  fi
  if [ "${attr12}" != '""' ]
  then
    echo -n ", $attr12: $line12" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${fileCounter}.json
  fi
  if [ "${attr13}" != '""' ]
  then
    echo -n ", $attr13: $line13" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${fileCounter}.json 
  fi
  if [ "${attr14}" != '""' ]
  then
    echo -n ", $attr14: $line14" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${fileCounter}.json
  fi
  if [ "${attr15}" != '""' ]
  then
    echo -n ", $attr15: $line15" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${fileCounter}.json
  fi
  if [ "${attr16}" != '""' ]
  then
    echo -n ", $attr16: $line16" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${fileCounter}.json
  fi
  if [ "${attr17}" != '""' ]
  then
    echo -n ", $attr17: $line17" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${fileCounter}.json
  fi
  if [ "${attr18}" != '""' ]
  then
    echo -n ", $attr18: $line18" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${fileCounter}.json
  fi
  if [ "${attr19}" != '""' ]
  then
    echo -n ", $attr19: $line19" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${fileCounter}.json
  fi
  if [ "${attr20}" != '""' ]
  then
    echo -n ", $attr20: $line20" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${fileCounter}.json
  fi

  echo -n "}" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${fileCounter}.json 
  
  hexName=$(echo -n "${nftProject}${random}" | xxd -b -ps -c 80 | tr -d '\n')
  
  multiAsset=$(echo "${address}+200000+1 ${policyID}.${hexName}")
  abc=""
  while [ "$abc" = "" ]
  do
    calcMinVal=$(cardano-cli transaction calculate-min-required-utxo --protocol-params-file "$files"protocol.json --tx-out "${multiAsset}" $era)
    abc="abc"
    if [ $? -ne 0 ]; then abc=""; fi
  done
  minVal=$(echo ${calcMinVal} | cut -d' ' -f 2)
  minValTotal=$(expr $minValTotal + $minVal)



  if [ "$outString" = "" ]
  then
    outString="--tx-out \"$address+$minVal+1 ${policyID}.${hexName}\""  
  else
    outString="${outString} --tx-out \"$address+$minVal+1 ${policyID}.${hexName}\""
  fi


  if [ "$mintString" = "" ]
  then
    mintString="1 ${policyID}.${hexName}"
  else
    mintString="${mintString} +1 ${policyID}.${hexName}"
  fi



  if [ $counter -eq $batch ]
  then


    echo -n "}}}" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${fileCounter}.json

    metaString="--metadata-json-file /home/ubuntu/${nftProject}/JSON/${nftProject}${fileCounter}.json"
    mintString="\"${mintString}\""


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
    mintString=""
    minterFeeTotal=0



  fi

done



if [ $counter -gt 0 ]
then

    echo -n "}}}" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${fileCounter}.json

    metaString="--metadata-json-file /home/ubuntu/${nftProject}/JSON/${nftProject}${fileCounter}.json"
    mintString="\"${mintString}\""

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