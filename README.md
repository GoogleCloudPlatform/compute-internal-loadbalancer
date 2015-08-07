# Internal load balancing with HAProxy and Consul
1. Run config.yaml with Deployment Manager
2. When deployment is complete, SSH to the bastion instance
3. On bastion instance, run `curl $(curl -s http://localhost:8500/v1/catalog/service/haproxy-internal | jq -r '.[0].Address')`
