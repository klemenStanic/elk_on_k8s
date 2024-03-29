# ELK stack on Kubernetes cluster
This repo contains the steps needed to deploy a basic ELK stack on a Kubernetes cluster (using minikube). A log emmiting pod is also deployed, which ships system resource logs to Logstash, using Filebeats. 

To deploy a local cluster, we are using minikube. Install it by following the instructions at [Minikube](https://minikube.sigs.k8s.io/docs/start/). 
If you are using x86_64 Linux, you can run:
```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

You also need to install [Docker](https://docs.docker.com/get-docker/). On Linux Ubuntu, run:
```
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt install docker-ce
```

Check if Docker is running:
```
sudo systemctl status docker
```

Then, you need to add the current user (which has sudo permissions) to the ```docker``` group:
```
sudo usermod -aG docker $USER && newgrp docker
```

Then, run the minikube cluster with a bit more resources than default:
```
minikube start --cpus 4 --memory 6144 --driver=docker
```

Pull all the needed docker images and allow minikube to access them:
```
docker pull ubuntu:latest
docker pull docker.elastic.co/elasticsearch/elasticsearch:8.2.3
docker pull docker.elastic.co/kibana/kibana:8.2.3
docker pull docker.elastic.co/logstash/logstash:8.2.3
docker pull klemenstanic/log_creator

eval $(minikube docker-env)
```

Deploy all kubernetes resources to cluster (rerun this command if errors):
```
minikube kubectl -- apply -f k8s/
```

Wait for everything to finish:
```
minikube kubectl -- get pods --all-namespaces -w
```


Deploy the log emmiter:
```
minikube kubectl -- apply -f log_creator/k8s
```

Obtain the elasticsearch password from a secret:
```
minikube kubectl -- get secret -n assignment assignment-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode; echo
```

Set up port forwarding in order to access Kibana:
```
minikube kubectl -- port-forward service/assignment-kb-http 5601 -n assignment
```

Open your browser at `localhost:5601` and enter `elastic` as username and paste the elastic password, obtained from the secret. Your dashboard should be under the dashboard tab.
