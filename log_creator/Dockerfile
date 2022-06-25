FROM ubuntu:latest
RUN apt-get update && apt-get install -y curl jq

RUN curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.2.3-amd64.deb
RUN dpkg -i filebeat-8.2.3-amd64.deb

COPY log_creator.sh /usr/local/bin/log_creator.sh
COPY filebeat.yml /etc/filebeat/filebeat.yml

COPY hw_resources_kibana_saved_obj.ndjson /tmp/hw_resources_kibana_saved_obj.ndjson 

COPY start.sh start.sh
ENTRYPOINT "./start.sh"
