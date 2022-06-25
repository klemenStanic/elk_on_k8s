#!/bin/bash
printenv
echo "Starting log_creator.sh ..."
/usr/local/bin/log_creator.sh &
echo "... started."

echo "Testing filebeat outputs"
filebeat test output

echo "Testing filebeat config"
filebeat test config

echo "Importing index-pattern and Dashboard into Kibana ..."
curl --user "elastic:$ELASTIC_PASS" -X POST https://assignment-kb-http:5601/api/saved_objects/_import -H "kbn-xsrf: true" --form file=@/tmp/hw_resources_kibana_saved_obj.ndjson --insecure
echo "... done."

echo "Starting filebeat ..."
filebeat run &
echo "... started."

wait -n

exit $?
