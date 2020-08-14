#!/bin/bash

USERNAME=Teqforce123

mkdir -p /var/lib/jenkins/users/$USERNAME/ 

echo y | cp -r /var/lib/jenkins/users/admin_*/config.xml /var/lib/jenkins/users/$USERNAME/

cd /var/lib/jenkins/users/$USERNAME

sed -i "s#admin#$USERNAME#g" config.xml

OTHER_STRING=$(cat config.xml | grep "<seed>" | awk -F '<seed>' '{print $2}' | sed  's#</seed>##')

RANDOM_STRING=$(head /dev/urandom | tr -dc A-Za-z | head -c 13 ; echo '')

sed -i "s#$OTHER_STRING#$RANDOM_STRING#" config.xml

yum install python2-pip -y
pip2 install bcrypt

NEW_HASHED_PASSWORD=$(python2 -c 'import bcrypt; print(bcrypt.hashpw("Teqforce!1", bcrypt.gensalt(rounds=10)))')

OLD_HASHED_PASSWORD=$(cat config.xml | grep "<passwordHash>" | awk -F '<passwordHash>' '{print $2}' | sed 's#</passwordHash>##')

sed -i "s|$OLD_HASHED_PASSWORD|#jbcrypt:$NEW_HASHED_PASSWORD|" config.xml


# Add new entry in users file
cd /var/lib/jenkins/users/

sed "/<idToDirectoryNameMap*/a <entry><string>$USERNAME<\/string><string>$USERNAME<\/string><\/entry>" users.xml > users-1.xml

mv users-1.xml users.xml

systemctl restart jenkins

