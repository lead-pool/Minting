myfunc()
{
  walletaddress=$(cat /home/ubuntu/${nftProject}/test/fundingWallets/payment0.addr)
  paymentkeyfile="/home/ubuntu/${nftProject}/test/fundingWallets/payment0.skey"
  amount=$1
  recievingwallet=$2
  ttl=3600

  while [ $ttl -eq 3600 ]
  do
    currentTip=$(cardano-cli query tip --testnet-magic 1097911063 2> /dev/null | jq -r .slot 2> /dev/null);
    ttl=$(expr ${currentTip} + 3600)
  done

  utxoJSON=$(cardano-cli query utxo --testnet-magic 1097911063 --address ${walletaddress} --out-file /dev/stdout);
  utxoHashIndex=$(jq -r "keys_unsorted[0]" <<< ${utxoJSON})
  utxoAmount=$(jq -r ".\"${utxoHashIndex}\".value.lovelace" <<< ${utxoJSON})

  cardano-cli transaction build-raw --tx-in ${utxoHashIndex} --tx-out ${recievingwallet}+${amount} --tx-out ${walletaddress}+0 --ttl 0 --fee 0 --out-file tx.raw --alonzo-era
  minfee=$(cardano-cli transaction calculate-min-fee --tx-body-file tx.raw --tx-in-count 1 --tx-out-count 2 --witness-count 1 --byron-witness-count 0 --testnet-magic 1097911063 --protocol-params-file protocol.json | awk '{ print $1 }');
  remainder=$(expr ${utxoAmount} - ${amount} - ${minfee});

  cardano-cli transaction build-raw --tx-in ${utxoHashIndex} --tx-out ${recievingwallet}+${amount} --tx-out ${walletaddress}+${remainder} --ttl ${ttl} --fee ${minfee} --out-file tx.raw --alonzo-era
  cardano-cli transaction sign --tx-body-file tx.raw --signing-key-file ${paymentkeyfile} --testnet-magic 1097911063 --out-file tx.signed
  cardano-cli transaction submit --tx-file tx.signed --testnet-magic 1097911063

  adacheck=0
  while [ $adacheck -eq 0 ]
  do
    utxoJSON=""
    while [ "$utxoJSON" = "" ]
    do
      utxoJSON=$(cardano-cli query utxo  --testnet-magic 1097911063 --address ${walletaddress} --out-file /dev/stdout);
      utxoHashIndex=$(jq -r "keys_unsorted[0]" <<< ${utxoJSON})
      oldLovelaces=0
      utxoAmount=$(jq -r ".\"${utxoHashIndex}\".value.lovelace" <<< ${utxoJSON})
      oldLovelaces=$(bc <<< "${oldLovelaces} + ${utxoAmount}" )
      if [ $remainder -eq $oldLovelaces ]
      then
        adacheck=1
      else
        sleep 5
      fi
    done
  done
}


### Main script starts here 
amount=6000000000
nftProject="MultiCNFTs"
wallets=3


cardano-cli query protocol-parameters --testnet-magic 1097911063 --out-file protocol.json

for (( tmpCnt=1; tmpCnt<$wallets; tmpCnt++ ))
do
  echo $tmpCnt
  address=$(cat /home/ubuntu/${nftProject}/test/fundingWallets/payment${tmpCnt}.addr)
  myfunc $amount $address
done