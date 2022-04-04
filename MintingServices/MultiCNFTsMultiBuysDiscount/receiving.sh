networkParam="$1"
number=$2
cost=$3
checkwallet=$4
perfile=$5
databaseName=$6
database=${7}
maxBuys=${8}
discountNftCost=${9}
policyID=${10}
policyID="\x$policyID"

checkUtxoJsonOld="a"
nftCounterCheck=0
fileCounter=1
grouping=0.5
soldOld=true

sql=$(psql -U ubuntu -d ${databaseName} -t -c "truncate table temp;")
rm utxo.txt

while $soldOld; do 
  #echo "receiving waiting"
  sleep 1
  sql=$(psql -U ubuntu -d ${databaseName} -t -c "select count(*) from sender where grouping = $grouping;")
  if [ $sql -gt 0 ]
  then
    groupingNew=$(echo $grouping + 0.5 | bc)
    update2=$(psql -U ubuntu -d ${databaseName} -t -c "update sender set grouping = ${groupingNew} where grouping = ${grouping};")
    grouping=$(echo $groupingNew + 0.5 | bc)
    nftCounterCheck=0
  fi

  checkUtxoJSON={}
  while [ "$checkUtxoJSON" = {} ]
  do
    checkUtxoJSON=$(cardano-cli query utxo $networkParam --address ${checkwallet} --out-file /dev/stdout); if [ $? -ne 0 ]; then checkUtxoJSON={}; fi;
    cardano-cli query utxo $networkParam --address ${checkwallet} > utxo.txt
    #echo "receiving waiting"
    sleep 1
  done
  
  if [ "${checkUtxoJSON}" != "${checkUtxoJsonOld}" ]
  then
    echo "receiving processing"
    checkUtxoJsonOld="${checkUtxoJSON}"

    finalCount=0
    finalString=""
    counter=0
    counter2=0
    hashCheck=""
    hashOne=""
    hashTwo=""
    hashThree=""
    hashFour=""
    hashFive=""
    hashSix=""
    hashSeven=""
    hashEight=""
    hashNine=""
    hashTen=""
    hashEleven=""
    hashTwelve=""
    hashThirteen=""
    hashFourteen=""
    hashFifteen=""
    hashSixteen=""
    hashSeventeen=""
    hashEighteen=""
    hashNineteen=""
    hashTwenty=""
    hashTwentyOne=""
    hashTwentyTwo=""
    hashTwentyThree=""
    hashTwentyFour=""
    hashTwentyFive=""
    hashTwentySix=""
    hashTwentySeven=""
    hashTwentyEight=""
    hashTwentyNine=""
    hashThirty=""
    hashThirtyOne=""
    hashThirtyTwo=""
    hashThirtyThree=""
    hashThirtyFour=""
    hashThirtyFive=""
    hashThirtySix=""
    hashThirtySeven=""
    hashThirtyEight=""
    hashThirtyNine=""
    hashFourty=""
    hashFourtyOne=""
    hashFourtyTwo=""
    hashFourtyThree=""
    hashFourtyFour=""
    hashFourtyFive=""
    hashFourtySix=""
    hashFourtySeven=""
    hashFourtyEight=""
    hashFourtyNine=""
    hashFifty=""
    hashFiftyOne=""
    hashFiftyTwo=""
    hashFiftyThree=""
    hashFiftyFour=""
    hashFiftyFive=""
    hashFiftySix=""
    hashFiftySeven=""
    hashFiftyEight=""
    hashFiftyNine=""
    hashSixty=""
    hashSixtyOne=""
    hashSixtyTwo=""
    hashSixtyThree=""
    hashSixtyFour=""
    hashSixtyFive=""
    hashSixtySix=""
    hashSixtySeven=""
    hashSixtyEight=""
    hashSixtyNine=""
    hashSeventy=""
    hashSeventyOne=""
    hashSeventyTwo=""
    hashSeventyThree=""
    hashSeventyFour=""
    hashSeventyFive=""
    hashSeventySix=""
    hashSeventySeven=""
    hashSeventyEight=""
    hashSeventyNine=""
    hashEighty=""
    hashEightyOne=""
    hashEightyTwo=""
    hashEightyThree=""
    hashEightyFour=""
    hashEightyFive=""
    hashEightySix=""
    hashEightySeven=""
    hashEightyEight=""
    hashEightyNine=""
    hashNinety=""
    hashNinetyOne=""
    hashNinetyTwo=""
    hashNinetyThree=""
    hashNinetyFour=""
    hashNinetyFive=""
    hashNinetySix=""
    hashNinetySeven=""
    hashNinetyEight=""
    hashNinetyNine=""
    hashOneHundred=""




    truncateWallets=$(psql -U ubuntu -d ${databaseName} -t -c "truncate table wallets")
    sqlWallets1=$(psql -U ubuntu -d ${database} -t -c "select distinct(address) from utxo_view where stake_address_id in (select distinct(uv.stake_address_id) from utxo_view uv inner join ma_tx_out mto on uv.id = mto.tx_out_id where uv.id in (select tx_out_id from ma_tx_out where ident in (select id from multi_asset where policy = '${policyID}')) and mto.ident in (select id from multi_asset where policy = '${policyID}') and uv.stake_address_id is not null);")
    sqlWallets2=$(psql -U ubuntu -d ${database} -t -c "select distinct(address) from utxo_view uv inner join ma_tx_out mto on uv.id = mto.tx_out_id where uv.id in (select tx_out_id from ma_tx_out where ident in (select id from multi_asset where policy = '${policyID}')) and mto.ident in (select id from multi_asset where policy = '${policyID}') and uv.stake_address_id is null;")

    for AddressResult in $sqlWallets1
    do
      insert1=$(psql -U ubuntu -d ${databaseName} -t -c "insert into wallets(wallet) values ('${AddressResult}')")
    done
    for AddressResult in $sqlWallets2
    do
      insert2=$(psql -U ubuntu -d ${databaseName} -t -c "insert into wallets(wallet) values ('${AddressResult}')")
    done

    while read utxoHash index amount; do
      counter=$(expr $counter + 1)
      if [ $counter -gt 2 ]
      then 
        utxoHashIndex=$utxoHash#$index
        utxoHashIndexTrunc=$utxoHash
        checkUtxoAmount=$(echo $amount | tr -dc '0-9')
        hash="\x$utxoHashIndexTrunc"

        size=0
        while [ $size -eq 0 ]
        do
          sql=$(psql -U ubuntu -d ${database} -t -c "select address from tx_out where tx_id = (select id from tx where hash = '${hash}') and address != '${receivingAdd}'")
          size=${#sql}
        done
        for result in $sql
        do
          receivingAddress=$result
        done


        checkAddress=$(psql -U ubuntu -d ${databaseName} -t -A -c "select count(*) from wallets where wallet = '${receivingAddress}'")
        if [ $checkAddress -gt 0 ]
        then
          buys=$(expr $checkUtxoAmount / $discountNftCost)
          remain=$(expr $checkUtxoAmount % $discountNftCost)
          discount=1
        else
          buys=$(expr $checkUtxoAmount / $cost)
          remain=$(expr $checkUtxoAmount % $cost)
          discount=0
        fi


        if [ $buys -le $maxBuys -a $remain -eq 0 ]
        then
          check=""
          check=$(psql -U ubuntu -d ${databaseName} -t -c "select hash from log where hash = '${utxoHashIndex}';")
          if [ "${check}" = "" ]
          then
            
            counter2=$(expr $counter2 + 1)
            if [ "${hashCheck}" = "" ]
            then
              hashCheck=\'${hash}\'
            else
              hashCheck=${hashCheck},\'${hash}\'
            fi

            if [ "${hashOne}" = "" ]
            then
              hashOne=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashTwo}" = "" ]
            then
              hashTwo=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashThree}" = "" ]
            then
              hashThree=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashFour}" = "" ]
            then
              hashFour=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashFive}" = "" ]
            then
              hashFive=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashSix}" = "" ]
            then
              hashSix=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashSeven}" = "" ]
            then
              hashSeven=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashEight}" = "" ]
            then
              hashEight=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashNine}" = "" ]
            then
              hashNine=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashTen}" = "" ]
            then
              hashTen=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashEleven}" = "" ]
            then
              hashEleven=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashTwelve}" = "" ]
            then
              hashTwelve=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashThirteen}" = "" ]
            then
              hashThirteen=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashFourteen}" = "" ]
            then
              hashFourteen=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashFifteen}" = "" ]
            then
              hashFifteen=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashSixteen}" = "" ]
            then
              hashSixteen=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashSeventeen}" = "" ]
            then
              hashSeventeen=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashEighteen}" = "" ]
            then
              hashEighteen=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashNineteen}" = "" ]
            then
              hashNineteen=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashTwenty}" = "" ]
            then
              hashTwenty=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashTwentyOne}" = "" ]
            then
              hashTwentyOne=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashTwentyTwo}" = "" ]
            then
              hashTwentyTwo=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashTwentyThree}" = "" ]
            then
              hashTwentyThree=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashTwentyFour}" = "" ]
            then
              hashTwentyFour=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashTwentyFive}" = "" ]
            then
              hashTwentyFive=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashTwentySix}" = "" ]
            then
              hashTwentySix=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashTwentySeven}" = "" ]
            then
              hashTwentySeven=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashTwentyEight}" = "" ]
            then
              hashTwentyEight=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashTwentyNine}" = "" ]
            then
              hashTwentyNine=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashThirty}" = "" ]
            then
              hashThirty=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashThirtyOne}" = "" ]
            then
              hashThirtyOne=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashThirtyTwo}" = "" ]
            then
              hashThirtyTwo=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashThirtyThree}" = "" ]
            then
              hashThirtyThree=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashThirtyFour}" = "" ]
            then
              hashThirtyFour=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashThirtyFive}" = "" ]
            then
              hashThirtyFive=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashThirtySix}" = "" ]
            then
              hashThirtySix=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashThirtySeven}" = "" ]
            then
              hashThirtySeven=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashThirtyEight}" = "" ]
            then
              hashThirtyEight=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashThirtyNine}" = "" ]
            then
              hashThirtyNine=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashFourty}" = "" ]
            then
              hashFourty=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashFourtyOne}" = "" ]
            then
              hashFourtyOne=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashFourtyTwo}" = "" ]
            then
              hashFourtyTwo=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashFourtyThree}" = "" ]
            then
              hashFourtyThree=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashFourtyFour}" = "" ]
            then
              hashFourtyFour=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashFourtyFive}" = "" ]
            then
              hashFourtyFive=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashFourtySix}" = "" ]
            then
              hashFourtySix=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashFourtySeven}" = "" ]
            then
              hashFourtySeven=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashFourtyEight}" = "" ]
            then
              hashFourtyEight=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashFourtyNine}" = "" ]
            then
              hashFourtyNine=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashFifty}" = "" ]
            then
              hashFifty=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashFiftyOne}" = "" ]
            then
              hashFiftyOne=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashFiftyTwo}" = "" ]
            then
              hashFiftyTwo=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashFiftyThree}" = "" ]
            then
              hashFiftyThree=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashFiftyFour}" = "" ]
            then
              hashFiftyFour=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashFiftyFive}" = "" ]
            then
              hashFiftyFive=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashFiftySix}" = "" ]
            then
              hashFiftySix=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashFiftySeven}" = "" ]
            then
              hashFiftySeven=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashFiftyEight}" = "" ]
            then
              hashFiftyEight=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashFiftyNine}" = "" ]
            then
              hashFiftyNine=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashSixty}" = "" ]
            then
              hashSixty=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashSixtyOne}" = "" ]
            then
              hashSixtyOne=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashSixtyTwo}" = "" ]
            then
              hashSixtyTwo=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashSixtyThree}" = "" ]
            then
              hashSixtyThree=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashSixtyFour}" = "" ]
            then
              hashSixtyFour=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashSixtyFive}" = "" ]
            then
              hashSixtyFive=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashSixtySix}" = "" ]
            then
              hashSixtySix=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashSixtySeven}" = "" ]
            then
              hashSixtySeven=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashSixtyEight}" = "" ]
            then
              hashSixtyEight=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashSixtyNine}" = "" ]
            then
              hashSixtyNine=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashSeventy}" = "" ]
            then
              hashSeventy=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashSeventyOne}" = "" ]
            then
              hashSeventyOne=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashSeventyTwo}" = "" ]
            then
              hashSeventyTwo=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashSeventyThree}" = "" ]
            then
              hashSeventyThree=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashSeventyFour}" = "" ]
            then
              hashSeventyFour=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashSeventyFive}" = "" ]
            then
              hashSeventyFive=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashSeventySix}" = "" ]
            then
              hashSeventySix=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashSeventySeven}" = "" ]
            then
              hashSeventySeven=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashSeventyEight}" = "" ]
            then
              hashSeventyEight=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashSeventyNine}" = "" ]
            then
              hashSeventyNine=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashEighty}" = "" ]
            then
              hashEighty=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashEightyOne}" = "" ]
            then
              hashEightyOne=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashEightyTwo}" = "" ]
            then
              hashEightyTwo=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashEightyThree}" = "" ]
            then
              hashEightyThree=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashEightyFour}" = "" ]
            then
              hashEightyFour=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashEightyFive}" = "" ]
            then
              hashEightyFive=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashEightySix}" = "" ]
            then
              hashEightySix=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashEightySeven}" = "" ]
            then
              hashEightySeven=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashEightyEight}" = "" ]
            then
              hashEightyEight=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashEightyNine}" = "" ]
            then
              hashEightyNine=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashNinety}" = "" ]
            then
              hashNinety=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashNinetyOne}" = "" ]
            then
              hashNinetyOne=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashNinetyTwo}" = "" ]
            then
              hashNinetyTwo=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashNinetyThree}" = "" ]
            then
              hashNinetyThree=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashNinetyFour}" = "" ]
            then
              hashNinetyFour=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashNinetyFive}" = "" ]
            then
              hashNinetyFive=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashNinetySix}" = "" ]
            then
              hashNinetySix=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashNinetySeven}" = "" ]
            then
              hashNinetySeven=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashNinetyEight}" = "" ]
            then
              hashNinetyEight=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashNinetyNine}" = "" ]
            then
              hashNinetyNine=\'${utxoHashIndex}\',$buys,$discount
            elif [ "${hashOneHundred}" = "" ]
            then
              hashOneHundred=\'${utxoHashIndex}\',$buys,$discount   
            fi


            if [ $counter2 -eq 100 ]
            then

              sql=$(psql -U ubuntu -d ${database} -t -A -c "select block.block_no, tx.id, tx.block_index from tx inner join block on tx.block_id = block.id where tx.hash in (${hashCheck});")

              resultString=""
              resultCounter=0
              for result in $sql
              do
                resultCounter=$(expr $resultCounter + 1)
                resultString=$(echo $result | tr '|' ',')
                if [ $resultCounter -eq 1 ]
                then
                  resultString=$resultString,$hashOne
                elif [ $resultCounter -eq 2 ]
                then
                  resultString=$resultString,$hashTwo
                elif [ $resultCounter -eq 3 ]
                then      
                  resultString=$resultString,$hashThree
                elif [ $resultCounter -eq 4 ]
                then
                  resultString=$resultString,$hashFour
                elif [ $resultCounter -eq 5 ]
                then
                  resultString=$resultString,$hashFive
                elif [ $resultCounter -eq 6 ]
                then
                  resultString=$resultString,$hashSix
                elif [ $resultCounter -eq 7 ]
                then
                  resultString=$resultString,$hashSeven
                elif [ $resultCounter -eq 8 ]
                then
                  resultString=$resultString,$hashEight
                elif [ $resultCounter -eq 9 ]
                then
                  resultString=$resultString,$hashNine
                elif [ $resultCounter -eq 10 ]
                then
                  resultString=$resultString,$hashTen
                elif [ $resultCounter -eq 11 ]
                then
                  resultString=$resultString,$hashEleven
                elif [ $resultCounter -eq 12 ]
                then      
                  resultString=$resultString,$hashTwelve
                elif [ $resultCounter -eq 13 ]
                then
                  resultString=$resultString,$hashThirteen
                elif [ $resultCounter -eq 14 ]
                then
                  resultString=$resultString,$hashFourteen
                elif [ $resultCounter -eq 15 ]
                then
                  resultString=$resultString,$hashFifteen
                elif [ $resultCounter -eq 16 ]
                then
                  resultString=$resultString,$hashSixteen
                elif [ $resultCounter -eq 17 ]
                then
                  resultString=$resultString,$hashSeventeen
                elif [ $resultCounter -eq 18 ]
                then
                  resultString=$resultString,$hashEighteen
                elif [ $resultCounter -eq 19 ]
                then
                  resultString=$resultString,$hashNineteen
                elif [ $resultCounter -eq 20 ]
                then
                  resultString=$resultString,$hashTwenty
                elif [ $resultCounter -eq 21 ]
                then
                  resultString=$resultString,$hashTwentyOne
                elif [ $resultCounter -eq 22 ]
                then
                  resultString=$resultString,$hashTwentyTwo
                elif [ $resultCounter -eq 23 ]
                then
                  resultString=$resultString,$hashTwentyThree
                elif [ $resultCounter -eq 24 ]
                then
                  resultString=$resultString,$hashTwentyFour
                elif [ $resultCounter -eq 25 ]
                then
                  resultString=$resultString,$hashTwentyFive
                elif [ $resultCounter -eq 26 ]
                then
                  resultString=$resultString,$hashTwentySix
                elif [ $resultCounter -eq 27 ]
                then
                  resultString=$resultString,$hashTwentySeven
                elif [ $resultCounter -eq 28 ]
                then
                  resultString=$resultString,$hashTwentyEight
                elif [ $resultCounter -eq 29 ]
                then
                  resultString=$resultString,$hashTwentyNine
                elif [ $resultCounter -eq 30 ]
                then
                  resultString=$resultString,$hashThirty
                elif [ $resultCounter -eq 31 ]
                then
                  resultString=$resultString,$hashThirtyOne
                elif [ $resultCounter -eq 32 ]
                then
                  resultString=$resultString,$hashThirtyTwo
                elif [ $resultCounter -eq 33 ]
                then
                  resultString=$resultString,$hashThirtyThree
                elif [ $resultCounter -eq 34 ]
                then
                  resultString=$resultString,$hashThirtyFour
                elif [ $resultCounter -eq 35 ]
                then
                  resultString=$resultString,$hashThirtyFive
                elif [ $resultCounter -eq 36 ]
                then
                  resultString=$resultString,$hashThirtySix
                elif [ $resultCounter -eq 37 ]
                then
                  resultString=$resultString,$hashThirtySeven
                elif [ $resultCounter -eq 38 ]
                then
                  resultString=$resultString,$hashThirtyEight
                elif [ $resultCounter -eq 39 ]
                then
                  resultString=$resultString,$hashThirtyNine
                elif [ $resultCounter -eq 40 ]
                then
                  resultString=$resultString,$hashFourty
                elif [ $resultCounter -eq 41 ]
                then
                  resultString=$resultString,$hashFourtyOne
                elif [ $resultCounter -eq 42 ]
                then
                  resultString=$resultString,$hashFourtyTwo
                elif [ $resultCounter -eq 43 ]
                then
                  resultString=$resultString,$hashFourtyThree
                elif [ $resultCounter -eq 44 ]
                then
                  resultString=$resultString,$hashFourtyFour
                elif [ $resultCounter -eq 45 ]
                then
                  resultString=$resultString,$hashFourtyFive
                elif [ $resultCounter -eq 46 ]
                then
                  resultString=$resultString,$hashFourtySix
                elif [ $resultCounter -eq 47 ]
                then
                  resultString=$resultString,$hashFourtySeven
                elif [ $resultCounter -eq 48 ]
                then
                  resultString=$resultString,$hashFourtyEight
                elif [ $resultCounter -eq 49 ]
                then
                  resultString=$resultString,$hashFourtyNine
                elif [ $resultCounter -eq 50 ]
                then
                  resultString=$resultString,$hashFifty
                elif [ $resultCounter -eq 51 ]
                then
                  resultString=$resultString,$hashFiftyOne
                elif [ $resultCounter -eq 52 ]
                then
                  resultString=$resultString,$hashFiftyTwo
                elif [ $resultCounter -eq 53 ]
                then
                  resultString=$resultString,$hashFiftyThree
                elif [ $resultCounter -eq 54 ]
                then
                  resultString=$resultString,$hashFiftyFour
                elif [ $resultCounter -eq 55 ]
                then
                  resultString=$resultString,$hashFiftyFive
                elif [ $resultCounter -eq 56 ]
                then
                  resultString=$resultString,$hashFiftySix
                elif [ $resultCounter -eq 57 ]
                then
                  resultString=$resultString,$hashFiftySeven
                elif [ $resultCounter -eq 58 ]
                then
                  resultString=$resultString,$hashFiftyEight
                elif [ $resultCounter -eq 59 ]
                then
                  resultString=$resultString,$hashFiftyNine
                elif [ $resultCounter -eq 60 ]
                then
                  resultString=$resultString,$hashSixty
                 elif [ $resultCounter -eq 61 ]
                then
                  resultString=$resultString,$hashSixtyOne
                elif [ $resultCounter -eq 62 ]
                then
                  resultString=$resultString,$hashSixtyTwo
                elif [ $resultCounter -eq 63 ]
                then
                  resultString=$resultString,$hashSixtyThree
                elif [ $resultCounter -eq 64 ]
                then
                  resultString=$resultString,$hashSixtyFour
                elif [ $resultCounter -eq 65 ]
                then
                  resultString=$resultString,$hashSixtyFive
                elif [ $resultCounter -eq 66 ]
                then
                  resultString=$resultString,$hashSixtySix
                elif [ $resultCounter -eq 67 ]
                then
                  resultString=$resultString,$hashSixtySeven
                elif [ $resultCounter -eq 68 ]
                then
                  resultString=$resultString,$hashSixtyEight
                elif [ $resultCounter -eq 69 ]
                then
                  resultString=$resultString,$hashSixtyNine
                elif [ $resultCounter -eq 70 ]
                then
                  resultString=$resultString,$hashSeventy    
                elif [ $resultCounter -eq 71 ]
                then
                  resultString=$resultString,$hashSeventyOne
                elif [ $resultCounter -eq 72 ]
                then
                  resultString=$resultString,$hashSeventyTwo
                elif [ $resultCounter -eq 73 ]
                then
                  resultString=$resultString,$hashSeventyThree
                elif [ $resultCounter -eq 74 ]
                then
                  resultString=$resultString,$hashSeventyFour
                elif [ $resultCounter -eq 75 ]
                then
                  resultString=$resultString,$hashSeventyFive
                elif [ $resultCounter -eq 76 ]
                then
                  resultString=$resultString,$hashSeventySix
                elif [ $resultCounter -eq 77 ]
                then
                  resultString=$resultString,$hashSeventySeven
                elif [ $resultCounter -eq 78 ]
                then
                  resultString=$resultString,$hashSeventyEight
                elif [ $resultCounter -eq 79 ]
                then
                  resultString=$resultString,$hashSeventyNine
                elif [ $resultCounter -eq 80 ]
                then
                  resultString=$resultString,$hashEighty
                elif [ $resultCounter -eq 81 ]
                then
                  resultString=$resultString,$hashEightyOne
                elif [ $resultCounter -eq 82 ]
                then
                  resultString=$resultString,$hashEightyTwo
                elif [ $resultCounter -eq 83 ]
                then
                  resultString=$resultString,$hashEightyThree
                elif [ $resultCounter -eq 84 ]
                then
                  resultString=$resultString,$hashEightyFour
                elif [ $resultCounter -eq 85 ]
                then
                  resultString=$resultString,$hashEightyFive
                elif [ $resultCounter -eq 86 ]
                then
                  resultString=$resultString,$hashEightySix
                elif [ $resultCounter -eq 87 ]
                then
                  resultString=$resultString,$hashEightySeven
                elif [ $resultCounter -eq 88 ]
                then
                  resultString=$resultString,$hashEightyEight
                elif [ $resultCounter -eq 89 ]
                then
                  resultString=$resultString,$hashEightyNine
                elif [ $resultCounter -eq 90 ]
                then
                  resultString=$resultString,$hashNinety
                elif [ $resultCounter -eq 91 ]
                then
                  resultString=$resultString,$hashNinetyOne
                elif [ $resultCounter -eq 92 ]
                then
                  resultString=$resultString,$hashNinetyTwo
                elif [ $resultCounter -eq 93 ]
                then
                  resultString=$resultString,$hashNinetyThree
                elif [ $resultCounter -eq 94 ]
                then
                  resultString=$resultString,$hashNinetyFour
                elif [ $resultCounter -eq 95 ]
                then
                  resultString=$resultString,$hashNinetyFive
                elif [ $resultCounter -eq 96 ]
                then
                  resultString=$resultString,$hashNinetySix
                elif [ $resultCounter -eq 97 ]
                then
                  resultString=$resultString,$hashNinetySeven
                elif [ $resultCounter -eq 98 ]
                then
                  resultString=$resultString,$hashNinetyEight
                elif [ $resultCounter -eq 99 ]
                then
                  resultString=$resultString,$hashNinetyNine
                elif [ $resultCounter -eq 100 ]
                then
                  resultString=$resultString,$hashOneHundred            
                fi

                finalCount=$(expr $finalCount + 1)
                if [ $finalCount -eq 1 ]
                then
                  finalString="(${resultString})"
                else
                  finalString="${finalString}, (${resultString})"
                fi

              done

              insert=$(psql -U ubuntu -d ${databaseName} -t -c "insert into temp(block_no, tx_id, block_index, hash, buys, discount) values ${finalString};")
              finalString=""
              finalCount=0
              counter2=0
              hashCheck=""
              hashOne=""
              hashTwo=""
              hashThree=""
              hashFour=""
              hashFive=""
              hashSix=""
              hashSeven=""
              hashEight=""
              hashNine=""
              hashTen=""
              hashEleven=""
              hashTwelve=""
              hashThirteen=""
              hashFourteen=""
              hashFifteen=""
              hashSixteen=""
              hashSeventeen=""
              hashEighteen=""
              hashNineteen=""
              hashTwenty=""
              hashTwentyOne=""
              hashTwentyTwo=""
              hashTwentyThree=""
              hashTwentyFour=""
              hashTwentyFive=""
              hashTwentySix=""
              hashTwentySeven=""
              hashTwentyEight=""
              hashTwentyNine=""
              hashThirty=""
              hashThirtyOne=""
              hashThirtyTwo=""
              hashThirtyThree=""
              hashThirtyFour=""
              hashThirtyFive=""
              hashThirtySix=""
              hashThirtySeven=""
              hashThirtyEight=""
              hashThirtyNine=""
              hashFourty=""
              hashFourtyOne=""
              hashFourtyTwo=""
              hashFourtyThree=""
              hashFourtyFour=""
              hashFourtyFive=""
              hashFourtySix=""
              hashFourtySeven=""
              hashFourtyEight=""
              hashFourtyNine=""
              hashFifty=""
              hashFiftyOne=""
              hashFiftyTwo=""
              hashFiftyThree=""
              hashFiftyFour=""
              hashFiftyFive=""
              hashFiftySix=""
              hashFiftySeven=""
              hashFiftyEight=""
              hashFiftyNine=""
              hashSixty=""
              hashSixtyOne=""
              hashSixtyTwo=""
              hashSixtyThree=""
              hashSixtyFour=""
              hashSixtyFive=""
              hashSixtySix=""
              hashSixtySeven=""
              hashSixtyEight=""
              hashSixtyNine=""
              hashSeventy=""
              hashSeventyOne=""
              hashSeventyTwo=""
              hashSeventyThree=""
              hashSeventyFour=""
              hashSeventyFive=""
              hashSeventySix=""
              hashSeventySeven=""
              hashSeventyEight=""
              hashSeventyNine=""
              hashEighty=""
              hashEightyOne=""
              hashEightyTwo=""
              hashEightyThree=""
              hashEightyFour=""
              hashEightyFive=""
              hashEightySix=""
              hashEightySeven=""
              hashEightyEight=""
              hashEightyNine=""
              hashNinety=""
              hashNinetyOne=""
              hashNinetyTwo=""
              hashNinetyThree=""
              hashNinetyFour=""
              hashNinetyFive=""
              hashNinetySix=""
              hashNinetySeven=""
              hashNinetyEight=""
              hashNinetyNine=""
              hashOneHundred=""
            fi
          fi
        fi
      fi 
    done < utxo.txt

    if [ $counter2 -gt 0 ]
    then

      sql=$(psql -U ubuntu -d ${database} -t -A -c "select block.block_no, tx.id, tx.block_index from tx inner join block on tx.block_id = block.id where tx.hash in (${hashCheck});")
      resultString=""
      resultCounter=0
      for result in $sql
      do
        resultCounter=$(expr $resultCounter + 1)

        resultString=$(echo $result | tr '|' ',')

        if [ $resultCounter -eq 1 ]
        then
          resultString=$resultString,$hashOne
        elif [ $resultCounter -eq 2 ]
        then
          resultString=$resultString,$hashTwo
        elif [ $resultCounter -eq 3 ]
        then      
          resultString=$resultString,$hashThree
        elif [ $resultCounter -eq 4 ]
        then
          resultString=$resultString,$hashFour
        elif [ $resultCounter -eq 5 ]
        then
          resultString=$resultString,$hashFive
        elif [ $resultCounter -eq 6 ]
        then
          resultString=$resultString,$hashSix
        elif [ $resultCounter -eq 7 ]
        then
          resultString=$resultString,$hashSeven
        elif [ $resultCounter -eq 8 ]
        then
          resultString=$resultString,$hashEight
        elif [ $resultCounter -eq 9 ]
        then
          resultString=$resultString,$hashNine
        elif [ $resultCounter -eq 10 ]
        then
          resultString=$resultString,$hashTen
        elif [ $resultCounter -eq 11 ]
        then
          resultString=$resultString,$hashEleven
        elif [ $resultCounter -eq 12 ]
        then      
          resultString=$resultString,$hashTwelve
        elif [ $resultCounter -eq 13 ]
        then
          resultString=$resultString,$hashThirteen
        elif [ $resultCounter -eq 14 ]
        then
          resultString=$resultString,$hashFourteen
        elif [ $resultCounter -eq 15 ]
        then
          resultString=$resultString,$hashFifteen
        elif [ $resultCounter -eq 16 ]
        then
          resultString=$resultString,$hashSixteen
        elif [ $resultCounter -eq 17 ]
        then
          resultString=$resultString,$hashSeventeen
        elif [ $resultCounter -eq 18 ]
        then
          resultString=$resultString,$hashEighteen
        elif [ $resultCounter -eq 19 ]
        then
          resultString=$resultString,$hashNineteen
        elif [ $resultCounter -eq 20 ]
        then
          resultString=$resultString,$hashTwenty
        elif [ $resultCounter -eq 21 ]
        then
          resultString=$resultString,$hashTwentyOne
        elif [ $resultCounter -eq 22 ]
        then
          resultString=$resultString,$hashTwentyTwo
        elif [ $resultCounter -eq 23 ]
        then
          resultString=$resultString,$hashTwentyThree
        elif [ $resultCounter -eq 24 ]
        then
          resultString=$resultString,$hashTwentyFour
        elif [ $resultCounter -eq 25 ]
        then
          resultString=$resultString,$hashTwentyFive
        elif [ $resultCounter -eq 26 ]
        then
          resultString=$resultString,$hashTwentySix
        elif [ $resultCounter -eq 27 ]
        then
          resultString=$resultString,$hashTwentySeven
        elif [ $resultCounter -eq 28 ]
        then
          resultString=$resultString,$hashTwentyEight
        elif [ $resultCounter -eq 29 ]
        then
          resultString=$resultString,$hashTwentyNine
        elif [ $resultCounter -eq 30 ]
        then
          resultString=$resultString,$hashThirty
        elif [ $resultCounter -eq 31 ]
        then
          resultString=$resultString,$hashThirtyOne
        elif [ $resultCounter -eq 32 ]
        then
          resultString=$resultString,$hashThirtyTwo
        elif [ $resultCounter -eq 33 ]
        then
          resultString=$resultString,$hashThirtyThree
        elif [ $resultCounter -eq 34 ]
        then
          resultString=$resultString,$hashThirtyFour
        elif [ $resultCounter -eq 35 ]
        then
          resultString=$resultString,$hashThirtyFive
        elif [ $resultCounter -eq 36 ]
        then
          resultString=$resultString,$hashThirtySix
        elif [ $resultCounter -eq 37 ]
        then
          resultString=$resultString,$hashThirtySeven
        elif [ $resultCounter -eq 38 ]
        then
          resultString=$resultString,$hashThirtyEight
        elif [ $resultCounter -eq 39 ]
        then
          resultString=$resultString,$hashThirtyNine
        elif [ $resultCounter -eq 40 ]
        then
          resultString=$resultString,$hashFourty
        elif [ $resultCounter -eq 41 ]
        then
          resultString=$resultString,$hashFourtyOne
        elif [ $resultCounter -eq 42 ]
        then
          resultString=$resultString,$hashFourtyTwo
        elif [ $resultCounter -eq 43 ]
        then
          resultString=$resultString,$hashFourtyThree
        elif [ $resultCounter -eq 44 ]
        then
          resultString=$resultString,$hashFourtyFour
        elif [ $resultCounter -eq 45 ]
        then
          resultString=$resultString,$hashFourtyFive
        elif [ $resultCounter -eq 46 ]
        then
          resultString=$resultString,$hashFourtySix
        elif [ $resultCounter -eq 47 ]
        then
          resultString=$resultString,$hashFourtySeven
        elif [ $resultCounter -eq 48 ]
        then
          resultString=$resultString,$hashFourtyEight
        elif [ $resultCounter -eq 49 ]
        then
          resultString=$resultString,$hashFourtyNine
        elif [ $resultCounter -eq 50 ]
        then
          resultString=$resultString,$hashFifty
        elif [ $resultCounter -eq 51 ]
        then
          resultString=$resultString,$hashFiftyOne
        elif [ $resultCounter -eq 52 ]
        then
          resultString=$resultString,$hashFiftyTwo
        elif [ $resultCounter -eq 53 ]
        then
          resultString=$resultString,$hashFiftyThree
        elif [ $resultCounter -eq 54 ]
        then
          resultString=$resultString,$hashFiftyFour
        elif [ $resultCounter -eq 55 ]
        then
          resultString=$resultString,$hashFiftyFive
        elif [ $resultCounter -eq 56 ]
        then
          resultString=$resultString,$hashFiftySix
        elif [ $resultCounter -eq 57 ]
        then
          resultString=$resultString,$hashFiftySeven
        elif [ $resultCounter -eq 58 ]
        then
          resultString=$resultString,$hashFiftyEight
        elif [ $resultCounter -eq 59 ]
        then
          resultString=$resultString,$hashFiftyNine
        elif [ $resultCounter -eq 60 ]
        then
          resultString=$resultString,$hashSixty
         elif [ $resultCounter -eq 61 ]
        then
          resultString=$resultString,$hashSixtyOne
        elif [ $resultCounter -eq 62 ]
        then
          resultString=$resultString,$hashSixtyTwo
        elif [ $resultCounter -eq 63 ]
        then
          resultString=$resultString,$hashSixtyThree
        elif [ $resultCounter -eq 64 ]
        then
          resultString=$resultString,$hashSixtyFour
        elif [ $resultCounter -eq 65 ]
        then
          resultString=$resultString,$hashSixtyFive
        elif [ $resultCounter -eq 66 ]
        then
          resultString=$resultString,$hashSixtySix
        elif [ $resultCounter -eq 67 ]
        then
          resultString=$resultString,$hashSixtySeven
        elif [ $resultCounter -eq 68 ]
        then
          resultString=$resultString,$hashSixtyEight
        elif [ $resultCounter -eq 69 ]
        then
          resultString=$resultString,$hashSixtyNine
        elif [ $resultCounter -eq 70 ]
        then
          resultString=$resultString,$hashSeventy    
        elif [ $resultCounter -eq 71 ]
        then
          resultString=$resultString,$hashSeventyOne
        elif [ $resultCounter -eq 72 ]
        then
          resultString=$resultString,$hashSeventyTwo
        elif [ $resultCounter -eq 73 ]
        then
          resultString=$resultString,$hashSeventyThree
        elif [ $resultCounter -eq 74 ]
        then
          resultString=$resultString,$hashSeventyFour
        elif [ $resultCounter -eq 75 ]
        then
          resultString=$resultString,$hashSeventyFive
        elif [ $resultCounter -eq 76 ]
        then
          resultString=$resultString,$hashSeventySix
        elif [ $resultCounter -eq 77 ]
        then
          resultString=$resultString,$hashSeventySeven
        elif [ $resultCounter -eq 78 ]
        then
          resultString=$resultString,$hashSeventyEight
        elif [ $resultCounter -eq 79 ]
        then
          resultString=$resultString,$hashSeventyNine
        elif [ $resultCounter -eq 80 ]
        then
          resultString=$resultString,$hashEighty
        elif [ $resultCounter -eq 81 ]
        then
          resultString=$resultString,$hashEightyOne
        elif [ $resultCounter -eq 82 ]
        then
          resultString=$resultString,$hashEightyTwo
        elif [ $resultCounter -eq 83 ]
        then
          resultString=$resultString,$hashEightyThree
        elif [ $resultCounter -eq 84 ]
        then
          resultString=$resultString,$hashEightyFour
        elif [ $resultCounter -eq 85 ]
        then
          resultString=$resultString,$hashEightyFive
        elif [ $resultCounter -eq 86 ]
        then
          resultString=$resultString,$hashEightySix
        elif [ $resultCounter -eq 87 ]
        then
          resultString=$resultString,$hashEightySeven
        elif [ $resultCounter -eq 88 ]
        then
          resultString=$resultString,$hashEightyEight
        elif [ $resultCounter -eq 89 ]
        then
          resultString=$resultString,$hashEightyNine
        elif [ $resultCounter -eq 90 ]
        then
          resultString=$resultString,$hashNinety
        elif [ $resultCounter -eq 91 ]
        then
          resultString=$resultString,$hashNinetyOne
        elif [ $resultCounter -eq 92 ]
        then
          resultString=$resultString,$hashNinetyTwo
        elif [ $resultCounter -eq 93 ]
        then
          resultString=$resultString,$hashNinetyThree
        elif [ $resultCounter -eq 94 ]
        then
          resultString=$resultString,$hashNinetyFour
        elif [ $resultCounter -eq 95 ]
        then
          resultString=$resultString,$hashNinetyFive
        elif [ $resultCounter -eq 96 ]
        then
          resultString=$resultString,$hashNinetySix
        elif [ $resultCounter -eq 97 ]
        then
          resultString=$resultString,$hashNinetySeven
        elif [ $resultCounter -eq 98 ]
        then
          resultString=$resultString,$hashNinetyEight
        elif [ $resultCounter -eq 99 ]
        then
          resultString=$resultString,$hashNinetyNine
        elif [ $resultCounter -eq 100 ]
        then
          resultString=$resultString,$hashOneHundred
        fi

        finalCount=$(expr $finalCount + 1)
        if [ $finalCount -eq 1 ]
        then
          finalString="(${resultString})"
        else
          finalString="${finalString}, (${resultString})"
        fi

      done
       
      insert=$(psql -U ubuntu -d ${databaseName} -t -c "insert into temp(block_no, tx_id, block_index, hash, buys, discount) values ${finalString};")
      finalString=""
      finalCount=0
      counter2=0
      hashCheck=""
      hashOne=""
      hashTwo=""
      hashThree=""
      hashFour=""
      hashFive=""
      hashSix=""
      hashSeven=""
      hashEight=""
      hashNine=""
      hashTen=""
      hashEleven=""
      hashTwelve=""
      hashThirteen=""
      hashFourteen=""
      hashFifteen=""
      hashSixteen=""
      hashSeventeen=""
      hashEighteen=""
      hashNineteen=""
      hashTwenty=""
      hashTwentyOne=""
      hashTwentyTwo=""
      hashTwentyThree=""
      hashTwentyFour=""
      hashTwentyFive=""
      hashTwentySix=""
      hashTwentySeven=""
      hashTwentyEight=""
      hashTwentyNine=""
      hashThirty=""
      hashThirtyOne=""
      hashThirtyTwo=""
      hashThirtyThree=""
      hashThirtyFour=""
      hashThirtyFive=""
      hashThirtySix=""
      hashThirtySeven=""
      hashThirtyEight=""
      hashThirtyNine=""
      hashFourty=""
      hashFourtyOne=""
      hashFourtyTwo=""
      hashFourtyThree=""
      hashFourtyFour=""
      hashFourtyFive=""
      hashFourtySix=""
      hashFourtySeven=""
      hashFourtyEight=""
      hashFourtyNine=""
      hashFifty=""
      hashFiftyOne=""
      hashFiftyTwo=""
      hashFiftyThree=""
      hashFiftyFour=""
      hashFiftyFive=""
      hashFiftySix=""
      hashFiftySeven=""
      hashFiftyEight=""
      hashFiftyNine=""
      hashSixty=""
      hashSixtyOne=""
      hashSixtyTwo=""
      hashSixtyThree=""
      hashSixtyFour=""
      hashSixtyFive=""
      hashSixtySix=""
      hashSixtySeven=""
      hashSixtyEight=""
      hashSixtyNine=""
      hashSeventy=""
      hashSeventyOne=""
      hashSeventyTwo=""
      hashSeventyThree=""
      hashSeventyFour=""
      hashSeventyFive=""
      hashSeventySix=""
      hashSeventySeven=""
      hashSeventyEight=""
      hashSeventyNine=""
      hashEighty=""
      hashEightyOne=""
      hashEightyTwo=""
      hashEightyThree=""
      hashEightyFour=""
      hashEightyFive=""
      hashEightySix=""
      hashEightySeven=""
      hashEightyEight=""
      hashEightyNine=""
      hashNinety=""
      hashNinetyOne=""
      hashNinetyTwo=""
      hashNinetyThree=""
      hashNinetyFour=""
      hashNinetyFive=""
      hashNinetySix=""
      hashNinetySeven=""
      hashNinetyEight=""
      hashNinetyNine=""
      hashOneHundred=""

    fi

    sql=$(psql -U ubuntu -d ${databaseName} -t -c "select hash from temp order by block_no, tx_id, block_index desc;")

    for result in $sql
    do

      for sqlHash in $result
      do
        sqlHashResult=$sqlHash
      done

      sqlBuys=$(psql -U ubuntu -d ${databaseName} -t -A -c "select buys from temp where hash = '${sqlHashResult}';")
      sqlDiscount=$(psql -U ubuntu -d ${databaseName} -t -A -c "select discount from temp where hash = '${sqlHashResult}';")
      nftCounterSql=$(psql -U ubuntu -d ${databaseName} -t -A -c "select counter from nftcounter;")
      cnftTotalCheck=$(expr $sqlBuys + $nftCounterSql)

      if [ $cnftTotalCheck -le $number ]
      then

        insert=$(psql -U ubuntu -d ${databaseName} -t -c "insert into sender(hash, buys, discount, grouping) values ('${result}', ${sqlBuys}, ${sqlDiscount}, ${grouping});")
        insert=$(psql -U ubuntu -d ${databaseName} -t -c "insert into log(hash) values ('${result}');")
        update=$(psql -U ubuntu -d ${databaseName} -t -c "update nftcounter set counter = ${cnftTotalCheck};")
        nftCounterCheck=$(expr $nftCounterCheck + 1)

        if [ $nftCounterCheck -eq $perfile ]
        then
          groupingNew=$(echo $grouping + 0.5 | bc)
          update=$(psql -U ubuntu -d ${databaseName} -t -c "update sender set grouping = ${groupingNew} where grouping = ${grouping};")
          grouping=$(echo $groupingNew + 0.5 | bc)
          nftCounterCheck=0
        fi
      fi
      
      if [ $nftCounterSql -eq $number ]
      then
        soldOld=false
        break
      fi

    done

    sql=$(psql -U ubuntu -d ${databaseName} -t -c "truncate table temp;")
    rm utxo.txt

  fi


done

sql=$(psql -U ubuntu -d ${databaseName} -t -c "select count(*) from sender where grouping = $grouping;")
if [ $sql -gt 0 ]
then
  groupingNew=$(echo $grouping + 0.5 | bc)
  update2=$(psql -U ubuntu -d ${databaseName} -t -c "update sender set grouping = ${groupingNew} where grouping = ${grouping};")
  grouping=$(echo $groupingNew + 0.5 | bc)
  nftCounterCheck=0
fi