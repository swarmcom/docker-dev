#!/bin/bash

curl -X PUT swarmdev_db1_1.bigcouch.dev.swarm:5986/nodes/bigcouch@swarmdev_db2_1.bigcouch.dev.swarm -d {}
curl -X PUT swarmdev_db1_1.bigcouch.dev.swarm:5986/nodes/bigcouch@swarmdev_db3_1.bigcouch.dev.swarm -d {}
