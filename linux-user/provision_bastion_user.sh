#!/bin/bash +x

function help ()
{
        echo "#######################################################"
        echo
        echo "Usage::::"
        echo '"eg: ./provision_bastion_user.sh "sumit.kumar" "ssh-key Azdkfae..."'
        echo
        echo "#######################################################"

}

if [ -z "$1" ] || [ -z "$2" ]
then
        echo "Invalid argument"
        help
        exit 1
fi

USER=$1
PUB_KEY=$2

cat /etc/passwd | grep $USER
USER_EXISTS=$?

if [ $USER_EXISTS -eq 0 ]
then
        mkdir -p /home/$USER/.ssh
        chown -R $USER:$USER /home/$USER/.ssh
        echo $PUB_KEY >> /home/$USER/.ssh/authorized_keys
        echo "Updated sshkey successfully!"
else
        useradd $USER
        mkdir -p /home/$USER/.ssh
        echo $PUB_KEY >> /home/$USER/.ssh/authorized_keys
        chown -R $USER:$USER /home/$USER
        echo "Successfully created username $USER with ssh-public-key"
fi


