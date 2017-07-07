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


set -e

if [ ! -d /debs ]
then
    echo "Mount your Debian package directory to /debs."
    exit 1
fi

# create repo from .deb packages 
aptly repo create \
    -component="$COMPONENT" \
    -distribution="$DISTRIBUTION" \
    $REPO_NAME
aptly repo add $REPO_NAME /debs/
aptly publish repo \
    -architectures="$ARCHITECTURES" \
    -skip-signing=true \
    $REPO_NAME

# initiate apache server with repo
rm /var/www/html/index.html
cp -r ~/.aptly/public/. /var/www/html/.
/usr/sbin/apache2ctl start

# check for changes to .deb directory
# update repo when change is detected
stat -t debs > deb_check.txt
while true; do

    sleep 30
    CHECK_DIR='debs'
    INIT_STAT='/deb_check.txt'
    
    if [ -e $INIT_STAT]
    then
        HOLD_STAT=`cat $INIT_STAT`
    else
        HOLD_STAT="nothing"
    fi
 
    CHECK_STAT=`stat -t $CHECK_DIR`
 
    if [ "$HOLD_STAT" != "$CHECK_STAT" ]
    then
        aptly publish drop $DISTRIBUTION
        aptly repo drop $REPO_NAME
        aptly repo create \
            -component="$COMPONENT" \
            -distribution="$DISTRIBUTION" \
            $REPO_NAME
        aptly repo add $REPO_NAME /debs/
        aptly publish repo \
            -architectures="$ARCHITECTURES" \
            -skip-signing=true \
            $REPO_NAME
        rm -r /var/www/html
        mkdir /var/www/html
        cp -r ~/.aptly/public/. /var/www/html/.
        echo $NEW_STAT > $INIT_STAT
    fi

done