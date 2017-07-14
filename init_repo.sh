#!/bin/bash

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

function main {
    init_script
    error_check

    create_repo
    sign_repo
    serve_repo

    update_repo
}

# create repo from .deb packages
function create_repo {
    aptly repo create \
        -component="$COMPONENT" \
        -distribution="$DISTRIBUTION" \
        $REPO_NAME
    aptly repo add $REPO_NAME /debs/
    aptly publish repo \
        -architectures="$ARCHITECTURES" \
        -skip-signing=true \
        $REPO_NAME
}

# manually sign Release file for authenticated repo if specified
# aptly gpg2 signing is not supported so this is done manually
function sign_repo {
    if [ "$GPG_ID" != "" ]
    then
        gpg -u $GPG_ID --batch --pinentry-mode loopback --passphrase "$GPG_PASS" \
        --clearsign -o $RELEASE_PATH/InRelease $RELEASE_PATH/Release
        gpg -u $GPG_ID --batch --pinentry-mode loopback --passphrase "$GPG_PASS" \
        -abs -o $RELEASE_PATH/Release.gpg $RELEASE_PATH/Release
    fi
}

# delete repo in order to re-publish
function drop_repo {
    aptly publish drop $DISTRIBUTION
    aptly repo drop $REPO_NAME
}

# move repo to whatever location hosting software is using
function serve_repo {
    rm -r /var/www/html
    mkdir /var/www/html
    cp -r ~/.aptly/public/. /var/www/html/.
}

# check for changes to .deb directory
# update repo when change is detected
function update_repo {
    CHECK_DIR='debs'
    stat -t $CHECK_DIR > deb_check.txt
    INIT_STAT=`cat deb_check.txt`
    while true; do
        sleep 30
        CHECK_STAT=`stat -t $CHECK_DIR`
        if [ "$INIT_STAT" != "$CHECK_STAT" ]
        then
            drop_repo
            create_repo
            sign_repo
            serve_repo
            CHECK_STAT=`stat -t $CHECK_DIR`
            INIT_STAT=`echo $CHECK_STAT`
        fi
    done
}

# initializes script with necessary variables
# and starts apache
function init_script {
    RELEASE_PATH=~/.aptly/public/dists/$DISTRIBUTION
    /usr/sbin/apache2ctl start
}

# looks for issues with keys and packages
# stops container if a problem is detected and alerts the user
function error_check {
    set -e

    if [ ! -d /debs ]
    then
        echo "Mount your Debian package directory to /debs."
        exit 1
    fi

}

main "$@"