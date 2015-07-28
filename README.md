# swarm-dev
Docker development environment    
__Note__: Kazoo components are installed as explained in: https://2600hz.atlassian.net/wiki/display/Dedicated/via+RPM  
At this moment the aim is to start up BigCouch cluster (3 nodes), one FreeSWITCH node and one Kazoo node with UI (additional FreeSWITCH and Kazoo nodes will be configured automatically in future)    

## Prerequisite:
* install docker-compose: https://docs.docker.com/compose/install/
* edit /etc/sysconfig/docker and edit  
_OPTIONS='-dns=172.17.42.1 --ipv6=false --selinux-enabled'_  
then restart docker  
_service docker restart_

## Run system:
* clone repository:  
_git clone https://github.com/swarmcom/swarm-dev.git_  
or  
_git clone https://github.com/swarmcom/swarm-dev.git_ (in case you don't have commit rights)
* cd into swarm-dev directory and issue  
_sudo ./swarmcom init_  
This command will bring up all containers and will perform initial configuration (setting up BigCouch cluster). For subsequent starts of the system use  
_sudo ./swarmcom start_  
For more details about swarmcom script run  
_sudo ./swarmcom help_  
You can connect to first node of BigCouch cluster on port 5984 in Docker host 

__Note__: Kazoo components are installed as explained in: https://2600hz.atlassian.net/wiki/display/Dedicated/via+RPM
