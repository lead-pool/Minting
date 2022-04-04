 myfunc()
{
  walletaddress=$3
  paymentkeyfile=$4
  amount=$1
  recievingwallet=$2
  ttl=3600
  count=$5

  while [ $ttl -eq 3600 ]
  do
    currentTip=$(cardano-cli query tip --testnet-magic 1097911063 2> /dev/null | jq -r .slot 2> /dev/null);
    ttl=$(expr ${currentTip} + 3600)
  done

  utxoAmount=0
  utxoJSON=$(cardano-cli query utxo --testnet-magic 1097911063 --address ${recievingwallet} --out-file /dev/stdout);
  utxoHashIndex=$(jq -r "keys_unsorted[0]" <<< ${utxoJSON})
  utxoAmount=$(jq -r ".\"${utxoHashIndex}\".value.lovelace" <<< ${utxoJSON})
  
  if [ "$utxoAmount" = "null" ]
  then
    utxoJSON=$(cardano-cli query utxo --testnet-magic 1097911063 --address ${walletaddress} --out-file /dev/stdout);
    utxoHashIndex=$(jq -r "keys_unsorted[0]" <<< ${utxoJSON})
    utxoAmount=$(jq -r ".\"${utxoHashIndex}\".value.lovelace" <<< ${utxoJSON})

    cardano-cli transaction build-raw --tx-in ${utxoHashIndex} --tx-out ${recievingwallet}+${amount} --tx-out ${walletaddress}+0 --ttl 0 --fee 0 --out-file tx${count}.raw --alonzo-era
    minfee=$(cardano-cli transaction calculate-min-fee --tx-body-file tx${count}.raw --tx-in-count 1 --tx-out-count 2 --witness-count 1 --byron-witness-count 0 --testnet-magic 1097911063 --protocol-params-file protocol.json | awk '{ print $1 }');
    remainder=$(expr ${utxoAmount} - ${amount} - ${minfee});

    cardano-cli transaction build-raw --tx-in ${utxoHashIndex} --tx-out ${recievingwallet}+${amount} --tx-out ${walletaddress}+${remainder} --ttl ${ttl} --fee ${minfee} --out-file tx${count}.raw --alonzo-era
    cardano-cli transaction sign --tx-body-file tx${count}.raw --signing-key-file ${paymentkeyfile} --testnet-magic 1097911063 --out-file tx${count}.signed
    cardano-cli transaction submit --tx-file tx${count}.signed --testnet-magic 1097911063

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
          sleep 1
        fi
      done
    done
  fi
}


### Main script starts here 
amount=20000000
nftProject="MultiCNFTsMultiBuys"

start=$1
wallets=$2
number=$3

for (( tmpCnt=$start; tmpCnt<$wallets; tmpCnt++ ))
do
  address=$(cat /home/ubuntu/${nftProject}/test/paymentWallets/payment${tmpCnt}.addr)
  cashWalletAddress=$(cat /home/ubuntu/${nftProject}/test/fundingWallets/payment${number}.addr)
  cashWalletKey="/home/ubuntu/${nftProject}/test/fundingWallets/payment${number}.skey"
  echo $tmpCnt
  myfunc $amount $address $cashWalletAddress $cashWalletKey $3
done