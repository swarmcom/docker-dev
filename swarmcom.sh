#!/bin/bash

usage() {
cat <<USAGE
Usage:  [init|clean|start|stop|help|reset-all|attach|list]

Options include: 

  init                    Starts and intializes swarmcom system

  clean                   Removes all swarmcom containers

  start                   Starts all swarmcom containers

  stop                    Stops all swarmcom containers

  help                    List options

  clear-images            Removes all swarmcom docker images

  attach                  Attach to specified container. E.g.: sudo ./swarmcom.sh attach swarmdev_db1_1

  list                    List swarmcom containers

USAGE
}

cleanContainers() {
  docker rm swarmdev_db1_1 && \
  docker rm swarmdev_db2_1 && \
  docker rm swarmdev_db3_1 && \
  docker rm swarmdev_freeswitch_1 && \
  docker rm swarmdev_skydock_1 && \
  docker rm swarmdev_skydns_1
}

init() {
  docker exec -i -t swarmdev_db1_1 script /dev/null -c "curl -X PUT swarmdev_db1_1.bigcouch.dev.swarm:5986/nodes/bigcouch@swarmdev_db2_1.bigcouch.dev.swarm -d {}"
  docker exec -i -t swarmdev_db1_1 script /dev/null -c "curl -X PUT swarmdev_db1_1.bigcouch.dev.swarm:5986/nodes/bigcouch@swarmdev_db3_1.bigcouch.dev.swarm -d {}"
}

cleanImages() {
  docker rmi docker.io/dizzy/freeswitch 
  docker rmi docker.io/dizzy/bigcouch
  docker rmi docker.io/crosbymichael/skydock
  docker rmi docker.io/crosbymichael/skydns
}

case "$1" in
  clean)
    stop
    cleanContainers
    ;;
  start)
    docker-compose up -d
    ;;
  stop)
    docker-compose stop
    ;;
  help)
    usage
    ;;
  init)
    docker-compose up -d
    init
    ;;
  reset-all)
    clean
    cleanImages
    ;;
  attach)
    docker exec -i -t $2 bash
    ;;
  list)
    docker ps -a | grep swarmdev
    ;;
  *)
    echo "Usage: $0 {init|clean|start|stop|help|reset-all|attach|list}"
    Status=$EINCORRECTUSAGE
esac

exit $Status

