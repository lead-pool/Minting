wallets=1001
nftProject="SingleCNFT"
for (( tmpCnt=1; tmpCnt<$wallets; tmpCnt++ ))
do
  cardano-cli address key-gen --verification-key-file /home/ubuntu/${nftProject}/test/paymentWallets/payment${tmpCnt}.vkey --signing-key-file /home/ubuntu/${nftProject}/test/paymentWallets/payment${tmpCnt}.skey
  cardano-cli address build --payment-verification-key-file /home/ubuntu/${nftProject}/test/paymentWallets/payment${tmpCnt}.vkey --out-file /home/ubuntu/${nftProject}/test/paymentWallets/payment${tmpCnt}.addr --testnet-magic 1097911063
done