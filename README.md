# MySQL Group Replication with Docker MySQL Images
This is using master-only-nodes (no slaves/secondaries)


## Prerequisites ##
Docker and docker-compose are installed, up and running

## Step 1: get the files and bring them up ##
- Clone the project
- adjust the `docker-compose.yml` to your needs
- adjust the 'secret-mysql.env' file for your needs
- adjust the shell scripts (1/2/3....sh) file for your needs

```
docker-compose up -d

Creating network "mysqlgrclusterworking_db_backend" with the default driver
Creating mysqldb3 ...
Creating mysqldb1 ...
Creating mysqldb2 ...
Creating mysqldb3
Creating mysqldb1
Creating mysqldb3 ... done
```

## Step 2: when all containers are up > start replication ##
Check with "docker ps" if the status is 'Up ... (health: healthy)'

```
steven@docker2:~/docker-repository/mysql-gr-cluster-working$ docker ps
CONTAINER ID        IMAGE                    COMMAND                  CREATED             STATUS                             PORTS                                                    NAMES
4788306c44ca        mysql/mysql-server:8.0   "/entrypoint.sh mysq…"   26 seconds ago      Up 24 seconds (health: starting)   33060/tcp, 0.0.0.0:3307->3306/tcp                        mysqldb2
1675b8f37cbf        mysql/mysql-server:8.0   "/entrypoint.sh mysq…"   26 seconds ago      Up 22 seconds (health: starting)   0.0.0.0:3306->3306/tcp, 33060/tcp                        mysqldb1
b021996ab41e        mysql/mysql-server:8.0   "/entrypoint.sh mysq…"   26 seconds ago      Up 22 seconds (health: starting)   33060/tcp, 0.0.0.0:3308->3306/tcp                        mysqldb3
```

when ready it should read like this:
```
steven@docker2:~/docker-repository/mysql-gr-cluster-working$ docker ps
CONTAINER ID        IMAGE                    COMMAND                  CREATED              STATUS                        PORTS                                                    NAMES
4788306c44ca        mysql/mysql-server:8.0   "/entrypoint.sh mysq…"   About a minute ago   Up About a minute (healthy)   33060/tcp, 0.0.0.0:3307->3306/tcp                        mysqldb2
1675b8f37cbf        mysql/mysql-server:8.0   "/entrypoint.sh mysq…"   About a minute ago   Up About a minute (healthy)   0.0.0.0:3306->3306/tcp, 33060/tcp                        mysqldb1
b021996ab41e        mysql/mysql-server:8.0   "/entrypoint.sh mysq…"   About a minute ago   Up About a minute (healthy)   33060/tcp, 0.0.0.0:3308->3306/tcp                        mysqldb3
```

Then execute the intial sync using 1_setup-replication.sh:
```
steven@docker2:~/docker-repository/mysql-gr-cluster-working$ ./1_setup-replication.sh
mysql: [Warning] Using a password on the command line interface can be insecure.
+---------------------------+--------------------------------------+-------------+-------------+--------------+-------------+----------------+
| CHANNEL_NAME              | MEMBER_ID                            | MEMBER_HOST | MEMBER_PORT | MEMBER_STATE | MEMBER_ROLE | MEMBER_VERSION |
+---------------------------+--------------------------------------+-------------+-------------+--------------+-------------+----------------+
| group_replication_applier | b4396349-ba19-11ea-b968-0242c0a85004 | mysqldb1    |        3306 | RECOVERING   | PRIMARY     | 8.0.20         |
+---------------------------+--------------------------------------+-------------+-------------+--------------+-------------+----------------+
mysql: [Warning] Using a password on the command line interface can be insecure.
mysql: [Warning] Using a password on the command line interface can be insecure.
```

## Step 3: check replication ##
execute ./2_test-gr.sh:
```
steven@docker2:~/docker-repository/mysql-gr-cluster-working$ ./2_test-gr.sh
mysql: [Warning] Using a password on the command line interface can be insecure.
+---------------+----------+
| Variable_name | Value    |
+---------------+----------+
| hostname      | mysqldb1 |
+---------------+----------+
+---------------------------+--------------------------------------+-------------+-------------+--------------+-------------+----------------+
| CHANNEL_NAME              | MEMBER_ID                            | MEMBER_HOST | MEMBER_PORT | MEMBER_STATE | MEMBER_ROLE | MEMBER_VERSION |
+---------------------------+--------------------------------------+-------------+-------------+--------------+-------------+----------------+
| group_replication_applier | b3ca0d79-ba19-11ea-962c-0242c0a85002 | mysqldb2    |        3306 | ONLINE       | PRIMARY     | 8.0.20         |
| group_replication_applier | b4385c22-ba19-11ea-985e-0242c0a85003 | mysqldb3    |        3306 | ONLINE       | PRIMARY     | 8.0.20         |
| group_replication_applier | b4396349-ba19-11ea-b968-0242c0a85004 | mysqldb1    |        3306 | ONLINE       | PRIMARY     | 8.0.20         |
+---------------------------+--------------------------------------+-------------+-------------+--------------+-------------+----------------+
Test check passed, 3 nodes ONLINE
```

Done :)

## Shutdown / Remove ##
If you want to shutdown the containers just type 'docker-compose down' in the path, where you specified the file 'docker-compose.yml'


## Restarted Container / not in Sync ##
Please check ./3_start-repl.sh

## Thanks to ... ##
Thanks to Franchin @wagnerjfr for the support and inspiration



## Helpful Links ##
- https://mysqlhighavailability.com/setting-up-mysql-group-replication-with-mysql-docker-images/
- https://dev.mysql.com/doc/refman/8.0/en/replication.html
- https://github.com/wagnerjfr/mysql-group-replication-docker
- https://github.com/wagnerjfr/mysql-group-replication-docker-compose

