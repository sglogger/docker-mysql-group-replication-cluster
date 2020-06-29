#!/bin/bash

for N in 1 2 3
do docker exec -t mysqldb$N  mysql -uroot -pabcd \
  -e "change master to master_user='repl' for channel 'group_replication_recovery';" \
  -e "START GROUP_REPLICATION;"
done
