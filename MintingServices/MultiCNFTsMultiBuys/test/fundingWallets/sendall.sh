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
    totalLovelaces=$(bc <<< "${totalLovelaces} + ${utxoAmount}" )
    txInString="${txInString} --tx-in ${utxoHashIndex}"
  done
  if [ "${txInString}" != "" ]
  then
    cardano-cli transaction build-raw ${txInString} --tx-out "${recievingwallet}+0" --ttl 0 --fee 0 --out-file tx.raw --alonzo-era
    minfee=$(cardano-cli transaction calculate-min-fee --tx-body-file tx.raw --tx-in-count 1 --tx-out-count 2 --witness-count 1 --byron-witness-count 0 --testnet-magic 1097911063 --protocol-params-file protocol.json | awk '{ print $1 }');
    remainder=$(expr ${totalLovelaces} -  ${minfee});
    cardano-cli transaction build-raw ${txInString} --tx-out "${recievingwallet}+${remainder}" --ttl ${ttl} --fee ${minfee} --out-file tx.raw --alonzo-era
    cardano-cli transaction sign --tx-body-file tx.raw --signing-key-file $2 --testnet-magic 1097911063 --out-file tx.signed
    submit=$(cardano-cli transaction submit --tx-file tx.signed --testnet-magic 1097911063)
  fi
}

nftProject="MultiCNFTsMultiBuys"
wallets=3

cardano-cli query protocol-parameters --testnet-magic 1097911063 --out-file protocol.json

for (( tmpCnt10=0; tmpCnt10<${wallets}; tmpCnt10++ ))
do
  address=$(cat /home/ubuntu/${nftProject}/test/fundingWallets/payment${tmpCnt10}.addr)
  file="/home/ubuntu/${nftProject}/test/fundingWallets/payment${tmpCnt10}.skey"
  myfunc $address $file
done