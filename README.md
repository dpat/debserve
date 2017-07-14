# debserve
Debian-based repository creation and hosting via Aptly and Apache

***Dockerhub:***
https://hub.docker.com/r/davidpatawaran/debserve/

***USAGE***

clone repo into a directory, cd into the directory, and run the commands below, which will build a docker container from source and then run the container, creating a repository consisting of all packages in the ~/test-debs directory and hosted at localhost:4000

- sudo docker build -t debserve

- sudo docker run -p 4000:80 -v ~/test-debs:/debs davidpatawaran/debserve

optionally run with the additional flags shown below, which will sign the repo with gpg key matching the ID 1234EXAMPLE with passphrase "pass", which should be found in the host directory ~/.gnupg

- sudo docker run -e GPG_ID=1234EXAMPLE -e GPG_PASS=pass -p 4000:80 -v ~/test-debs:/debs -v ~/.gnupg:/.gnupg davidpatawaran/debserve

***docker run flags***

- The -e flag passes an environmental variable to the Docker container, to be used within the script.

- The -p flag maps a port in the docker container to a port on the localhost, for example, -p 8080:80 maps port 8080 on the host to port 80 on the docker container. Allows the container to communicate with the outside world.

- The -v flag mounts a specified host directory into the container, enabling the container to share files in this directory with the host. This creates a location to upload packages and allows for repo updates without restarting the container.

***ALPHA VERSION***

May abstract hosting to a seperate container in the future 

Container which builds, hosts, and optionally signs a public repository from a directory of .deb packages and updates this repository when changes are made to the .deb directory

Utilizes Aptly for repository creation and Apache for hosting

The command below will host a repo at localhost:4000 consisting of all packages in the ~/test-debs directory:

sudo docker run -p 4000:80 -v ~/test-debs:/debs davidpatawaran/debserve

The command below will do the same as above, additionally signing the repo with gpg key ID 1234EXAMPLE and passphrase "pass"

sudo docker run -e GPG_ID=1234EXAMPLE -e GPG_PASS=pass -p 4000:80 -v ~/test-debs:/debs -v ~/.gnupg:/.gnupg davidpatawaran/debserve

***v3 functionality additions:***
- signing is now supported

***NOTE***

Anyone who wishes to consume a signed repo must first pull the public key, either manually or via a keyserver

- notes on gpg key creation: https://www.gnupg.org/gph/en/manual/c14.html

- notes on obtaining gpg public key: https://askubuntu.com/questions/36507/how-do-i-import-a-public-key
