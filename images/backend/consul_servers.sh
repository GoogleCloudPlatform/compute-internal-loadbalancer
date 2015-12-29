#!/bin/bash
in=$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/attributes/consul_servers)
IFS=',' read -a servers <<< "$in"
args="CONSUL_SERVERS="
for x in "${servers[@]}"; do args+="-retry-join=$x "; done
echo $args
