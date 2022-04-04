while read line
do
  databaseName=$line
done < database.txt

network=$(psql -U ubuntu -d $databaseName -t -A -c "select network from settings;")
nftProject=$(psql -U ubuntu -d $databaseName -t -A -c "select nftProject from settings;")
nftCount=$(psql -U ubuntu -d $databaseName -t -A -c "select nftCount from settings;")
nftCost=$(psql -U ubuntu -d $databaseName -t -A -c "select nftCost from settings;")
finalWallet=$(psql -U ubuntu -d $databaseName -t -A -c "select finalWallet from settings;")
sessions=$(psql -U ubuntu -d $databaseName -t -A -c "select sessions from settings;")
randomSetting=$(psql -U ubuntu -d $databaseName -t -A -c "select randomSetting from settings;")
entriesPerFile=$(psql -U ubuntu -d $databaseName -t -A -c "select entriesPerFile from settings;")
minterFee=$(psql -U ubuntu -d $databaseName -t -A -c "select minterFee from settings;")
minterAddress=$(psql -U ubuntu -d $databaseName -t -A -c "select minterAddress from settings;")
maxBuys=$(psql -U ubuntu -d $databaseName -t -A -c "select maxBuys from settings;")
discountNftCost=$(psql -U ubuntu -d $databaseName -t -A -c "select discountNftCost from settings;")
originalPolicy=$(psql -U ubuntu -d $databaseName -t -A -c "select originalPolicy from settings;")

if [ "$network" == "testnet" ]
then
  networkParam="--testnet-magic 1097911063"
  database="testnet"
else
  networkParam="--mainnet"
  database="cexplorer"
fi

cardano-cli query protocol-parameters $networkParam --out-file protocol.json

receivingWallet=$(cat receivingKeys/payment.addr)
receivingKeyFile="receivingKeys/payment.skey"

policyID=$(cat policy/${nftProject}.policy.id)
policyScriptFile=policy/${nftProject}.policy.script
policyTTL=$(cat $policyScriptFile | jq -r ".scripts[] | select(.type == \"before\") | .slot" 2> /dev/null || echo "unlimited")
policyKeyFile=policy/${nftProject}.policy.skey

era="--alonzo-era"

./createDB.sh $nftProject $databaseName

./receiving.sh "$networkParam" $nftCount $nftCost $receivingWallet $entriesPerFile $databaseName $database $maxBuys $discountNftCost $originalPolicy &

if [ $sessions -eq 1 ]
then
  ./sender.sh 1 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost
elif [ $sessions -eq 2 ]
then
  ./sender.sh 1 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 2 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost
elif [ $sessions -eq 3 ]
then
  ./sender.sh 1 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 2 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 3 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost
elif [ $sessions -eq 4 ]
then
  ./sender.sh 1 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 2 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 3 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 4 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost
elif [ $sessions -eq 5 ]
then
  ./sender.sh 1 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 2 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 3 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 4 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 5 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost
elif [ $sessions -eq 6 ]
then
  ./sender.sh 1 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 2 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 3 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 4 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 5 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 6 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost
elif [ $sessions -eq 7 ]
then
  ./sender.sh 1 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 2 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 3 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 4 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 5 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 6 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 7 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost
elif [ $sessions -eq 8 ]
then
  ./sender.sh 1 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 2 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 3 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 4 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 5 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 6 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 7 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 8 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost
elif [ $sessions -eq 9 ]
then
  ./sender.sh 1 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 2 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 3 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 4 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 5 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 6 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 7 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 8 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 9 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost
elif [ $sessions -eq 10 ]
then
  ./sender.sh 1 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 2 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 3 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 4 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 5 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 6 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 7 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 8 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 9 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost &
  ./sender.sh 10 "$networkParam" $sessions $receivingWallet $receivingKeyFile $policyID $policyScriptFile $policyTTL $policyKeyFile $finalWallet $era $nftProject $nftCost $databaseName $minterFee $minterAddress $database $discountNftCost
fi