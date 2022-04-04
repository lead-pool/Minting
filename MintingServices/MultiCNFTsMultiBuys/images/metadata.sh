counter=10001
count=1
count2=1
echo "Filename,name,Trait 1,Trait 2,Trait 3,Trait 4,Trait 5" >> metadata2.txt
while [ $count -ne $counter ]
do
  if [ $count2 -eq 1 ]
  then
    echo "MultiCNFTsMultiBuys${count},NFT Maker #${count},NFT Maker Test,Blue,Green,Yellow,Gold" >> metadata2.txt
    count2=$(expr $count2 + 1)
  elif [ $count2 -eq 2 ]
  then
    echo "MultiCNFTsMultiBuys${count},NFT Maker #${count},NFT Maker Test,None,None,None,None" >> metadata2.txt
    count2=$(expr $count2 + 1)
  elif [ $count2 -eq 3 ]
  then
    echo "MultiCNFTsMultiBuys${count},NFT Maker #${count},NFT Maker Test,Red,Blue,Yellow,Purple" >> metadata2.txt
    count2=1
  fi
  count=$(expr $count + 1)
done
mv metadata2.txt metadata.txt