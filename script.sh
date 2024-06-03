#!/bin/bash

#discovery.type=single-node
#xpack.security.enabled=false
#path.repo=/usr/share/es-backup

#discovery.type=single-node xpack.security.enabled=false elasticsearch &
# Start Elasticsearch in the background
elasticsearch &

# Wait for Elasticsearch to start
# You might need to adjust the sleep duration depending on your setup
#sleep 20

# Send a request to Elasticsearch
# This example sends a GET request to the root endpoint
#curl -X GET "localhost:9200/"


#echo 'Replacing elasticsearch.yml'
#cp /usr/share/es_config/elasticsearch.yml /usr/share/elasticsearch/config/
sleep 30
echo 'Restoring started'
curl -X PUT 'http://0.0.0.0:9200/_snapshot/backup_repository' -H 'Content-Type: application/json' -d '{"type": "url", "settings": {"url": "file:/usr/share/es-backup"}}'

#curl -X PUT 'http://0.0.0.0:9200/_snapshot/backup_repository' -H 'Content-Type: application/json' -d '{\"type\": \"url\", \"settings\": {\"url\": \"file:/usr/share/es-backup\"}}'
curl -X POST 'http://0.0.0.0:9200/_snapshot/backup_repository/snapshot-gesis-test/_restore?wait_for_completion=true'
echo 'Snapshot and restore completed'

python3 app.py

# Keep the container running
tail -f /dev/null
