one=""
two=""
three=""

while IFS=" " read -r field1 field2
do
  if [ "$one" = "" ]
  then
    one=$field2
  elif [ "$two" = "" ]
  then
    two=$field2
  elif [ "$three" = "" ]
  then
    three=$field2
  fi
done < ipfs.txt

echo $one
echo $two
echo $three


counter=101
count=1
count2=1
while [ $count -ne $counter ]
do
  if [ $count2 -eq 1 ]
  then
    echo $count $one >> ipfs2.txt
    count2=$(expr $count2 + 1)
  elif [ $count2 -eq 2 ]
  then
    echo $count $two >> ipfs2.txt
    count2=$(expr $count2 + 1)
  elif [ $count2 -eq 3 ]
  then
    echo $count $three >> ipfs2.txt
    count2=1
  fi
  count=$(expr $count + 1)
done

mv ipfs2.txt ipfs.txt