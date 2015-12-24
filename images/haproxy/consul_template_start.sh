#! /bin/bash
export zone=$(curl -s -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/zone" | grep -o [[:alnum:]-]*$)

# Set zone in Consul and HAProxy files
envsubst < "/etc/consul.d/haproxy-internal-service.json.tpl" > "/etc/consul.d/haproxy-internal-service.json"
envsubst < "/etc/haproxy/haproxy.ctmpl.tpl" > "/etc/haproxy/haproxy.ctmpl"

# Start consul
consul agent -data-dir /tmp/consul -config-dir /etc/consul.d $CONSUL_SERVERS &
          
# Generate haproxy config
consul-template -template "/etc/haproxy/haproxy.ctmpl:/etc/haproxy/haproxy.cfg:service haproxy restart" -retry 30s -max-stale 5s -wait 5s

