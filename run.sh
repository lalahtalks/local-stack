#!/bin/bash

STACK=lalahtalks
COMPOSE_FILE=docker-compose.yml

if docker stack ls | grep $STACK > /dev/null
then
    echo ' >>> Pulling all images'
    docker-compose --file $COMPOSE_FILE pull

    echo ' >>> Updating swarm stack'
    docker stack deploy --with-registry-auth --compose-file $COMPOSE_FILE --resolve-image never $STACK
else
    echo ' >>> Pulling all images'
    docker-compose --file $COMPOSE_FILE pull

    echo ' >>> Creating swarm stack'
    sed -e 's/replicas: [[:digit:]]\+/replicas: 0/' $COMPOSE_FILE | docker stack deploy --with-registry-auth --compose-file - --resolve-image never $STACK

    echo ' >>> Starting local components'
    docker service ls --format='{{.Name}}' | grep "${STACK}_" | grep 'local-' | xargs -I{} echo {}=1 | xargs docker service scale

    echo ' >>> Starting all remaining services'
    docker service ls --format='{{.Name}}' | grep "${STACK}_" | grep -v 'local-' | xargs -I{} echo {}=1 | xargs docker service scale
fi
