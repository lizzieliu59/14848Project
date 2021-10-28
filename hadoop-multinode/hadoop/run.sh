#Create a network named "hadoopNetwork"
docker network create -d bridge   --subnet 172.25.0.0/16  hadoopNetwork

#Create base hadoop-multinode image named "base-hadoop-multinode:1.0"
docker build -t base-hadoop-multinode:1.0 .

#run base-hadoop-multinode:1.0 image  as master container
docker run -itd  --network="hadoopNetwork"  --ip 172.25.0.100  -p 50070:50070  -p 8088:8088 --name master --hostname master  base-hadoop-multinode:1.0

tmpName="slave1"
#run base-hadoop-multinode:1.0 image  as slave container
docker run -itd  --network="hadoopNetwork"  --ip "172.25.0.101" --name $tmpName --hostname $tmpName  base-hadoop-multinode:1.0

tmpName="slave2"
#run base-hadoop-multinode:1.0 image  as slave container
docker run -itd  --network="hadoopNetwork"  --ip "172.25.0.102" --name $tmpName --hostname $tmpName  base-hadoop-multinode:1.0

#run hadoop-multinode commands
docker exec -ti master bash  -c "hadoop namenode -format && /usr/local/hadoop/sbin/start-dfs.sh && /usr/local/hadoop/sbin/start-yarn.sh"
docker exec -ti master bash
