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
2. docker run cvat-local