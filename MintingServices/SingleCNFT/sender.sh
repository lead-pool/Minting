file=${1}
session=${1}
networkParam=${2}
sessions=${3}
receivingAdd=${4}
receivingKeyFile=${5}
policyID=${6}
policyScriptFile=${7}
policyTTL=${8}
policyKeyFile=${9}
finalWallet=${10}
era=${11}
nftProject=${12}
nftCost=${13}
databaseName=${14}
minterFee=${15}
minterAddress=${16}
database=${17}
lineCount=1

hexName=$(echo -n "${nftProject}" | xxd -b -ps -c 80 | tr -d '\n')

#Loop forever
while true; do
  sleep 10
  echo "Sender ${session} waiting"

  check=$(psql -U ubuntu -d ${databaseName} -t -c "select count(*) from sender where grouping = $file;")

  #Check to see if table containing utxos exist
  if [ $check -gt 0 ]
  then
    echo "Sender ${session} begin"
    
    #Create funding txInString and count for minfee calc
    hashes=$(psql -U ubuntu -d ${databaseName} -t -c "select hash from sender where grouping = $file;")
    txInString=""
    totalLovelaces=0
    for hash in $hashes
    do
      txInString="${txInString} --tx-in ${hash}"
      totalLovelaces=$(expr $totalLovelaces + $nftCost)
    done


    txOutCounter=2
    outString=""
    mintString=""
    metaString=""
    minValTotal=0
    mintTotal=0
    minterFeeTotal=0
    #Loop over list again
    for hash in $hashes
    do
      #trunced utxo hash used by blockfolio api to get the address
      utxoHashIndexTrunc=${hash%#*}

      fileCheck=0

      mintTotal=$(expr $mintTotal + 1)
      txOutCounter=$(expr $txOutCounter + 1)
      minterFeeTotal=$(expr $minterFeeTotal + $minterFee)
      #Get sending address
      size=0
      hash="\x$utxoHashIndexTrunc"
      while [ $size -eq 0 ]
      do
        sql=$(psql -U ubuntu -d ${database} -t -c "select address from tx_out where tx_id = (select id from tx where hash = '${hash}') and address != '${receivingAdd}'")
        size=${#sql}
      done
      
      for result in $sql
      do
        receivingAddress=$result
      done

      #Calculate min val
      multiAsset=$(echo "${receivingAddress}+200000+1 ${policyID}.${hexName}")
      abc=""
      while [ "$abc" = "" ]
      do
        calcMinVal=$(cardano-cli transaction calculate-min-required-utxo --protocol-params-file protocol.json --tx-out "${multiAsset}" $era)
        abc="abc"
        if [ $? -ne 0 ]; then abc=""; fi
      done
      minVal=$(echo ${calcMinVal} | cut -d' ' -f 2)
      minValTotal=$(expr $minValTotal + $minVal)
      #MINTING + SENDING CODE
      if [ "$outString" = "" ]
      then
        outString="--tx-out \"$receivingAddress+$minVal+1 ${policyID}.${hexName}\""  
      else
        outString="${outString} --tx-out \"$receivingAddress+$minVal+1 ${policyID}.${hexName}\""
      fi
      


    done


    mintString="$mintTotal ${policyID}.${hexName}"
    mintString="\"${mintString}\""
    metaString="--metadata-json-file /home/ubuntu/${nftProject}/JSON/${nftProject}.json"
    

    abc=""
    while [ "$abc" = "" ]
    do
      b="cardano-cli transaction build-raw ${txInString} --tx-out ${finalWallet}+200000 --tx-out ${minterAddress}+${minterFeeTotal} "$outString" --mint ${mintString} --minting-script-file $policyScriptFile --invalid-hereafter $policyTTL $metaString --fee 0 --out-file tx${session}.raw $era"
      eval $b
      abc="abc"
      if [ $? -ne 0 ]; then abc=""; fi
    done

    abc=""
    while [ "$abc" = "" ]
    do
      minfee=$(cardano-cli transaction calculate-min-fee --tx-body-file tx${session}.raw --tx-in-count $mintTotal --tx-out-count $txOutCounter --witness-count 1 --byron-witness-count 0 $networkParam --protocol-params-file protocol.json | awk '{ print $1 }');
      abc="abc"
      if [ $? -ne 0 ]; then abc=""; fi
    done

    remainder=$(expr ${totalLovelaces} - ${minfee} - ${minValTotal} - ${minterFeeTotal});

    abc=""
    while [ "$abc" = "" ]
    do
      c="cardano-cli transaction build-raw ${txInString} --tx-out ${finalWallet}+${remainder} --tx-out ${minterAddress}+${minterFeeTotal} "$outString" --mint ${mintString} --minting-script-file $policyScriptFile --invalid-hereafter $policyTTL $metaString --fee ${minfee} --out-file tx${session}.raw $era"
      eval $c
      abc="abc"
      if [ $? -ne 0 ]; then abc=""; fi
    done


    abc=""
    while [ "$abc" = "" ]
    do
      cardano-cli transaction sign --tx-body-file tx${session}.raw --signing-key-file $receivingKeyFile --signing-key-file ${policyKeyFile} $networkParam --out-file tx${session}.signed
      abc="abc"
      if [ $? -ne 0 ]; then abc=""; fi
    done

    submit=""
    abc=""
    while [ "$abc" = "" ]
    do
      submit=$(cardano-cli transaction submit --tx-file tx${session}.signed $networkParam)
      abc="abc"
      if [ $? -ne 0 ]; then abc=""; fi
    done


    while [ "$submit" != "Transaction successfully submitted." ]
    do
      submit=$(cardano-cli transaction submit --tx-file tx${session}.signed $networkParam)
      if [ $? -ne 0 ]; then submit="abc"; fi
    done
    
    echo "Sender ${session} done"
    rm tx${session}.raw
    rm tx${session}.signed
    sql=$(psql -U ubuntu -d ${databaseName} -t -c "delete from sender where grouping = $file;")
    file=$(expr $file + $sessions)

  fi

done