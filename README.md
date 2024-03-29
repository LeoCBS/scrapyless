# Scrapyless

## Proposal

Running Scrapy as function on kubernetes using custom runtime with scrapy dependencie on kubeless.

## Why?

Running scrapy as serverless.. we could put all backend dependencies in server runtime.. all common logic like as.. input and output logic... message queues.. can stay centralized on server side.. with this we have some benefics

 * better dependencie managemnt
 * reduce operation costs
 * ..


## Requirements 

 * Kubernetes cluster >= 1.15 (Minikube >= 1.15) [install Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)
 * Kubeless - [install here](https://kubeless.io/docs/quick-start/#installation)
 * Kubectl - [install here](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Custom runtime

To make run scrapy without dependencie.. and avoid configuration at which deploy.. we will put everything that our spider needs on one custom kubeless runtime. To check how kubeless runtime works, check this [link](https://github.com/kubeless/kubeless/blob/master/docs/runtimes.md#use-a-custom-runtime). Basiclly, we need provider one Docker image with deps and docker entrypoint must be one http server listem kubeless interaction.

More infos about how developer one custom runtime [here](https://github.com/kubeless/runtimes/blob/master/DEVELOPER_GUIDE.md)

## How build custom runtime

Docker build

    make build-image

Push image
    
    make push-image

## How to deploy

Now we will deploy on simple Spider made with [scrapy framework](https://scrapy.org/) as one simpe function [(serveless)](https://martinfowler.com/articles/serverless.html) using kubeless on kubernetes with specific runtime `scrapy1.7.0`

start minikube with (kubeless already installed):

    minikube start

Change kubeless configmap

    kubectl get kubeless-config -n kubeless -o yaml > kubeless-config.yaml

Add custom runtime config inside runtimes configurations

```{
    "ID": "scrapyless",
    "compiled": false,
    "versions": [
        {
        "name": "scrapyless",
        "version": "latest",
        "runtimeImage": "leocbs/scrapyless:latest",
        "initImage": "python:3.6"
        }
    ],
    "depName": "requirements.txt",
    "fileNameSuffix": ".py"
}
```

Apply new kubernetes config map

     kubectl delete -f ./kubeless-config.yaml && kubectl create -f ./kubeless-config.yaml

Restart the kubeless-controller-manager pod

    PODNAME=$(kubectl get pod -l kubeless=controller -o jsonpath="{.items[0].metadata.name}")
    kubectl get pod $PODNAME -n kubeless -o yaml | kubectl replace --force -f -



## Referencies

https://github.com/defrox/kubeless-custom-runtime
https://kubeless.io/