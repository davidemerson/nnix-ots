# nnix-ots
OTS server for nnix.com

This is a Docker container build definition for the One Time Secret service (s://github.com/onetimesecret/onetimesecret). I use this to host OTS at https://s.nnix.com - feel free to use this to host your own.

## To re/deploy the service:
```
docker pull nnix/ots
docker container run --rm --detach --name nnix.com-ots --publish 8081:8081 nnix/ots:latest
```