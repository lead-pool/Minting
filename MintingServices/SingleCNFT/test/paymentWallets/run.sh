cardano-cli query protocol-parameters --testnet-magic 1097911063 --out-file protocol.json

./fundWallets.sh 1 11 1 &
./fundWallets.sh 11 21 2 &
./fundWallets.sh 21 31 3 &
./fundWallets.sh 31 41 4 &
./fundWallets.sh 41 51 5 &
./fundWallets.sh 51 61 6 &
./fundWallets.sh 61 71 7 &
./fundWallets.sh 71 81 8 &
./fundWallets.sh 81 91 9 &
./fundWallets.sh 91 101 10