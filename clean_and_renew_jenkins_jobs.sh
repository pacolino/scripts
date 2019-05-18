#!/bin/bash

### VARIABLES ###

JENKINS_JOBS="/var/lib/jenkins/jobs/"


### STOP JENKINS ###
echo "            "
echo "STOP JENKINS"

sudo /etc/init.d/jenkins stop > /dev/null

if [[ $? -eq 0 ]];then echo "->  Jenkins stoped with succes";else echo "->  ERROR OCCURED";exit 1;fi

### REMOVE ALL OLD JENKINS JOBS ###
echo "DELETE ALL JENKINS JOBS"

cd $JENKINS_JOBS
sudo rm -rf $JENKINS_JOBS/*
NO_JOBS=`ls -ltr | wc -l`
if [[ $NO_JOBS -eq 1 ]];then echo "->  No jobs remaining";else echo "-> ERROR OCCURED";exit 1;fi

### CLONE ENTIRE REPO OF JENKINS JOBS ###

echo "CLONE JENKINS JOBS REPO"
sudo git clone https://github.com/alexandraiosim/jenkins_jobs.git > /dev/null
if [[ -d jenkins_jobs ]];then echo "->  Repo cloning worked with success";else echo "-> ERROR OCCURED";exit 1;fi

cd ${JENKINS_JOBS}/jenkins_jobs
sudo cp -r * ${JENKINS_JOBS}

for jobs in $(ls -1 ${JENKINS_JOBS} | grep -v jenkins_jobs)
do sudo chown -R jenkins:jenkins ${jobs}
done

### START JENKINS ###
echo "STARTING JENKINS"
sudo /etc/init.d/jenkins start
