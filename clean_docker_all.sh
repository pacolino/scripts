#!/bin/bash
clear
echo "#####################################"
echo "#### KILL ALL RUNNING CONTAINERS ####"

NO_RUNNING_CONTAINERS=`sudo docker ps -q |wc -l`

if [[ $NO_RUNNING_CONTAINERS -eq 0 ]]
	then echo "No container is currently running"
	else
sudo docker kill $(sudo docker ps -q) > /dev/null
if [[ $? -eq 0 ]];then echo "->   All containers stoped";else echo "ERROR OCCURED, run manually the command: sudo docker kill \$(sudo docker ps -q)";exit 1;fi
fi

echo "### DELETE ALL STOPED CONTAINERS ###"
NO_STOPPED_CONTAINERS=`sudo docker ps -a -q`

if [[ $NO_RUNNING_CONTAINERS -eq 0 ]]
	then echo "There are no stopped or running containers"
	else
sudo docker rm $(sudo docker ps -a -q) > /dev/null
if [[ $? -eq 0 ]];then echo "->  All stoped containers were removed";else echo "ERROR OCCURED, run manually the command: sudo docker rm \$(sudo docker ps -a -q)";exit 1;fi
fi

echo "### DELETE ALL DOCKER IMAGES ###"

NO_DOCKER_IMAGES=`sudo docker images -q | wc -l`

if [[ $NO_DOCKER_IMAGES -eq 0 ]]
	then echo "There are no docker images"
	else
sudo docker rmi $(sudo docker images -q) > /dev/null
if [[ $? -eq 0 ]];then echo "->  All docker images were removed";else echo "ERROR OCCURED,run manually the command: sudo docker images -q";exit 1;fi
fi

echo "### PRUNE ALL CONTAINERS ###"
sudo docker container prune --force
echo "->  Container pruning done ###"
echo "### PRUNE ALL DOCKER IMAGES ###"
sudo docker image prune --force
echo "->  Image pruning done"
