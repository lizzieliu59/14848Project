# 14848 Project

## Steps

### Cluster Setup

1. Create a GCP cluster using:

```
gcloud container clusters create cloud848 --zone=us-east1-d --num-nodes=1 --machine-type=custom-4-12288
```

2. In the local environment, make sure the kubernete is installed. Use the command to authenticate with CGP:

```
gcloud container clusters get-credentials cloud848 --zone=us-east1-d
```

3. Make sure your kubernete cluster is the cluster you created (e.g. cloud848) using:

```
kubectl config get-contexts 
```

### Reserve Static IP

1. By following the instruction in https://cloud.google.com/compute/docs/ip-addresses/reserve-static-external-ip-address#reserve_new_static this link to reserve a static ip, which will be used as your load balancer's IP address later.

### Deployment

**You will need execute the following command under the project/k8s directory.**

1. Deploy the Jupyter Notebook using:

```
kubectl apply -f jupyter-deployment.yaml
kubectl apply -f jupyter-service.yaml
```

2. Deploy the SonarQube and SonarScanner:

```
kubectl apply -f jupyter-deployment.yaml
kubectl apply -f jupyter-service.yaml
```

3. Deploy the Apache Hadoop:
    1. Execute `kubectl apply -f hadoop-deployment.yaml`
    2. Use `kubectl get pods` to get the pod name with hadoop. (e.g. hadoop-686765c6cd-4xcqt)
    3. Use `kubectl exec -it hadoop-686765c6cd-4xcqt  -- /bin/sh` access the shell of the hadoop node.
    4. Run `chmod +x ./conf/run.sh` and wait for the bash file finshes executing, this will make the Docker image running in the container.
    5. Exit the node and execute `kubectl apply -f hadoop-service.yaml`

4. Deploy Apache Spark using:

```
kubectl apply -f spark-deployment.yaml
```

5. Deploy the Terminal APP:

```
kubectl apply -f terminal-deployment.yaml
```

### Way to use it

1. Use `kubectl get pods` to know which pod the terminal app is running.
2. Use `kubectl exec -it terminalapp-85c5d5ff8f-fxk7n  -- /bin/bash ` to access the terminal of the pod and execute `python3 app.py`
3. Follow the instructions and enter the number of application you want to use. For example, if you want to use Apache Hadoop, then you can type 1 and hit "Return". It will pop out the URL of the service that you can use directory. The example is shown below:

![Screen Shot 2021-10-28 at 12 51 39 AM](https://user-images.githubusercontent.com/53706052/139189109-87ea56c7-55bc-4684-a66b-62cc52530def.png)

## Screenshots of services running in the k8s cluster
From kubectl:
![Screen Shot 2021-10-28 at 12 51 05 AM](https://user-images.githubusercontent.com/53706052/139189177-12ab1174-eabf-4019-8e7f-e0bf61ad41cf.png)

From GCP:
<img width="1438" alt="Screen Shot 2021-10-28 at 12 53 32 AM" src="https://user-images.githubusercontent.com/53706052/139189266-6604656f-f758-420f-8136-84447f7f4722.png">


## Docker Images used

- Jupyter Notebook: https://hub.docker.com/r/jupyter/base-notebook

- SonarQube and SonarScanner: https://hub.docker.com/r/yueliu14848/sonarque_with_scanner (source code is under project/sonar directory)

- Apache Hadoop: https://hub.docker.com/r/yueliu14848/hadoop (source code is under project/hadoop-multinode directory)

- Apach Spark:
    - Master: https://hub.docker.com/r/bde2020/spark-master
    - Node:  https://hub.docker.com/r/bde2020/spark-worker
- Terminal App: https://hub.docker.com/repository/docker/yueliu14848/terminalapp (source code is under project/terminalApp directory)

## References

1. For the SonarQube and SonarScanner, I built the images from https://hub.docker.com/_/sonarqube this official image and follow the document https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/ to build my own customized image.
2. For the Apache Hadoop image, I built it upon the image used in this project https://github.com/lvntyldz/docker-multinode-hadoop and add my own configuration to make it suitable for kubernetes deployment.
3. For the Apache Spark deployment file, I referenced the file from https://raw.githubusercontent.com/big-data-europe/docker-spark/master/k8s-spark-cluster.yaml
