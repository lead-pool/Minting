myfunc()
{

  point="."
  walletaddress=$1
  totalLovelaces=0
  assetsReturnString=""
  totalAssetsJSON="{}";
  totalPolicyIDsJSON="{}";
  txInString=""
  zero="0"
  ttl=3600

  while [ $ttl -eq 3600 ]
  do
    currentTip=$(cardano-cli query tip ${networkParam} 2> /dev/null | jq -r .slot 2> /dev/null);
    ttl=$(expr ${currentTip} + 3600)
  done

  utxoJSON=$(cardano-cli query utxo ${networkParam} --address ${walletaddress} --out-file /dev/stdout);
  txcnt=$(jq length <<< ${utxoJSON})

  for (( tmpCnt=0; tmpCnt<${txcnt}; tmpCnt++ ))
  do
    #Utxos and amounts
    utxoHashIndex=$(jq -r "keys_unsorted[${tmpCnt}]" <<< ${utxoJSON})
    utxoAmount=$(jq -r ".\"${utxoHashIndex}\".value.lovelace" <<< ${utxoJSON})   #Lovelaces
    echo $tmpCnt $txcnt $utxoAmount $utxoHashIndex
  done


}

network="testnet"
nftProject="SingleCNFTAirdrop"

if [ "$network" == "testnet" ]
then
  networkParam="--testnet-magic 1097911063"
else
  networkParam="--mainnet"
fi

cardano-cli query protocol-parameters ${networkParam} --out-file protocol.json

address=$(cat /home/ubuntu/${nftProject}/sendingKeys/payment.addr)
file="/home/ubuntu/${nftProject}/sendingKeys/payment${tmpCnt10}.skey"
myfunc $address $file

rm protocol.json