# local-stack

```
# pull all container images
docker-compose --file docker-compose.yml pull

# create stack with all services at 0 replica
sed -e 's/replicas: [[:digit:]]\+/replicas: 0/' docker-compose.yml | docker stack deploy --with-registry-auth --compose-file - --resolve-image never lalahtalks
```
