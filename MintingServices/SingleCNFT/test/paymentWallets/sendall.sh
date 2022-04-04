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
  #recievingwallet=$(cat /home/ubuntu/${nftProject}/test/paymentWallets/payment1.addr)
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
    assetsJSON=$(jq -r ".\"${utxoHashIndex}\".value | del (.lovelace)" <<< ${utxoJSON})
    assetsEntryCnt=$(jq length <<< ${assetsJSON})

    if [[ ${assetsEntryCnt} -gt 0 ]]; then
      for (( tmpCnt2=0; tmpCnt2<${assetsEntryCnt}; tmpCnt2++ ))
      do
        assetHash=$(jq -r "keys_unsorted[${tmpCnt2}]" <<< ${assetsJSON})  #assetHash = policyID
        assetsNameCnt=$(jq ".\"${assetHash}\" | length" <<< ${assetsJSON})
        totalPolicyIDsJSON=$( jq ". += {\"${assetHash}\": 1}" <<< ${totalPolicyIDsJSON})

        #LEVEL 3 - different names under the same policyID
        for (( tmpCnt3=0; tmpCnt3<${assetsNameCnt}; tmpCnt3++ ))
        do
          assetName=$(jq -r ".\"${assetHash}\" | keys_unsorted[${tmpCnt3}]" <<< ${assetsJSON})
          assetAmount=$(jq -r ".\"${assetHash}\".\"${assetName}\"" <<< ${assetsJSON})
          assetBech=a
          if [[ "${assetName}" == "" ]]; then point=""; else point="."; fi

          oldValue=$(jq -r ".\"${assetHash}${point}${assetName}\".amount" <<< ${totalAssetsJSON})
          newValue=$(bc <<< "${oldValue}+${assetAmount}")
          totalAssetsJSON=$( jq ". += {\"${assetHash}${point}${assetName}\":{amount: \"${newValue}\", name: \"${assetName}\", bech: \"${assetBech}\"}}" <<< ${totalAssetsJSON})

        done
      done
    fi
  done

  totalPolicyIDsCnt=$(jq length <<< ${totalPolicyIDsJSON});
  totalAssetsCnt=$(jq length <<< ${totalAssetsJSON})
  assetsSendString=""

  for (( tmpCnt4=0; tmpCnt4<${totalAssetsCnt}; tmpCnt4++ ))
  do
    asset=$(jq -r "keys_unsorted[${tmpCnt4}]" <<< ${totalAssetsJSON})
    assetAmount=$(jq -r ".\"${asset}\".amount" <<< ${totalAssetsJSON})
    assetsSendString="${assetsSendString} +${assetAmount} ${asset}"
  done

  if [ "${txInString}" != "" ]
  then
    cardano-cli transaction build-raw ${txInString} --tx-out "${recievingwallet}+0 ${assetsSendString}" --ttl 0 --fee 0 --out-file tx.raw --alonzo-era
    minfee=$(cardano-cli transaction calculate-min-fee --tx-body-file tx.raw --tx-in-count 1 --tx-out-count 2 --witness-count 1 --byron-witness-count 0 --testnet-magic 1097911063 --protocol-params-file protocol.json | awk '{ print $1 }');
    remainder=$(expr ${totalLovelaces} -  ${minfee});
    cardano-cli transaction build-raw ${txInString} --tx-out "${recievingwallet}+${remainder} ${assetsSendString}" --ttl ${ttl} --fee ${minfee} --out-file tx.raw --alonzo-era
    cardano-cli transaction sign --tx-body-file tx.raw --signing-key-file $2 --testnet-magic 1097911063 --out-file tx.signed
    submit=$(cardano-cli transaction submit --tx-file tx.signed --testnet-magic 1097911063)
    echo $submit
  fi
}

cardano-cli query protocol-parameters --testnet-magic 1097911063 --out-file protocol.json

nftProject="SingleCNFT"
wallets=1501

for (( tmpCnt10=1; tmpCnt10<${wallets}; tmpCnt10++ ))
do
  echo $tmpCnt10
  address=$(cat /home/ubuntu/${nftProject}/test/paymentWallets/payment${tmpCnt10}.addr)
  file="/home/ubuntu/${nftProject}/test/paymentWallets/payment${tmpCnt10}.skey"
  myfunc $address $file
done