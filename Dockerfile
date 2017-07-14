FROM debian:stable
MAINTAINER "David Patawaran <david.patawaran@gmail.com>"

# set environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV GNUPGHOME /.gnupg
ENV GPG_ID ""

# defaults for repo creation
ENV REPO_NAME L4fame
ENV DISTRIBUTION testing
ENV COMPONENT main
ENV ARCHITECTURES amd64,i386,x86

# install necessary packages
RUN apt-get update && \
    apt-get install -y pinentry-curses aptly xz-utils apache2 gpg && \
    apt-get clean

ADD init_repo.sh /init_repo.sh
ENTRYPOINT ["/init_repo.sh"]