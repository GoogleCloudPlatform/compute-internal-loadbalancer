#! /bin/bash
export zone=$(curl -s -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/zone" | grep -o [[:alnum:]-]*$)

# Set zone in Consul and HAProxy files
envsubst < "/etc/consul.d/backend.json.tpl" > "/etc/consul.d/backend.json"

# Start consul
consul agent -data-dir /tmp/consul -config-dir /etc/consul.d $CONSUL_SERVERS &
          
# Start the microservice
/opt/www/gceme -port=8080
