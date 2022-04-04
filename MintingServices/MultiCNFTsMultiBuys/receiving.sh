networkParam="$1"
number=$2
cost=$3
checkwallet=$4
perfile=$5
databaseName=$6
database=${7}
maxBuys=${8}

checkUtxoJsonOld=""
nftCounterCheck=0
fileCounter=1
grouping=0.5
soldOld=true

sql=$(psql -U ubuntu -d ${databaseName} -t -c "truncate table temp;")
rm utxo.txt

while $soldOld; do 

  sleep 10
  echo "Receiving Waiting"
  sql=$(psql -U ubuntu -d ${databaseName} -t -c "select count(*) from sender where grouping = $grouping;")
  if [ $sql -gt 0 ]
  then
    groupingNew=$(echo $grouping + 0.5 | bc)
    update2=$(psql -U ubuntu -d ${databaseName} -t -c "update sender set grouping = ${groupingNew} where grouping = ${grouping};")
    grouping=$(echo $groupingNew + 0.5 | bc)
    nftCounterCheck=0
    echo "Receiving done"
  fi

  checkUtxoJSON={}
  while [ "$checkUtxoJSON" = {} ]
  do
    checkUtxoJSON=$(cardano-cli query utxo $networkParam --address ${checkwallet} --out-file /dev/stdout); if [ $? -ne 0 ]; then checkUtxoJSON={}; fi;
    cardano-cli query utxo $networkParam --address ${checkwallet} > utxo.txt
    sleep 10
    echo "Receiving Waiting"
  done
  
  if [ "${checkUtxoJSON}" != "${checkUtxoJsonOld}" ]
  then
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

    while read utxoHash index amount; do
      counter=$(expr $counter + 1)
      if [ $counter -gt 2 ]
      then 
        utxoHashIndex=$utxoHash#$index
        utxoHashIndexTrunc=$utxoHash
        checkUtxoAmount=$(echo $amount | tr -dc '0-9')
        hash="\x$utxoHashIndexTrunc"

        buys=$(expr $checkUtxoAmount / $cost)
        remain=$(expr $checkUtxoAmount % $cost)


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
              hashOne=\'${utxoHashIndex}\',$buys
            elif [ "${hashTwo}" = "" ]
            then
              hashTwo=\'${utxoHashIndex}\',$buys
            elif [ "${hashThree}" = "" ]
            then
              hashThree=\'${utxoHashIndex}\',$buys
            elif [ "${hashFour}" = "" ]
            then
              hashFour=\'${utxoHashIndex}\',$buys
            elif [ "${hashFive}" = "" ]
            then
              hashFive=\'${utxoHashIndex}\',$buys
            elif [ "${hashSix}" = "" ]
            then
              hashSix=\'${utxoHashIndex}\',$buys
            elif [ "${hashSeven}" = "" ]
            then
              hashSeven=\'${utxoHashIndex}\',$buys
            elif [ "${hashEight}" = "" ]
            then
              hashEight=\'${utxoHashIndex}\',$buys
            elif [ "${hashNine}" = "" ]
            then
              hashNine=\'${utxoHashIndex}\',$buys
            elif [ "${hashTen}" = "" ]
            then
              hashTen=\'${utxoHashIndex}\',$buys
            elif [ "${hashEleven}" = "" ]
            then
              hashEleven=\'${utxoHashIndex}\',$buys
            elif [ "${hashTwelve}" = "" ]
            then
              hashTwelve=\'${utxoHashIndex}\',$buys
            elif [ "${hashThirteen}" = "" ]
            then
              hashThirteen=\'${utxoHashIndex}\',$buys
            elif [ "${hashFourteen}" = "" ]
            then
              hashFourteen=\'${utxoHashIndex}\',$buys
            elif [ "${hashFifteen}" = "" ]
            then
              hashFifteen=\'${utxoHashIndex}\',$buys
            elif [ "${hashSixteen}" = "" ]
            then
              hashSixteen=\'${utxoHashIndex}\',$buys
            elif [ "${hashSeventeen}" = "" ]
            then
              hashSeventeen=\'${utxoHashIndex}\',$buys
            elif [ "${hashEighteen}" = "" ]
            then
              hashEighteen=\'${utxoHashIndex}\',$buys
            elif [ "${hashNineteen}" = "" ]
            then
              hashNineteen=\'${utxoHashIndex}\',$buys
            elif [ "${hashTwenty}" = "" ]
            then
              hashTwenty=\'${utxoHashIndex}\',$buys
            elif [ "${hashTwentyOne}" = "" ]
            then
              hashTwentyOne=\'${utxoHashIndex}\',$buys
            elif [ "${hashTwentyTwo}" = "" ]
            then
              hashTwentyTwo=\'${utxoHashIndex}\',$buys
            elif [ "${hashTwentyThree}" = "" ]
            then
              hashTwentyThree=\'${utxoHashIndex}\',$buys
            elif [ "${hashTwentyFour}" = "" ]
            then
              hashTwentyFour=\'${utxoHashIndex}\',$buys
            elif [ "${hashTwentyFive}" = "" ]
            then
              hashTwentyFive=\'${utxoHashIndex}\',$buys
            elif [ "${hashTwentySix}" = "" ]
            then
              hashTwentySix=\'${utxoHashIndex}\',$buys
            elif [ "${hashTwentySeven}" = "" ]
            then
              hashTwentySeven=\'${utxoHashIndex}\',$buys
            elif [ "${hashTwentyEight}" = "" ]
            then
              hashTwentyEight=\'${utxoHashIndex}\',$buys
            elif [ "${hashTwentyNine}" = "" ]
            then
              hashTwentyNine=\'${utxoHashIndex}\',$buys
            elif [ "${hashThirty}" = "" ]
            then
              hashThirty=\'${utxoHashIndex}\',$buys
            elif [ "${hashThirtyOne}" = "" ]
            then
              hashThirtyOne=\'${utxoHashIndex}\',$buys
            elif [ "${hashThirtyTwo}" = "" ]
            then
              hashThirtyTwo=\'${utxoHashIndex}\',$buys
            elif [ "${hashThirtyThree}" = "" ]
            then
              hashThirtyThree=\'${utxoHashIndex}\',$buys
            elif [ "${hashThirtyFour}" = "" ]
            then
              hashThirtyFour=\'${utxoHashIndex}\',$buys
            elif [ "${hashThirtyFive}" = "" ]
            then
              hashThirtyFive=\'${utxoHashIndex}\',$buys
            elif [ "${hashThirtySix}" = "" ]
            then
              hashThirtySix=\'${utxoHashIndex}\',$buys
            elif [ "${hashThirtySeven}" = "" ]
            then
              hashThirtySeven=\'${utxoHashIndex}\',$buys
            elif [ "${hashThirtyEight}" = "" ]
            then
              hashThirtyEight=\'${utxoHashIndex}\',$buys
            elif [ "${hashThirtyNine}" = "" ]
            then
              hashThirtyNine=\'${utxoHashIndex}\',$buys
            elif [ "${hashFourty}" = "" ]
            then
              hashFourty=\'${utxoHashIndex}\',$buys
            elif [ "${hashFourtyOne}" = "" ]
            then
              hashFourtyOne=\'${utxoHashIndex}\',$buys
            elif [ "${hashFourtyTwo}" = "" ]
            then
              hashFourtyTwo=\'${utxoHashIndex}\',$buys
            elif [ "${hashFourtyThree}" = "" ]
            then
              hashFourtyThree=\'${utxoHashIndex}\',$buys
            elif [ "${hashFourtyFour}" = "" ]
            then
              hashFourtyFour=\'${utxoHashIndex}\',$buys
            elif [ "${hashFourtyFive}" = "" ]
            then
              hashFourtyFive=\'${utxoHashIndex}\',$buys
            elif [ "${hashFourtySix}" = "" ]
            then
              hashFourtySix=\'${utxoHashIndex}\',$buys
            elif [ "${hashFourtySeven}" = "" ]
            then
              hashFourtySeven=\'${utxoHashIndex}\',$buys
            elif [ "${hashFourtyEight}" = "" ]
            then
              hashFourtyEight=\'${utxoHashIndex}\',$buys
            elif [ "${hashFourtyNine}" = "" ]
            then
              hashFourtyNine=\'${utxoHashIndex}\',$buys
            elif [ "${hashFifty}" = "" ]
            then
              hashFifty=\'${utxoHashIndex}\',$buys
            elif [ "${hashFiftyOne}" = "" ]
            then
              hashFiftyOne=\'${utxoHashIndex}\',$buys
            elif [ "${hashFiftyTwo}" = "" ]
            then
              hashFiftyTwo=\'${utxoHashIndex}\',$buys
            elif [ "${hashFiftyThree}" = "" ]
            then
              hashFiftyThree=\'${utxoHashIndex}\',$buys
            elif [ "${hashFiftyFour}" = "" ]
            then
              hashFiftyFour=\'${utxoHashIndex}\',$buys
            elif [ "${hashFiftyFive}" = "" ]
            then
              hashFiftyFive=\'${utxoHashIndex}\',$buys
            elif [ "${hashFiftySix}" = "" ]
            then
              hashFiftySix=\'${utxoHashIndex}\',$buys
            elif [ "${hashFiftySeven}" = "" ]
            then
              hashFiftySeven=\'${utxoHashIndex}\',$buys
            elif [ "${hashFiftyEight}" = "" ]
            then
              hashFiftyEight=\'${utxoHashIndex}\',$buys
            elif [ "${hashFiftyNine}" = "" ]
            then
              hashFiftyNine=\'${utxoHashIndex}\',$buys
            elif [ "${hashSixty}" = "" ]
            then
              hashSixty=\'${utxoHashIndex}\',$buys
            elif [ "${hashSixtyOne}" = "" ]
            then
              hashSixtyOne=\'${utxoHashIndex}\',$buys
            elif [ "${hashSixtyTwo}" = "" ]
            then
              hashSixtyTwo=\'${utxoHashIndex}\',$buys
            elif [ "${hashSixtyThree}" = "" ]
            then
              hashSixtyThree=\'${utxoHashIndex}\',$buys
            elif [ "${hashSixtyFour}" = "" ]
            then
              hashSixtyFour=\'${utxoHashIndex}\',$buys
            elif [ "${hashSixtyFive}" = "" ]
            then
              hashSixtyFive=\'${utxoHashIndex}\',$buys
            elif [ "${hashSixtySix}" = "" ]
            then
              hashSixtySix=\'${utxoHashIndex}\',$buys
            elif [ "${hashSixtySeven}" = "" ]
            then
              hashSixtySeven=\'${utxoHashIndex}\',$buys
            elif [ "${hashSixtyEight}" = "" ]
            then
              hashSixtyEight=\'${utxoHashIndex}\',$buys
            elif [ "${hashSixtyNine}" = "" ]
            then
              hashSixtyNine=\'${utxoHashIndex}\',$buys
            elif [ "${hashSeventy}" = "" ]
            then
              hashSeventy=\'${utxoHashIndex}\',$buys
            elif [ "${hashSeventyOne}" = "" ]
            then
              hashSeventyOne=\'${utxoHashIndex}\',$buys
            elif [ "${hashSeventyTwo}" = "" ]
            then
              hashSeventyTwo=\'${utxoHashIndex}\',$buys
            elif [ "${hashSeventyThree}" = "" ]
            then
              hashSeventyThree=\'${utxoHashIndex}\',$buys
            elif [ "${hashSeventyFour}" = "" ]
            then
              hashSeventyFour=\'${utxoHashIndex}\',$buys
            elif [ "${hashSeventyFive}" = "" ]
            then
              hashSeventyFive=\'${utxoHashIndex}\',$buys
            elif [ "${hashSeventySix}" = "" ]
            then
              hashSeventySix=\'${utxoHashIndex}\',$buys
            elif [ "${hashSeventySeven}" = "" ]
            then
              hashSeventySeven=\'${utxoHashIndex}\',$buys
            elif [ "${hashSeventyEight}" = "" ]
            then
              hashSeventyEight=\'${utxoHashIndex}\',$buys
            elif [ "${hashSeventyNine}" = "" ]
            then
              hashSeventyNine=\'${utxoHashIndex}\',$buys
            elif [ "${hashEighty}" = "" ]
            then
              hashEighty=\'${utxoHashIndex}\',$buys
            elif [ "${hashEightyOne}" = "" ]
            then
              hashEightyOne=\'${utxoHashIndex}\',$buys
            elif [ "${hashEightyTwo}" = "" ]
            then
              hashEightyTwo=\'${utxoHashIndex}\',$buys
            elif [ "${hashEightyThree}" = "" ]
            then
              hashEightyThree=\'${utxoHashIndex}\',$buys
            elif [ "${hashEightyFour}" = "" ]
            then
              hashEightyFour=\'${utxoHashIndex}\',$buys
            elif [ "${hashEightyFive}" = "" ]
            then
              hashEightyFive=\'${utxoHashIndex}\',$buys
            elif [ "${hashEightySix}" = "" ]
            then
              hashEightySix=\'${utxoHashIndex}\',$buys
            elif [ "${hashEightySeven}" = "" ]
            then
              hashEightySeven=\'${utxoHashIndex}\',$buys
            elif [ "${hashEightyEight}" = "" ]
            then
              hashEightyEight=\'${utxoHashIndex}\',$buys
            elif [ "${hashEightyNine}" = "" ]
            then
              hashEightyNine=\'${utxoHashIndex}\',$buys
            elif [ "${hashNinety}" = "" ]
            then
              hashNinety=\'${utxoHashIndex}\',$buys
            elif [ "${hashNinetyOne}" = "" ]
            then
              hashNinetyOne=\'${utxoHashIndex}\',$buys
            elif [ "${hashNinetyTwo}" = "" ]
            then
              hashNinetyTwo=\'${utxoHashIndex}\',$buys
            elif [ "${hashNinetyThree}" = "" ]
            then
              hashNinetyThree=\'${utxoHashIndex}\',$buys
            elif [ "${hashNinetyFour}" = "" ]
            then
              hashNinetyFour=\'${utxoHashIndex}\',$buys
            elif [ "${hashNinetyFive}" = "" ]
            then
              hashNinetyFive=\'${utxoHashIndex}\',$buys
            elif [ "${hashNinetySix}" = "" ]
            then
              hashNinetySix=\'${utxoHashIndex}\',$buys
            elif [ "${hashNinetySeven}" = "" ]
            then
              hashNinetySeven=\'${utxoHashIndex}\',$buys
            elif [ "${hashNinetyEight}" = "" ]
            then
              hashNinetyEight=\'${utxoHashIndex}\',$buys
            elif [ "${hashNinetyNine}" = "" ]
            then
              hashNinetyNine=\'${utxoHashIndex}\',$buys
            elif [ "${hashOneHundred}" = "" ]
            then
              hashOneHundred=\'${utxoHashIndex}\',$buys              
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

              insert=$(psql -U ubuntu -d ${databaseName} -t -c "insert into temp(block_no, tx_id, block_index, hash, buys) values ${finalString};")
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
       
      insert=$(psql -U ubuntu -d ${databaseName} -t -c "insert into temp(block_no, tx_id, block_index, hash, buys) values ${finalString};")
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

      sqlBuys=$(psql -U ubuntu -d ${databaseName} -t -c "select buys from temp where hash = '${sqlHashResult}';")
      nftCounterSql=$(psql -U ubuntu -d ${databaseName} -t -c "select counter from nftcounter;")
      
      cnftTotalCheck=$(expr $sqlBuys + $nftCounterSql)

      if [ $cnftTotalCheck -le $number ]
      then

        insert=$(psql -U ubuntu -d ${databaseName} -t -c "insert into sender(hash, buys, grouping) values ('${result}', ${sqlBuys}, ${grouping});")
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
  echo "Receiving done"
fi