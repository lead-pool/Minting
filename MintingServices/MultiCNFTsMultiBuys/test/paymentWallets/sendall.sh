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
  recievingwallet=$(cat /opt/cardano/cnode/priv/wallet/FINAL/base.addr)
  ttl=3600

  while [ $ttl -eq 3600 ]
  do
    currentTip=$(cardano-cli query tip --testnet-magic 1097911063 2> /dev/null | jq -r .slot 2> /dev/null);
    ttl=$(expr ${currentTip} + 3600)
  done

  utxoJSON=$(cardano-cli query utxo --testnet-magic 1097911063 --address ${walletaddress} --out-file /dev/stdout);
  txcnt=$(jq length <<< ${utxoJSON})

  for (( tmpCnt=0; tmpCnt<${txcnt}; tmpCnt++ ))
  do
    #Utxos and amounts
    utxoHashIndex=$(jq -r "keys_unsorted[${tmpCnt}]" <<< ${utxoJSON})
    utxoAmount=$(jq -r ".\"${utxoHashIndex}\".value.lovelace" <<< ${utxoJSON})   #Lovelaces
    txInString="--tx-in ${utxoHashIndex}"
    assetsJSON=$(jq -r ".\"${utxoHashIndex}\".value | del (.lovelace)" <<< ${utxoJSON})
    assetsEntryCnt=$(jq length <<< ${assetsJSON})



    if [ ${assetsEntryCnt} -eq 0 ]
    then
      cardano-cli transaction build-raw ${txInString} --tx-out "${recievingwallet}+0" --ttl 0 --fee 0 --out-file tx.raw --alonzo-era
      minfee=$(cardano-cli transaction calculate-min-fee --tx-body-file tx.raw --tx-in-count 1 --tx-out-count 2 --witness-count 1 --byron-witness-count 0 --testnet-magic 1097911063 --protocol-params-file protocol.json | awk '{ print $1 }');
      remainder=$(expr ${utxoAmount} -  ${minfee});
      cardano-cli transaction build-raw ${txInString} --tx-out "${recievingwallet}+${remainder}" --ttl ${ttl} --fee ${minfee} --out-file tx.raw --alonzo-era
      cardano-cli transaction sign --tx-body-file tx.raw --signing-key-file $2 --testnet-magic 1097911063 --out-file tx.signed
      submit=$(cardano-cli transaction submit --tx-file tx.signed --testnet-magic 1097911063)
      echo $submit
    fi
  done
}

cardano-cli query protocol-parameters --testnet-magic 1097911063 --out-file protocol.json

nftProject="MultiCNFTsMultiBuys"
wallets=301

for (( tmpCnt10=1; tmpCnt10<${wallets}; tmpCnt10++ ))
do
  echo $tmpCnt10
  address=$(cat /home/ubuntu/${nftProject}/test/paymentWallets/payment${tmpCnt10}.addr)
  file="/home/ubuntu/${nftProject}/test/paymentWallets/payment${tmpCnt10}.skey"
  myfunc $address $file
done