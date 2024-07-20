# deploycvat (reference https://github.com/cvat-ai/cvat)

1. Dockerfile to create a cvat container image to be deployed in linux cloud for enterprise users, using python 3.9+
2. Allow multiple users to connect to the container URL to annotate their own images, which are uploaded from their laptop.

# success criteria
1. The Dockerfile can be used to build the container image on Win10 laptop.
2. The Dockerfile uses python 3.9 or newer version.
3. The image can run on DockerDesktop using WSL core. Try to create a loadbalancer for the container.
4. Allow more than 1 user to connect to CVAT on webbrowser (chrome).  Refer to CVAT user's guide,  Try to upload any image and draw a retangle anywhere on the image as annotation test.  

# how to run locally
1. docker build -f Dockerfile -t cvat-local .
2. docker run -p 3000:3000 cvat-local

# access bash 
1. docker run -it cvat-local /bin/bash # for ubunutu terminal instead of python shell

# kubernetes setup (windows, local)
The deployments for CVAT were created using kompose convert.
Here are the instructions for starting a kubernetes cluster locally:

1. [Install minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fwindows%2Fx86-64%2Fstable%2F.exe+download)
2. Use kubectl. Minikube has kubectl prepackaged with it, just use minikube kubectl -- kubectl_commands. It may ask you to install minikube in your system as well.
3. Run docker desktop
4. minikube start
5. Run the application using `kubectl apply -f cvat-cache-db-persistentvolumeclaim.yaml,cvat-data-persistentvolumeclaim.yaml,cvat-db-deployment.yaml,cvat-db-persistentvolumeclaim.yaml,cvat-inmem-db-persistentvolumeclaim.yaml,cvat-keys-persistentvolumeclaim.yaml,cvat-logs-persistentvolumeclaim.yaml,cvat-opa-deployment.yaml,cvat-redis-inmem-deployment.yaml,cvat-redis-ondisk-deployment.yaml,cvat-server-deployment.yaml,cvat-ui-deployment.yaml,cvat-utils-deployment.yaml,cvat-worker-analytics-reports-deployment.yaml,cvat-worker-annotation-deployment.yaml,cvat-worker-export-deployment.yaml,cvat-worker-import-deployment.yaml,cvat-worker-quality-reports-deployment.yaml,cvat-worker-webhooks-deployment.yaml,traefik-deployment.yaml,traefik-service.yaml`
6. Allow minikube to connect to traefik LoadBalancer by running `minikube tunnel`
7. Check the external ip of traefik using `kubectl get services`
8. Access the application using traefik's external ip `<external_ip:8080> 
