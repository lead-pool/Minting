echo "Please enter a 'nftProject' Name: "
read nftProject

while true;
do
  echo "Testnet or Mainnet? (T/M)"
  read network
  if [ "$network" = "T" ]
  then
    network="testnet" 
    break
  elif [ "$network" = "M" ]
  then
    network="mainnet"
    break;
  else
    echo "please enter a valid entry"
  fi
done

while true;
do
  echo "Project Type? Single (S), Multi (M), Single Airdrop (SA), Multi Airdrop (MA), Multi Buys (MB), Multi Buys Discount (MBD)"
  read projectType
  if [ "$projectType" = "S" ] || [ "$projectType" = "M" ] || [ "$projectType" = "SA" ] || [ "$projectType" = "MA" ] || [ "$projectType" = "MB" ] || [ "$projectType" = "MBD" ] 
  then
    break;
  else
    echo "please enter a valid entry"
  fi
done
originalPolicy=""
CNFTHoldings=0
if [ "$projectType" = "SA" ] || [ "$projectType" = "MA" ] || [ "$projectType" = "MBD" ]
then
  echo "Original Policy ID:"
  read originalPolicy
fi
if [ "$projectType" = "SA" ] || [ "$projectType" = "MA" ]
then
  echo "CNFTHoldings:"
  read CNFTHoldings
fi


echo "Number of CNFTs?"
read nftCount
nftCost=0

if [ "$projectType" = "S" ] || [ "$projectType" = "M" ] || [ "$projectType" = "MB" ] || [ "$projectType" = "MBD" ]
then
  echo "CNFT Price in lovelaces?"
  read nftCost
fi

discountNftCost=0
if [ "$projectType" = "MBD" ]
then
  echo "CNFT Discounted Price in lovelaces?"
  read discountNftCost
fi

maxBuys=0
if [ "$projectType" = "MB" ] || [ "$projectType" = "MBD" ]
then
  echo "Max buys per tx"
  read maxBuys
fi

echo "When does the policy lock?"
read policyLock
echo "Final payment address:"
read finalWallet
if [ "${finalWallet}" = "" ]
then
  finalWallet="addr_test1qz6ry5dqvre67ytwjd0tymdpeyy0qgc53399tr6fvwfdg7w2vplwthpa07lfjwhlt5synt896lla080mj7vq82mcym5sn0th4n"
fi
echo "Minters fee:"
read minterFee
echo "Minters Address:"
read minterAddress
if [ "${minterAddress}" = "" ]
then
  minterAddress="addr_test1qz7tsfk8ukevxq7plj5gjcjs3cafhk8ry2jv75xzngaajtdc3qpwxgrtffmcn90afpaj2vzxjzvkk6tzpmhgd70em6pshrzcuj"
fi
echo "sessions:"
read sessions
echo "entries per file:"
read entriesPerFile
echo "random setting:"
read randomSetting


if [ "$network" == "testnet" ]
then
  networkParam="--testnet-magic 1097911063"
else
  networkParam="--mainnet"
fi




echo ""
echo "creating Database"
databaseName="${nftProject,,}"

sudo -u postgres psql -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '${nftProject}';"
sudo -u postgres psql -c "drop database ${databaseName};"
sudo -u postgres psql -c "create database ${databaseName};"
sudo -u postgres psql -c "grant all privileges on database ${databaseName} to ubuntu;"
psql -U ubuntu -d ${databaseName} -c "create table log (hash varchar ( 1000 ));"
psql -U ubuntu -d ${databaseName} -c "create table nftcounter (counter int);"
psql -U ubuntu -d ${databaseName} -c "create table temp (block_no int, tx_id int, block_index int, hash varchar ( 1000 ), buys int, discount int);"
psql -U ubuntu -d ${databaseName} -c "create table random (random int);"
psql -U ubuntu -d ${databaseName} -c "create table sender (hash varchar ( 1000 ), buys int, discount int, grouping numeric);"
psql -U ubuntu -d ${databaseName} -c "create table stake_address (id int);"
psql -U ubuntu -d ${databaseName} -c "create table address (address varchar ( 1000 ));"
psql -U ubuntu -d ${databaseName} -c "create table airdrop (address varchar ( 1000 ));"
psql -U ubuntu -d ${databaseName} -c "create table ipfs (nftNumber int, hash varchar ( 1000 ));"
psql -U ubuntu -d ${databaseName} -c "create table metadata (field1 varchar ( 1000 ), field2 varchar ( 1000 ), field3 varchar ( 1000 ), field4 varchar ( 1000 ), field5 varchar ( 1000 ), field6 varchar ( 1000 ), field7 varchar ( 1000 ), field8 varchar ( 1000 ), field9 varchar ( 1000 ), field10 varchar ( 1000 ), field11 varchar ( 1000 ), field12 varchar ( 1000 ), field13 varchar ( 1000 ), field14 varchar ( 1000 ), field15 varchar ( 1000 ), field16 varchar ( 1000 ), field17 varchar ( 1000 ), field18 varchar ( 1000 ), field19 varchar ( 1000 ), field20 varchar ( 1000 ));"
psql -U ubuntu -d ${databaseName} -c "create table settings (network varchar ( 1000 ), nftProject varchar ( 1000 ), nftCount int, nftCost int, finalWallet varchar ( 1000 ), sessions int, randomSetting int, entriesPerFile int, minterFee int, minterAddress varchar ( 1000 ), originalPolicy varchar ( 1000 ), CNFTHoldings int, maxBuys int, discountNftCost int);"
psql -U ubuntu -d ${databaseName} -c "create table wallets (wallet varchar ( 1000 ));"
psql -U ubuntu -d ${databaseName} -t -c "insert into nftcounter values (0);"
psql -U ubuntu -d ${databaseName} -t -c "insert into settings (network, nftProject, nftCount, nftCost, finalWallet, sessions, randomSetting, entriesPerFile, minterFee, minterAddress, originalPolicy, CNFTHoldings, maxBuys, discountNftCost) values ('$network', '$nftProject', $nftCount, $nftCost, '$finalWallet', $sessions, $randomSetting, $entriesPerFile, $minterFee, '$minterAddress', '$originalPolicy', $CNFTHoldings, $maxBuys, $discountNftCost);"

counter=0
if [ $randomSetting -eq 0 ]
then
  counterLength="${#nftCount}"
else
  counterLength=3
fi

finalCount=0
finalString=""

while [ $counter -ne $nftCount ]
do
  counter=$(expr $counter + 1)
  randomLength=$(printf "%0${counterLength}d" $counter)

  finalCount=$(expr $finalCount + 1)

  if [ $finalCount -eq 1 ]
  then
    finalString="($randomLength)"
  else
    finalString="${finalString}, ($randomLength)"
  fi


  if [ $finalCount -eq 100 ]
  then
    insert=$(psql -U ubuntu -d ${databaseName} -t -c "insert into random(random) values $finalString;")
    finalString=""
    finalCount=0
    echo insert
    echo ""
    echo ""
  fi
done

if [ $finalCount -gt 0 ]
then
  insert=$(psql -U ubuntu -d ${databaseName} -t -c "insert into random(random) values $finalString;")
  finalString=""
  finalCount=0
fi

echo "creating Database Done"
echo ""

echo "creating Folder"
mv MintingServices $nftProject


if [ "$projectType" = "S" ] 
then
  rm -r $nftProject/MultiCNFTs
  rm -r $nftProject/MultiCNFTsMultiBuys
  rm -r $nftProject/MultiCNFTsAirdrop
  rm -r $nftProject/SingleCNFTAirdrop
  rm -r $nftProject/MultiCNFTsMultiBuysDiscount
  cp -r $nftProject/SingleCNFT/* $nftProject/.
  rm -r $nftProject/SingleCNFT
  if [ "$network" = "mainnet" ]
  then
    rm -r $nftProject/test
  fi
  mkdir $nftProject/receivingKeys
  mkdir $nftProject/JSON
  mkdir $nftProject/policy
elif [ "$projectType" = "M" ] 
then
  rm -r $nftProject/SingleCNFT
  rm -r $nftProject/MultiCNFTsMultiBuys
  rm -r $nftProject/MultiCNFTsAirdrop
  rm -r $nftProject/SingleCNFTAirdrop
  rm -r $nftProject/MultiCNFTsMultiBuysDiscount
  cp -r $nftProject/MultiCNFTs/* $nftProject/.
  rm -r $nftProject/MultiCNFTs
  if [ "$network" = "mainnet" ]
  then
    rm -r $nftProject/test
  fi
  mkdir $nftProject/receivingKeys
  mkdir $nftProject/JSON
  mkdir $nftProject/policy
  mkdir $nftProject/images
elif [ "$projectType" = "SA" ] 
then
  rm -r $nftProject/MultiCNFTs
  rm -r $nftProject/MultiCNFTsMultiBuys
  rm -r $nftProject/MultiCNFTsAirdrop
  rm -r $nftProject/SingleCNFT
  rm -r $nftProject/MultiCNFTsMultiBuysDiscount
  cp -r $nftProject/SingleCNFTAirdrop/* $nftProject/.
  rm -r $nftProject/SingleCNFTAirdrop
  mkdir $nftProject/sendingKeys
  mkdir $nftProject/JSON
  mkdir $nftProject/policy
elif [ "$projectType" = "MA" ] 
then
  rm -r $nftProject/MultiCNFTs
  rm -r $nftProject/MultiCNFTsMultiBuys
  rm -r $nftProject/SingleCNFT
  rm -r $nftProject/SingleCNFTAirdrop
  rm -r $nftProject/MultiCNFTsMultiBuysDiscount
  cp -r $nftProject/MultiCNFTsAirdrop/* $nftProject/.
  rm -r $nftProject/MultiCNFTsAirdrop
  mkdir $nftProject/sendingKeys
  mkdir $nftProject/JSON
  mkdir $nftProject/policy
  mkdir $nftProject/images
elif [ "$projectType" = "MB" ] 
then
  rm -r $nftProject/SingleCNFT
  rm -r $nftProject/MultiCNFTs
  rm -r $nftProject/MultiCNFTsAirdrop
  rm -r $nftProject/SingleCNFTAirdrop
  rm -r $nftProject/MultiCNFTsMultiBuysDiscount
  cp -r $nftProject/MultiCNFTsMultiBuys/* $nftProject/.
  rm -r $nftProject/MultiCNFTsMultiBuys
  if [ "$network" = "mainnet" ]
  then
    rm -r $nftProject/test
  fi
  mkdir $nftProject/receivingKeys
  mkdir $nftProject/JSON
  mkdir $nftProject/policy
  mkdir $nftProject/images
elif [ "$projectType" = "MBD" ] 
then
  rm -r $nftProject/SingleCNFT
  rm -r $nftProject/MultiCNFTs
  rm -r $nftProject/MultiCNFTsAirdrop
  rm -r $nftProject/MultiCNFTsMultiBuys
  rm -r $nftProject/SingleCNFTAirdrop
  cp -r $nftProject/MultiCNFTsMultiBuysDiscount/* $nftProject/.
  rm -r $nftProject/MultiCNFTsMultiBuysDiscount
  if [ "$network" = "mainnet" ]
  then
    rm -r $nftProject/test
  fi
  mkdir $nftProject/receivingKeys
  mkdir $nftProject/JSON
  mkdir $nftProject/policy
  mkdir $nftProject/images
fi
echo $databaseName > $nftProject/database.txt

echo "creating Folder done"
echo ""



echo "creating policy"
cardano-cli address key-gen --verification-key-file ${nftProject}/policy/${nftProject}.policy.vkey --signing-key-file ${nftProject}/policy/${nftProject}.policy.skey
policyKeyHASH=$(cardano-cli address key-hash --payment-verification-key-file ${nftProject}/policy/${nftProject}.policy.vkey)

echo "{ \"type\": \"all\", \"scripts\": [ { \"slot\": ${policyLock}, \"type\": \"before\" }, { \"keyHash\": \"${policyKeyHASH}\", \"type\": \"sig\" } ] }" > ${nftProject}/policy/${nftProject}.policy.script

policyID=$(cardano-cli transaction policyid --script-file ${nftProject}/policy/${nftProject}.policy.script)

echo $policyID > ${nftProject}/policy/${nftProject}.policy.id

echo "creating policy done"
echo ""



if [ "$projectType" = "S" ] || [ "$projectType" = "M" ] || [ "$projectType" = "MB" ] || [ "$projectType" = "MBD" ] 
then
  echo "create receiving wallet"
  cardano-cli address key-gen --verification-key-file ${nftProject}/receivingKeys/payment.vkey --signing-key-file ${nftProject}/receivingKeys/payment.skey
  cardano-cli address build --payment-verification-key-file ${nftProject}/receivingKeys/payment.vkey --out-file ${nftProject}/receivingKeys/payment.addr ${networkParam}
  echo "create receiving wallet done"
  echo ""
elif [ "$projectType" = "SA" ] || [ "$projectType" = "MA" ] 
then
  echo "create sending wallet"
  cardano-cli address key-gen --verification-key-file ${nftProject}/sendingKeys/payment.vkey --signing-key-file ${nftProject}/sendingKeys/payment.skey
  cardano-cli address build --payment-verification-key-file ${nftProject}/sendingKeys/payment.vkey --out-file ${nftProject}/sendingKeys/payment.addr ${networkParam}
  echo "create sending wallet done"
  echo ""
fi

echo ""
echo ""
echo "PolicyID:" $policyID
if [ "$projectType" = "S" ] || [ "$projectType" = "M" ] || [ "$projectType" = "MB" ] || [ "$projectType" = "MBD" ] 
then
  echo "Receiving Address:" $(cat ${nftProject}/receivingKeys/payment.addr)
fi
echo ""
echo ""
echo ""

if [ "$projectType" = "S" ]
then
  echo "TO DO - COPY JSON FILE TO JSON DIRECTORY AND UPDATE THE POLICY ID"
elif [ "$projectType" = "M" ] || [ "$projectType" = "MB" ] || [ "$projectType" = "MBD" ] 
then
  echo "TO DO - COPY OVER IPFS.TXT AND METADATA.TXT TO IMAGE DIRECTORY"
elif [ "$projectType" = "SA" ]
then
  echo "TO DO - COPY JSON FILE TO JSON DIRECTORY, UPDATE THE POLICY ID AND FUND THE SENDING WALLET"
elif [ "$projectType" = "MA" ]
then
  echo "TO DO - COPY OVER IPFS.TXT AND METADATA.TXT TO IMAGE DIRECTORY AND FUND THE SENDING WALLET" 
fi