{{range service "$zone.haproxy-internal"}}
{{.Address}} $zone.{{.Name}} $zone.{{.Name}}.service.consul{{end}}  

