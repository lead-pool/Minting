while read line
do
  databaseName=$line
done < database.txt

network=$(psql -U ubuntu -d $databaseName -t -A -c "select network from settings;")
nftProject=$(psql -U ubuntu -d $databaseName -t -A -c "select nftProject from settings;")


walletAddress=$(cat receivingKeys/payment.addr)
walletSigningKey="receivingKeys/payment.skey"

if [ "$network" == "testnet" ]
then
  networkParam="--testnet-magic 1097911063"
  database="testnet"
else
  networkParam="--mainnet"
  database="cexplorer"
fi

cardano-cli query protocol-parameters ${networkParam} --out-file protocol.json


utxoJSON=""
while [ "$utxoJSON" = "" ]
do
  utxoJSON=$(cardano-cli query utxo ${networkParam} --address ${walletAddress} --out-file /dev/stdout); if [ $? -ne 0 ]; then utxoJSON=""; fi;
done

txcnt=$(jq length <<< ${utxoJSON})
tmpCnt=$txcnt


for (( tmpCnt=0; tmpCnt<${txcnt}; tmpCnt++ ))
do
  utxoHashIndex=$(jq -r "keys_unsorted[${tmpCnt}]" <<< ${utxoJSON})
  utxoHashIndexTrunc=${utxoHashIndex%#*}
  hash="\x$utxoHashIndexTrunc"
  size=0

  while [ $size -eq 0 ]
  do
    sql=$(psql -U ubuntu -d ${database} -t -c "select address from tx_out where tx_id = (select id from tx where hash = '${hash}') and address != '${walletAddress}'")
    size=${#sql}
  done
  
  for result in $sql
  do
    receivingAddress=$result
  done

  echo $receivingAddress

  txInString=""
  txInString="--tx-in ${utxoHashIndex}"

  totalLovelaces=0
  utxoAmount=$(jq -r ".\"${utxoHashIndex}\".value.lovelace" <<< ${utxoJSON})
  totalLovelaces=$(bc <<< "${totalLovelaces} + ${utxoAmount}" )
  assetsJSON=$(jq -r ".\"${utxoHashIndex}\".value | del (.lovelace)" <<< ${utxoJSON})
  assetsEntryCnt=$(jq length <<< ${assetsJSON})

  echo $assetsEntryCnt
  totalPolicyIDsJSON="{}";
  totalAssetsJSON="{}";
  if [[ ${assetsEntryCnt} -gt 0 ]]; then
    for (( tmpCnt2=0; tmpCnt2<${assetsEntryCnt}; tmpCnt2++ ))
    do
      assetHash=$(jq -r "keys_unsorted[${tmpCnt2}]" <<< ${assetsJSON})  #assetHash = policyID
      echo assetHash $assetHash
      assetsNameCnt=$(jq ".\"${assetHash}\" | length" <<< ${assetsJSON})
      totalPolicyIDsJSON=$( jq ". += {\"${assetHash}\": 1}" <<< ${totalPolicyIDsJSON})
      echo totalPolicyIDsJSON $totalPolicyIDsJSON
      echo assetsNameCnt $assetsNameCnt
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

  totalPolicyIDsCnt=$(jq length <<< ${totalPolicyIDsJSON});
  totalAssetsCnt=$(jq length <<< ${totalAssetsJSON})
  assetsSendString=""

  echo $totalAssetsCnt
  for (( tmpCnt4=0; tmpCnt4<${totalAssetsCnt}; tmpCnt4++ ))
  do
    asset=$(jq -r "keys_unsorted[${tmpCnt4}]" <<< ${totalAssetsJSON})
    assetAmount=$(jq -r ".\"${asset}\".amount" <<< ${totalAssetsJSON})
    assetsSendString="${assetsSendString} +${assetAmount} ${asset}"
  done

  echo assetsSendString $assetsSendString

  ttl=3600
  while [ $ttl -eq 3600 ]
  do
    currentTip=$(cardano-cli query tip ${networkParam} 2> /dev/null | jq -r .slot 2> /dev/null);
    ttl=$(expr ${currentTip} + 3600)
  done

  cardano-cli transaction build-raw ${txInString} --tx-out "${receivingAddress}+0 ${assetsSendString}" --ttl 0 --fee 0 --out-file tx.raw --alonzo-era

  minfee=$(cardano-cli transaction calculate-min-fee --tx-body-file tx.raw --tx-in-count 1 --tx-out-count 1 --witness-count 1 --byron-witness-count 0 ${networkParam} --protocol-params-file protocol.json | awk '{ print $1 }');

  echo totalLovelaces:$totalLovelaces 
  echo minfee:$minfee


  remainder=$(expr ${totalLovelaces} -  ${minfee});

  echo remainder:$remainder

  cardano-cli transaction build-raw ${txInString} --tx-out "${receivingAddress}+${remainder} ${assetsSendString}" --ttl ${ttl} --fee ${minfee} --out-file tx.raw --alonzo-era

  cardano-cli transaction sign --tx-body-file tx.raw --signing-key-file ${walletSigningKey} ${networkParam} --out-file tx.signed

  submit=$(cardano-cli transaction submit --tx-file tx.signed ${networkParam})

  echo $submit

    
done