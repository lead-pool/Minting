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
    currentTip=$(cardano-cli query tip --testnet-magic 1097911063 2> /dev/null | jq -r .slot 2> /dev/null);
    ttl=$(expr ${currentTip} + 3600)
  done

  utxoJSON=$(cardano-cli query utxo --testnet-magic 1097911063 --address ${walletaddress} --out-file /dev/stdout);
  txcnt=$(jq length <<< ${utxoJSON})

  echo $tmpCnt10 $utxoJSON

}

nftProject="MultiCNFTsMultiBuysDiscount"
wallets=3

cardano-cli query protocol-parameters --testnet-magic 1097911063 --out-file protocol.json

for (( tmpCnt10=0; tmpCnt10<${wallets}; tmpCnt10++ ))
do
  address=$(cat /home/ubuntu/${nftProject}/test/fundingWallets/payment${tmpCnt10}.addr)
  file="/home/ubuntu/${nftProject}/test/fundingWallets/payment${tmpCnt10}.skey"
  myfunc $address $file
done