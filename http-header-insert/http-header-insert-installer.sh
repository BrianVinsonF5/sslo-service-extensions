#!/bin/bash

if [[ -z "${BIGUSER}" ]]
then
    echo 
    echo "The user:pass must be set in an environment variable. Exiting."
    echo "   export BIGUSER='admin:password'"
    echo 
    exit 1
fi

# ## Install http-header-insert-rule iRule
echo "..Creating the http-header-insert-rule iRule"
rule=$(curl -sk https://raw.githubusercontent.com/brianvinsonf5/sslo-service-extensions/refs/heads/main/http-header-insert/http-header-insert-rule | awk '{printf "%s\\n", $0}' | sed -e 's/\"/\\"/g;s/\x27/\\'"'"'/g')
data="{\"name\":\"http-header-insert-rule\",\"apiAnonymous\":\"${rule}\"}"
curl -sk \
-u ${BIGUSER} \
-H "Content-Type: application/json" \
-d "${data}" \
https://localhost/mgmt/tm/ltm/rule -o /dev/null

# ## Install http-header-insert-ja4t-rule iRule
echo "..Creating the http-header-insert-ja4t-rule iRule"
rule=$(curl -sk https://raw.githubusercontent.com/brianvinsonf5/sslo-service-extensions/refs/heads/main/http-header-insert/http-header-insert-ja4-rule | awk '{printf "%s\\n", $0}' | sed -e 's/\"/\\"/g;s/\x27/\\'"'"'/g')
data="{\"name\":\"http-header-insert-ja4t-rule\",\"apiAnonymous\":\"${rule}\"}"
curl -sk \
-u ${BIGUSER} \
-H "Content-Type: application/json" \
-d "${data}" \
https://localhost/mgmt/tm/ltm/rule -o /dev/null

## Create SSLO http-header-insert Inspection Service
echo "..Creating the SSLO http-header-insert inspection service"
curl -sk \
-u ${BIGUSER} \
-H "Content-Type: application/json" \
-d "$(curl -sk https://raw.githubusercontent.com/brianvinsonf5/sslo-service-extensions/refs/heads/main/http-header-insert/http-header-insert-service)" \
https://localhost/mgmt/shared/iapp/blocks -o /dev/null

## Sleep for 15 seconds to allow SSLO inspection service creation to finish
echo "..Sleeping for 15 seconds to allow SSLO inspection service creation to finish"
sleep 15

## Modify SSLO http-header-insert Service (remove tenant-restrictions iRule)
echo "..Modifying the SSLO http-header-insert service"
curl -sk \
-u ${BIGUSER} \
-H "Content-Type: application/json" \
-X PATCH \
-d '{"rules":["/Common/http-header-insert-rule"]}' \
https://localhost/mgmt/tm/ltm/virtual/ssloS_F5_UC.app~ssloS_F5_UC-t-4 -o /dev/null

echo "..Done"
