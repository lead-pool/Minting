nftProject="MultiCNFTsMultiBuysDiscount"
wallets=4

for (( tmpCnt=0; tmpCnt<$wallets; tmpCnt++ ))
do
  cardano-cli address key-gen --verification-key-file /home/ubuntu/${nftProject}/test/fundingWallets/payment${tmpCnt}.vkey --signing-key-file /home/ubuntu/${nftProject}/test/fundingWallets/payment${tmpCnt}.skey
  cardano-cli address build --payment-verification-key-file /home/ubuntu/${nftProject}/test/fundingWallets/payment${tmpCnt}.vkey --out-file /home/ubuntu/${nftProject}/test/fundingWallets/payment${tmpCnt}.addr --testnet-magic 1097911063
done