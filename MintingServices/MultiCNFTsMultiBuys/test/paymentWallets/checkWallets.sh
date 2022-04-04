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
  assetName=""
  totalAssets=0
  while [ $ttl -eq 3600 ]
  do
    currentTip=$(cardano-cli query tip --testnet-magic 1097911063 2> /dev/null | jq -r .slot 2> /dev/null);
    ttl=$(expr ${currentTip} + 3600)
  done

  utxoJSON=$(cardano-cli query utxo --testnet-magic 1097911063 --address ${walletaddress} --out-file /dev/stdout);
  txcnt=$(jq length <<< ${utxoJSON})
  assetString=""
  for (( tmpCnt=0; tmpCnt<${txcnt}; tmpCnt++ ))
  do
    #Utxos and amounts
    utxoHashIndex=$(jq -r "keys_unsorted[${tmpCnt}]" <<< ${utxoJSON})
    utxoAmount=$(jq -r ".\"${utxoHashIndex}\".value.lovelace" <<< ${utxoJSON})   #Lovelaces
    totalLovelaces=$(bc <<< "${totalLovelaces} + ${utxoAmount}" )
    assetsJSON=$(jq -r ".\"${utxoHashIndex}\".value | del (.lovelace)" <<< ${utxoJSON})
    assetsEntryCnt=$(jq length <<< ${assetsJSON})
    totalAssets=$(expr $totalAssets + $assetsEntryCnt)
    if [[ ${assetsEntryCnt} -gt 0 ]]; then
      for (( tmpCnt2=0; tmpCnt2<${assetsEntryCnt}; tmpCnt2++ ))
      do
        assetHash=$(jq -r "keys_unsorted[${tmpCnt2}]" <<< ${assetsJSON})  #assetHash = policyID
        assetsNameCnt=$(jq ".\"${assetHash}\" | length" <<< ${assetsJSON})

        #LEVEL 3 - different names under the same policyID
        for (( tmpCnt3=0; tmpCnt3<${assetsNameCnt}; tmpCnt3++ ))
        do
          assetName=$(jq -r ".\"${assetHash}\" | keys_unsorted[${tmpCnt3}]" <<< ${assetsJSON})
          assetName=$(echo -n "${assetName}" | xxd -r -ps)
          assetString="$assetString $assetName"
        done
      done
    fi
  done

  totalLovelaces=$(expr $totalLovelaces / 1000000)
  echo Wallet:$tmpCnt10 TxCount:$txcnt ADA:$totalLovelaces Asset:$assetString

}

nftProject="MultiCNFTsMultiBuys"
wallets=4

cardano-cli query protocol-parameters --testnet-magic 1097911063 --out-file protocol.json

for (( tmpCnt10=1; tmpCnt10<${wallets}; tmpCnt10++ ))
do
  address=$(cat /home/ubuntu/${nftProject}/test/paymentWallets/payment${tmpCnt10}.addr)
  file="/home/ubuntu/${nftProject}/test/paymentWallets/payment${tmpCnt10}.skey"
  myfunc $address $file
done