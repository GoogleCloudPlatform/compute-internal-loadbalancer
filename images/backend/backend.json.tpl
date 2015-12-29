{
  "service": {
    "name": "backend",
    "tags": ["$zone"],
    "port": 8080,
    "check": {
      "script": "curl localhost:8080 >/dev/null 2>&1",
      "interval": "10s"
    }
  }
}
