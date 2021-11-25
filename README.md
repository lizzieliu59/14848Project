# 14848 Project

## Steps

### Cluster Setup

1. Create a GCP cluster using the following command, this will create a kubernete cluster in zone us-east-1-d with 1 machine node and custom machine type:

```
gcloud container clusters create cloud848 --zone=us-east1-d --num-nodes=1 --machine-type=custom-4-12288
```
After execute this command, you could see the kubernetes cluster in Google console:

![Screen Shot 2021-11-25 at 2 46 40 PM](https://user-images.githubusercontent.com/53706052/143494467-7f71d0ff-f0c8-4036-8680-ae6010fd4132.png)

2. In the local environment, make sure the kubernete is installed. Use the command to authenticate with CGP:

```
gcloud container clusters get-credentials cloud848 --zone=us-east1-d
```

3. Make sure your kubernete cluster is the cluster you created (e.g. cloud848) using:

```
kubectl config get-contexts
kubectl config use-context my-cluster-name 
```
![Screen Shot 2021-11-25 at 2 31 32 PM](https://user-images.githubusercontent.com/53706052/143494046-c1bb05d0-5c32-4532-baa8-0a3520142452.png)


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
    4. Run `chmod +x ./hadoop/run.sh` and wait for the bash file finshes executing, this will make the Docker image running in the container.
    5. Exit the node and execute `kubectl apply -f hadoop-service.yaml`

4. Deploy Apache Spark using:

```
kubectl apply -f spark-deployment.yaml
```

5. Deploy the Terminal APP:

```
kubectl apply -f terminal-deployment.yaml
```

After the the above operations, you will have the following deployments, serivces and corresponding pods:

![Screen Shot 2021-11-25 at 2 36 07 PM](https://user-images.githubusercontent.com/53706052/143493983-f2d366cd-9622-492c-950f-78ab6b14b1ff.png)

### Way to use it

1. Use `kubectl get pods` to know which pod the terminal app is running.
2. Use `kubectl exec -it terminalapp-85c5d5ff8f-fxk7n  -- /bin/bash ` to access the terminal of the pod and execute `python3 app.py`
3. Follow the instructions and enter the number of application you want to use. For example, if you want to use Apache Hadoop, then you can type 1 and hit "Return". It will pop out the URL of the service that you can use directory. The example is shown below:

![143492902-48dda438-3d72-43b4-978a-48720d92293a](https://user-images.githubusercontent.com/53706052/143493930-13189c39-d569-40e4-b804-2636425acc31.png)

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
