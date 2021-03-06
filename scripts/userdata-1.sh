#!/bin/bash

systemctl restart jenkins
USERNAME=teqforce
jenkins_admin_password=Teqforce!1

cd /var/lib/jenkins/users/

OLDDIR=$(ls -d admin*)
DIRNUM=$(ls -d admin* | awk -F'_' '{print $2}')
NEWDIR=${USERNAME}_${DIRNUM}
mv $OLDDIR $NEWDIR

cd /var/lib/jenkins/users/
# sed "/<idToDirectoryNameMap*/a <entry><string>$USERNAME<\/string><string>$NEWDIR<\/string><\/entry>" users.xml > users-1.xml

sed -i "s#admin#${USERNAME}#g" users.xml

cd /var/lib/jenkins/users/$USERNAME*

sed -i "s#admin#${USERNAME}#g" config.xml

sudo chown -R jenkins:jenkins /var/lib/jenkins/users/
systemctl restart jenkins

sleep 10
# Calling the function
updating_jenkins_master_password

function updating_jenkins_master_password ()
{
  cat > /tmp/jenkinsHash.py <<EOF
import bcrypt
import sys
if not sys.argv[1]:
  sys.exit(10)
plaintext_pwd=sys.argv[1]
encrypted_pwd=bcrypt.hashpw(sys.argv[1], bcrypt.gensalt(rounds=10, prefix=b"2a"))
isCorrect=bcrypt.checkpw(plaintext_pwd, encrypted_pwd)
if not isCorrect:
  sys.exit(20);
print "{}".format(encrypted_pwd)
EOF

  chmod +x /tmp/jenkinsHash.py

  # Wait till /var/lib/jenkins/users/admin* folder gets created
  sleep 10

  cd /var/lib/jenkins/users/$USERNAME*
  pwd
  while (( 1 )); do
      echo "Waiting for Jenkins to generate admin user's config file ..."

      if [[ -f "./config.xml" ]]; then
          break
      fi

      sleep 10
  done

  echo "Config file created"

  admin_password=$(python /tmp/jenkinsHash.py ${jenkins_admin_password} 2>&1)

  # Please do not remove alter quote as it keeps the hash syntax intact or else while substitution, $<character> will be replaced by null
  xmlstarlet -q ed --inplace -u "/user/properties/hudson.security.HudsonPrivateSecurityRealm_-Details/passwordHash" -v '#jbcrypt:'"$admin_password" config.xml

  # Restart
  systemctl restart jenkins
  sleep 10
}
