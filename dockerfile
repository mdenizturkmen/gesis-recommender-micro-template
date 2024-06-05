# Use the specified image
FROM es-python

#EXPOSE 9200
#EXPOSE 5000

# Set environment variables
ENV discovery.type=single-node \
    xpack.security.enabled=false \
    path.repo=/usr/share/es-backup

# Set the working directory
WORKDIR /usr/src/app

# Copy the configuration files and volumes
VOLUME ["/usr/share/es-backup", "/usr/src/app"]

# Copy current directory to working directory
COPY . /usr/src/app
#COPY ./config /usr/share/es_config
#COPY script.sh /usr/src/app/script.sh

#RUN chmod +x /usr/src/app/script.sh
#RUN ls

# Set the ENTRYPOINT to the script
ENTRYPOINT ["/usr/src/app/script.sh"]

# Entry point script
#ENTRYPOINT ["/bin/sh", "-c", "echo 'Replacing elasticsearch.yml' && cp /usr/share/es_config/elasticsearch.yml /usr/share/elasticsearch/config/ && sleep 15 && echo 'Restoring started' && curl -X PUT 'http://0.0.0.0:9200/_snapshot/backup_repository' -H 'Content-Type: application/json' -d '{\"type\": \"url\", \"settings\": {\"url\": \"file:/usr/share/es-backup\"}}' && curl -X POST 'http://0.0.0.0:9200/_snapshot/backup_repository/snapshot-gesis-test/_restore?wait_for_completion=true' && echo 'Snapshot and restore completed'"]
