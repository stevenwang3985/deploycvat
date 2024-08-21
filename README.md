# deploycvat (reference https://github.com/cvat-ai/cvat)

1. Dockerfile to create a cvat container image to be deployed in linux cloud for enterprise users, using python 3.9+
2. Allow multiple users to connect to the container URL to annotate their own images, which are uploaded from their laptop.

# success criteria (mostly outdated)
1. The Dockerfile can be used to build the container image on Win10 laptop.
2. The Dockerfile uses python 3.9 or newer version.
3. The image can run on DockerDesktop using WSL core. Try to create a loadbalancer for the container.
4. Allow more than 1 user to connect to CVAT on webbrowser (chrome).  Refer to CVAT user's guide,  Try to upload any image and draw a retangle anywhere on the image as annotation test. (main criteria) 

# Local Deployment

## System:
Windows 11, Docker Desktop, Kubernetes, helm

## Steps:
1. Install Helm
2. Run Docker Desktop
3. Enable Kubernetes in Docker Desktop
4. Navigate to deploycvat/helm-chart
5. Install dependencies using `helm dependency update`

7. Install cvat
`helm upgrade -i cvat ./ -f ./override.values.yaml`

8. Create SuperUser
- get the name of the backend pod
`BACKEND_POD_NAME = kubectl get pod --namespace default -l tier=backend,app.kubernetes.io/instance=cvat,component=server -o jsonpath='{.items[0].metadata.name}'`

- ssh into the backend pod and create a SuperUser
`kubectl exec -it --namespace default BACKEND_POD_NAME -c cvat-backend -- python manage.py createsuperuser`
- follow the instructions to create the SuperUser
- remember the username and password you created
9. View ui at localhost
- Enter your username and password and you should be able to access

# Cloud Deployment 

## System:
Rancher, Helm, Github Pages

## Steps:
Uses [Helm Chart Releaser Action](https://github.com/marketplace/actions/helm-chart-releaser) to publish the chart to gh-pages, Github Pages to host the chart which you can pull 
