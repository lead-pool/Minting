databaseName=$1
policy=$2
holdings=$3
db=$4


policyHash="\x$policy"

echo $policyHash

if [ $holdings -eq 1 ]
then
  
  sql=$(psql -U ubuntu -d $db -t -c "select mto.quantity, uv.address from utxo_view uv inner join ma_tx_out mto on uv.id = mto.tx_out_id where uv.id in (select tx_out_id from ma_tx_out where ident in (select id from multi_asset where policy = '${policyHash}')) and mto.ident in (select id from multi_asset where policy = '${policyHash}');")
  echo $sql
  value1=0

  for value in $sql
  do
    if [ $value != "|" ]
    then
      if [ $value1 -eq 0 ]
      then
        value1=$value
      else
        counter=1
        while true;
        do
          insert=$(psql -U ubuntu -d ${databaseName} -t -c "insert into airdrop(address) values ('${value}');")
          if [ $counter -eq $value1 ]
          then
            break
          else
            counter=$(expr $counter + 1)
          fi
        done
        value1=0
      fi
      

    fi
  done 

else
  
  # Stake Address grouping
  insert=$(psql -U ubuntu -d ${databaseName} -t -c "truncate table stake_address;")
  sql=$(psql -U ubuntu -d $db -t -c "select mto.quantity, uv.stake_address_id from utxo_view uv inner join ma_tx_out mto on uv.id = mto.tx_out_id where uv.id in (select tx_out_id from ma_tx_out where ident in (select id from multi_asset where policy = '${policyHash}')) and mto.ident in (select id from multi_asset where policy = '${policyHash}') and uv.stake_address_id is not null;")

  value1=0

  for value in $sql
  do
    if [ $value != "|" ]
    then
      if [ $value1 -eq 0 ]
      then
        value1=$value
      else
        counter=1
        while true;
        do
          insert=$(psql -U ubuntu -d ${databaseName} -t -c "insert into stake_address(id) values ($value);")
          if [ $counter -eq $value1 ]
          then
            break
          else
            counter=$(expr $counter + 1)
          fi
        done
        value1=0
      fi
    fi
  done 


  sql=$(psql -U ubuntu -d ${databaseName} -t -c "select count(*), id from stake_address group by id having count(*) >= ${holdings}")
  value1=0
  for result in $sql
  do
    if [ $result != "|" ]
    then
      if [ $value1 -eq 0 ]
      then
        value1=$result
      else
        counter=1
        value1=$(expr $value1 / $holdings)
        while true;
        do
          sql2=$(psql -U ubuntu -d $db -t -c "select address from utxo_view where id in (select tx_out_id from ma_tx_out where ident in (select id from multi_asset where policy = '${policyHash}')) and stake_address_id = ${result} limit 1")
          insert=$(psql -U ubuntu -d ${databaseName} -t -c "insert into airdrop(address) values ('${sql2}');")
          if [ $counter -eq $value1 ]
          then
            break
          else
            counter=$(expr $counter + 1)
          fi
        done
        value1=0
      fi
    fi
  done










  # Address without Stake Address grouping
  insert=$(psql -U ubuntu -d ${databaseName} -t -c "truncate table address;")
  sql=$(psql -U ubuntu -d $db -t -c "select mto.quantity, uv.address from utxo_view uv inner join ma_tx_out mto on uv.id = mto.tx_out_id where uv.id in (select tx_out_id from ma_tx_out where ident in (select id from multi_asset where policy = '${policyHash}')) and mto.ident in (select id from multi_asset where policy = '${policyHash}') and uv.stake_address_id is null;")

  value1=0

  for value in $sql
  do
    if [ $value != "|" ]
    then
      if [ $value1 -eq 0 ]
      then
        value1=$value
      else
        counter=1
        while true;
        do
          insert=$(psql -U ubuntu -d ${databaseName} -t -c "insert into address(address) values ('${value}');")
          if [ $counter -eq $value1 ]
          then
            break
          else
            counter=$(expr $counter + 1)
          fi
        done
        value1=0
      fi
    fi
  done 



  sql=$(psql -U ubuntu -d ${databaseName} -t -c "select count(*), address from address group by address having count(*) >= ${holdings}")
  value1=0
  for result in $sql
  do

    if [ $result != "|" ]
    then
      if [ $value1 -eq 0 ]
      then
        value1=$result
      else
        counter=1
        value1=$(expr $value1 / $holdings)
        while true;
        do
          echo $result
          insert=$(psql -U ubuntu -d ${databaseName} -t -c "insert into airdrop(address) values ('${result}');")
          if [ $counter -eq $value1 ]
          then
            break
          else
            counter=$(expr $counter + 1)
          fi
        done
        value1=0
      fi
    fi
  done


fi
echo airdropDone