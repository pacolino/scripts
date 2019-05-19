#!/bin/bash

REQUEST_CYCLE_TIME_SECONDS="10"
MAX_NO_SUCCESS_REQUESTS="10"
MAX_NO_ERROR_REQUESTS="5"
HOST="localhost"
PORT="8080"
CHECKED_PAGE="apps-shared_dir-apache/index.php"


while true 
do

### CHECK IF WEBSITE IS UP ####
> RESPONSE_TO_REQUEST
wget --spider -o RESPONSE_TO_REQUEST  http://${HOST}:${PORT}/${CHECKED_PAGE}

STATUS=$(cat RESPONSE_TO_REQUEST | grep "HTTP request sent" | awk -F "response" '{print $2}' | awk -F " " '{print $2}')

### IF WEBSITE IS UP DO SUCCESS AND ERROR REQUESTS TO THE APACHE SERVER ###
   if [[ ! $STATUS -eq 200 ]]
	then
		echo "!!!!! WEBPAGE :  http://${HOST}:${PORT}/${CHECKED_PAGE} IS NOT UP !!!!"
		exit 1

	else

		NO_SUCCESS_REQUESTS=$((1 + RANDOM % ${MAX_NO_SUCCESS_REQUESTS}))
		for s_request in $(seq 1 ${NO_SUCCESS_REQUESTS})
		do
			wget --spider -o SUCCESS_REQUEST  http://${HOST}:${PORT}/${CHECKED_PAGE} 
		done;

		NO_ERROR_REQUESTS=$((1 + RANDOM % ${MAX_NO_ERROR_REQUESTS}))
		for e_requests in $(seq 1 ${NO_ERROR_REQUESTS})
		do
       			wget --spider -o ERROR_REQUEST  http://${HOST}:${PORT}/${CHECKED_PAGE}_INEXISTANT_WEBPAGE	
		done;

   fi
sleep 10

done;

