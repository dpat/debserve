FROM debian:stable
MAINTAINER "David Patawaran <david.patawaran@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

# defaults for repo creation
ENV REPO_NAME L4fame
ENV DISTRIBUTION testing
ENV COMPONENT main
ENV ARCHITECTURES amd64,i386

# install necessary packages
RUN apt-get update && \
    apt-get install -y aptly xz-utils apache2 && \
    apt-get clean

ADD init_repo.sh /init_repo.sh
ENTRYPOINT ["/init_repo.sh"]