# debserve
Debian-based repository creation and hosting via Aptly and Apache

***OVERVIEW***

Container which builds, hosts, and optionally signs a public repository from a directory of .deb packages and updates this repository when changes are made to the .deb directory

***Dockerhub:***
https://hub.docker.com/r/davidpatawaran/debserve/ *note: dockerhub container uses NGINX rather then Apache

***USAGE***

The command below will run the container, creating a repository consisting of all packages in the ~/test-debs directory and hosted at localhost:4000 (note: the internal container script points at the /debs directory, so the -v flag syntax should be $HOSTDIR:/debs)

- docker run -p 4000:80 -v ~/test-debs:/debs davidpatawaran/debserve

optionally run with the additional flags shown below, which will sign the repo with gpg key matching the ID 1234EXAMPLE with passphrase "pass", which should be found in the host directory ~/.gnupg (note: -v flag syntax should be $HOSTGPGDIR:/.gnupg)

- docker run -e GPG_ID=1234EXAMPLE -e GPG_PASS=pass -p 4000:80 -v ~/test-debs:/debs -v ~/.gnupg:/.gnupg davidpatawaran/debserve

In order to give the repo a custom name, distribution, and/or component, pass the docker run command -e flags with the desired variable values. The command below will create a repo named "example", holding the distribution "stable" and component "contrib" without these flags the repo defaults to name:debserve distribtion:testing component:main

- docker run -e REPO_NAME=example -e DISTRIBUTION=stable -e COMPONENT=contrib -p 4000:80 -v ~/test-debs:/debs davidpatawaran/debserve

run with --name $NAME to name the container, and --restart always to have the container restart whenever it exits

to consume packages, add 'deb http://$HOSTIP:$PORT/ $DISTRIBUTION $COMPONENT' to /etc/apt/sources.list and apt-get update

***Docker run flags***

- The -d flag (detached) runs the container in the background and prints the container's ID

- The -e flag passes an environmental variable to the Docker container, to be used within the script.

- The -p flag maps a port in the docker container to a port on the localhost, for example, -p 8080:80 maps port 8080 on the host to port 80 on the docker container. Allows the container to communicate with the outside world.

- The -v flag mounts a specified host directory into the container, enabling the container to share files in this directory with the host. This creates a location to upload packages and allows for repo updates without restarting the container.

***BUILDING FROM SOURCE***

clone repo into a directory, cd into the directory, and run the command below, which will build a docker container from source

- docker build -t debserve

the -t flag tags the docker container with a name by which it can be run, in this case the container is named "debserve"

***Troubleshooting***

Should there be an unknown failure within this container the command below can be used to show the output a container is generating when it is not run interactively
- sudo docker logs --tail 50 --follow --timestamps $CONTAINER_ID

If necessary, the command below can be used to open a shell inside the container
- sudo docker exec -i -t $CONTAINER_ID /bin/bash

***NOTE***

Anyone who wishes to consume a signed repo must first pull the public key, either manually or via a keyserver

- notes on gpg key creation: https://www.gnupg.org/gph/en/manual/c14.html

- notes on obtaining gpg public key: https://askubuntu.com/questions/36507/how-do-i-import-a-public-key

***Debserve as used in the FAME project here: https://github.com/FabricAttachedMemory/l4fame-repo-container***