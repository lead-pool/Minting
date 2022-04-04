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

#Loop forever
while true; do
  
  sleep 10
  echo "Sender ${session} waiting"
  check=$(psql -U ubuntu -d ${databaseName} -t -c "select count(*) from sender where grouping = $file;")

  #Check to see if file containing utxos exist

  if [ $check -gt 0 ]
  then
    echo -n "{\"721\": {\"$policyID\":" > /home/ubuntu/${nftProject}/JSON/${nftProject}${file}.json
    echo "Sender ${session} begin"
    #Create funding txInString and count for minfee calc
    hashes=$(psql -U ubuntu -d ${databaseName} -t -c "select hash from sender where grouping = $file;")
    txInString=""
    logline=""
    totalLovelaces=0
    for hash in $hashes
    do
      txInString="${txInString} --tx-in ${hash}"
      buysAmount=$(psql -U ubuntu -d ${databaseName} -t -c "select buys from sender where hash = '${hash}';")
      for buyResult in $buysAmount
      do
        buys=$buyResult
      done
      costTotal=$(($nftCost * $buys))
      totalLovelaces=$(expr $totalLovelaces + $costTotal)
    done


    txOutCounter=2
    outString=""
    mintString=""
    metaString=""
    minValTotal=0
    jsonCounter=1
    txInCounter=0
    minterFeeTotal=0
    
    #Loop over list again
    for hash in $hashes
    do
      multiAsset=""
      assetString=""
      buysAmount=$(psql -U ubuntu -d ${databaseName} -t -c "select buys from sender where hash = '${hash}';")
      for buyResult in $buysAmount
      do
        buys=$buyResult
      done

      txOutCounter=$(expr $txOutCounter + 1)
      txInCounter=$(expr $txInCounter + 1)
      minterFeeBuys=$(($minterFee * $buys))

      minterFeeTotal=$(expr $minterFeeTotal + $minterFeeBuys)
      #trunced utxo hash used by blockfolio api to get the address
      utxoHashIndexTrunc=${hash%#*}

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


      buyCheck=1

      #If utxo has not been processed
      while [ $buyCheck -le $buys ]
      do
        #Select random number and ensure lock
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

        #IPFS
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

        if [ $jsonCounter -eq 1 ]
        then
          echo -n " {$line1: {$attr2: $line2, \"image\": \"$ipfsDetail\"" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${file}.json 
        else
          echo -n ", $line1: {$attr2: $line2, \"image\": \"$ipfsDetail\"" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${file}.json 
        fi
        

        if [ "${attr3}" != '""' ]
        then
          echo -n ", $attr3: $line3" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${file}.json 
        fi
        if [ "${attr4}" != '""' ]
        then
          echo -n ", $attr4: $line4" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${file}.json 
        fi
        if [ "${attr5}" != '""' ]
        then
          echo -n ", $attr5: $line5" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${file}.json 
        fi
        if [ "${attr6}" != '""' ]
        then
          echo -n ", $attr6: $line6" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${file}.json 
        fi
        if [ "${attr7}" != '""' ]
        then
          echo -n ", $attr7: $line7" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${file}.json 
        fi
        if [ "${attr8}" != '""' ]
        then
          echo -n ", $attr8: $line8" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${file}.json 
        fi
        if [ "${attr9}" != '""' ]
        then
          echo -n ", $attr9: $line9" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${file}.json 
        fi
        if [ "${attr10}" != '""' ]
        then
          echo -n ", $attr10: $line10" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${file}.json 
        fi
        if [ "${attr11}" != '""' ]
        then
          echo -n ", $attr11: $line11" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${file}.json 
        fi
        if [ "${attr12}" != '""' ]
        then
          echo -n ", $attr12: $line12" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${file}.json 
        fi
        if [ "${attr13}" != '""' ]
        then
          echo -n ", $attr13: $line13" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${file}.json 
        fi
        if [ "${attr14}" != '""' ]
        then
          echo -n ", $attr14: $line14" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${file}.json 
        fi
        if [ "${attr15}" != '""' ]
        then
          echo -n ", $attr15: $line15" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${file}.json 
        fi
        if [ "${attr16}" != '""' ]
        then
          echo -n ", $attr16: $line16" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${file}.json 
        fi
        if [ "${attr17}" != '""' ]
        then
          echo -n ", $attr17: $line17" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${file}.json 
        fi
        if [ "${attr18}" != '""' ]
        then
          echo -n ", $attr18: $line18" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${file}.json 
        fi
        if [ "${attr19}" != '""' ]
        then
          echo -n ", $attr19: $line19" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${file}.json 
        fi
        if [ "${attr20}" != '""' ]
        then
          echo -n ", $attr20: $line20" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${file}.json 
        fi
        echo -n "}" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${file}.json 

        jsonCounter=$(expr $jsonCounter + 1)
        

        #Calculate min val
        
        hexName=$(echo -n "${nftProject}${random}" | xxd -b -ps -c 80 | tr -d '\n')


        if [ "${multiAsset}" = "" ]
        then
          multiAsset="${receivingAddress}+200000+1 ${policyID}.${hexName}"
          assetString="1 ${policyID}.${hexName}"
        else
          multiAsset=${multiAsset}"+1 ${policyID}.${hexName}"
          assetString=$assetString"+1 ${policyID}.${hexName}"
        fi

        multiAsset=$(echo "${multiAsset}")



        if [ $buyCheck -eq $buys ]
        then
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
            outString="--tx-out \"$receivingAddress+$minVal+${assetString}\""  
          else
            outString="${outString} --tx-out \"$receivingAddress+$minVal+${assetString}\""
          fi

          if [ "$mintString" = "" ]
          then
            mintString=$assetString
          else
            mintString=$mintString+$assetString
          fi
        fi

        buyCheck=$(expr $buyCheck + 1)
      done

    done 
    echo -n "}}}" >> /home/ubuntu/${nftProject}/JSON/${nftProject}${file}.json

    metaString="--metadata-json-file /home/ubuntu/${nftProject}/JSON/${nftProject}${file}.json"

    mintString="\"${mintString}\""

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
      minfee=$(cardano-cli transaction calculate-min-fee --tx-body-file tx${session}.raw --tx-in-count $txInCounter --tx-out-count $txOutCounter --witness-count 1 --byron-witness-count 0 $networkParam --protocol-params-file protocol.json | awk '{ print $1 }');
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
    delete2=$(psql -U ubuntu -d ${databaseName} -t -c "delete from sender where grouping = $file;")
    file=$(expr $file + $sessions)

  fi

done