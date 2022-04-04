myfunc()
{
  walletaddress=$1
  paymentkeyfile=$2
  ttl=54024666

  utxoJSON=$(cardano-cli query utxo --testnet-magic 1097911063 --address ${walletaddress} --out-file /dev/stdout);
  utxoHashIndex=$(jq -r "keys_unsorted[0]" <<< ${utxoJSON})
  utxoAmount=$(jq -r ".\"${utxoHashIndex}\".value.lovelace" <<< ${utxoJSON})

  cardano-cli transaction build-raw --tx-in ${utxoHashIndex} --tx-out ${paymentaddress}+${nftamount} --tx-out ${walletaddress}+0 --ttl 0 --fee 0 --out-file tx.raw --alonzo-era
  minfee=$(cardano-cli transaction calculate-min-fee --tx-body-file tx.raw --tx-in-count 1 --tx-out-count 2 --witness-count 1 --byron-witness-count 0 --testnet-magic 1097911063 --protocol-params-file protocol.json | awk '{ print $1 }');
  remainder=$(expr ${utxoAmount} - ${nftamount} - ${minfee});


  cardano-cli transaction build-raw --tx-in ${utxoHashIndex} --tx-out ${paymentaddress}+${nftamount} --tx-out ${walletaddress}+${remainder} --ttl ${ttl} --fee ${minfee} --out-file tx.raw --alonzo-era
  cardano-cli transaction sign --tx-body-file tx.raw --signing-key-file ${paymentkeyfile} --testnet-magic 1097911063 --out-file tx.signed
  submit=$(cardano-cli transaction submit --tx-file tx.signed --testnet-magic 1097911063)

  echo $submit

}

### Main script starts here 


nftamount=8000000
NFTProject="MultiCNFTs"
paymentaddress=$(cat /home/ubuntu/$NFTProject/receivingKeys/payment.addr)

cardano-cli query protocol-parameters --testnet-magic 1097911063 --out-file protocol.json
for (( tmpCnt=1; tmpCnt<11000; tmpCnt++ ))
do
  echo $tmpCnt
  address=$(cat /home/ubuntu/$NFTProject/test/paymentWallets/payment${tmpCnt}.addr)
  file="/home/ubuntu/$NFTProject/test/paymentWallets/payment${tmpCnt}.skey"
  myfunc $address $file
  counter=$(expr $counter + 1)
#  sleep 120
done