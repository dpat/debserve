# debserve
Debian-based repository creation and hosting via Aptly and Apache

***USAGE***

clone repo into a directory, cd into the directory, and run the commands below, which will build a docker container from source and then run the container, creating a repository consisting of all packages in the ~/test-debs directory and hosted at localhost:4000

- sudo docker build -t debserve

- sudo docker run -p 4000:80 -v ~/test-debs:/debs davidpatawaran/debserve

***docker run flags***

- The -p flag maps a port in the docker container to a port on the localhost, for example, -p 8080:80 maps port 8080 on the host to port 80 on the docker container. Allows the container to communicate with the outside world.

- The -v flag mounts a specified host directory into the container, enabling the container to share files in this directory with the host. This creates a location to upload packages and allows for repo updates without restarting the container.

***ALPHA VERSION***

Does not currently support repo signing

Container which builds and hosts a public repository from a directory of .deb packages and updates this repository when changes are made to the .deb directory

Utilizes Aptly for repository creation and Apache for hosting

The command below will host a repo at localhost:4000 consisting of all packages in the ~/test-debs directory:

sudo docker run -p 4000:80 -v ~/test-debs:/debs davidpatawaran/debserve

***v2 functionality additions:***
- automatic repo updating when changes are made to the host .deb directory
- removed company proxy
- i386 support

***Dockerhub Link***
https://hub.docker.com/r/davidpatawaran/debserve/
