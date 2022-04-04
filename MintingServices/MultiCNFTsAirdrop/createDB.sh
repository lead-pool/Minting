nftProject=$1
databaseName=$2
nftDirectory=/home/ubuntu/${nftProject}/images/
ipfsFile="ipfs.txt"
metadataFile="metadata.txt"

psql -U ubuntu -d ${databaseName} -t -c "truncate table ipfs;"
psql -U ubuntu -d ${databaseName} -t -c "truncate table metadata;"

finalCount=0
finalString=""
while read nftNumber CID; do
  
  finalCount=$(expr $finalCount + 1)

  if [ $finalCount -eq 1 ]
  then
    finalString="(${nftNumber}, '${CID}')"
  else
    finalString="${finalString}, (${nftNumber}, '${CID}')"
  fi  
  
  if [ $finalCount -eq 100 ]
  then
    psql -U ubuntu -d ${databaseName} -t -c "insert into ipfs values $finalString;"
    finalString=""
    finalCount=0
  fi

done < $nftDirectory$ipfsFile

if [ $finalCount -gt 0 ]
then
  psql -U ubuntu -d ${databaseName} -t -c "insert into ipfs values $finalString;"
  finalString=""
  finalCount=0
fi


finalCount=0
finalString=""

while read line;
do
  insertString=""
  IFS=',' list=($line)
  IFS=''
  counter=1
  for item in "${list[@]}"; 
  do
    if [ $counter -eq 1 ]
    then
      insertString="'${item}'"
      counter=2
    else
     insertString=${insertString},"'${item}'"
    fi
  done
  finalCount=$(expr $finalCount + 1)

  if [ $finalCount -eq 1 ]
  then
    finalString="(${insertString})"
  else
    finalString="${finalString}, (${insertString})"
  fi  


  if [ $finalCount -eq 100 ]
  then
    psql -U ubuntu -d ${databaseName} -t -c "insert into metadata values $finalString;"
    finalString=""
    finalCount=0
  fi
done < $nftDirectory$metadataFile

if [ $finalCount -gt 0 ]
then
  psql -U ubuntu -d ${databaseName} -t -c "insert into metadata values $finalString;"
  finalString=""
  finalCount=0
fi