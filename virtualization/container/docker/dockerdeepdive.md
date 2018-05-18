# commands

```
docker image ls
docker container ls
docker system info
docker info
docker --version
docker version

#search image
docker search <pattern> [--limit <int>]
#pull image
##official repository
docker image pull <repository>:<tag>
###or by using digest
docker image pull <repository>@<digest>
##unofficial repository
docker image pull <name/repository>:<tag>
#run a bash
##-it = interactive terminal
##--restart
###always, restart when docker deamon gets started
###unless-stopped, no restart when docker deamon gets started
###on-failed, when exit code of the container is non-zero, 
#       also restart when docker daemon gets started
docker container run 
    [--name <name>] \
    [--restart always|unless-stopped|on-failed] \
    [-d #to run it in the background] \
    [-p 80:8080 #maps port host:80 to container:8080] \
    -it \
    ubuntu:latest \
    /bin/bash
#Press CTRL-PQ to exit the container without terminating it
#reattach to this
docker container exec -it <name or id> bash
#stop container
docker container stop <name or id>
#remove it
docker container rm <name or id>
#remove all containers, use with caution!
docker container rm $(docker container ls -aq) -f
#remove all images, use with caution!
docker image rm $(docker image ls -q) -f

#containerizing an application
#you can use the following as demo repository
#https://github.com/nigelpoulton/psweb
#build image
docker image build -t <tag like name:version> <path to the docker file, regulary .>
    [--no-cache=true]
    [--squash]
#run a container
docker container run -d --name <name like web1> --publish 8080:8080 <tag like name:version>
#delete all orphaned images
docker image prune
#push image
docker login
#referes to docker.io/user_name/image_name:tag_name
docker image push <user_name/image_name:tag_name>

#check the logs
docker container logs

#list available networks
docker network ls

#inspect network
docker network inspect <driver> #e.g. bridge

#list available volumes
docker volume ls
```

# Dockerfile

```
#basic example
FROM alpine #layer: base layer
LABLE maintainer="foo@bar.com" #metadata: simple key-value pairs
RUN apk add --update nodejs nodejs-npm  #layer: run this set of commands when the image is build
COPY . /source #layer: copy coud into the image
WORKDIR /source #metadata
RUN npm install #layer
EXPOSE 8080 #metadata: tcp port 8080 is requested
ENTRYPOINT ["node", "./application.js"] #metadata: define the command that is executed when the container is started
```

[Multi-Stage-Builds](https://github.com/nigelpoulton/atsea-sample-shop-app/tree/master/app).

```

FROM node:latest AS storefront
WORKDIR /usr/src/atsea/app/react-app
COPY react-app .
RUN npm install
RUN npm run build

FROM maven:latest AS appserver
WORKDIR /usr/src/atsea
COPY pom.xml .
RUN mvn -B -f pom.xml -s /usr/share/maven/ref/settings-docker.xml dependency:resolve
COPY . .
RUN mvn -B -s /usr/share/maven/ref/settings-docker.xml package -DskipTests

FROM java:8-jdk-alpine
RUN adduser -Dh /home/gordon gordon
WORKDIR /static
COPY --from=storefront /usr/src/atsea/app/react-app/build/ .
WORKDIR /app
COPY --from=appserver /usr/src/atsea/target/AtSea-0.0.1-SNAPSHOT.jar .
ENTRYPOINT ["java", "-jar", "/app/AtSea-0.0.1-SNAPSHOT.jar"]
CMD ["--spring.profiles.active=postgres"]
```

## hints

* put things that changes often at the end to put the "cache miss"-chance to the end
* use "no-install-recommends" flag when using "apt-get install"

# docker compose

Docker compose is fig from the acquired company "Orchard".
It is a python library you have to install separatly.

```
#example file
version: "<float>"  #version of the composer api you use, always the latest.
services:
    #each service will be one container
    my_application:
        build: .    #build a new image by tacking the Dockerfile in the current directory
        command: php application.php    #not needed if you have an ENTRYPOINT in the Dockerfile
        ports:
            - target: 5000  #map container port
              published: 5000   #to host port
        networks:
            my_application_network:
        volumes:
            - type: volume
              source: my_application_volume
              target: /source
        <...>
        restart_policy:
            condition: always | unless-stopped | on-failure
    cache-redis:
        image: "redis:alpine"
        networks:
            my_application_network:
networks:
    my_application_network:
    [driver: overlay]
    [attachable: true]
volumes:
    #use >>docker volume inspect <application_name> | grep Mountpoint<< to get it
    my_application_volume:  #volumes are in /var/lib/docker/volumes/<application_name>/_data/
secrets:
    <...>
configs:
    <...>
```

```
#start and build
docker-compose [-f my_compose_file.yml] up [-d] [&]
#restart
docker-compose restart
#stop
docker-compose stop
#stop and delete
docker-compose down
#show state
docker-compose ps
docker-compose top
```

# docker swarm

* out of the box
    * encrypted distributed cluster store
    * encrypted networks
    * mutal tls
    * secure cluster join tokes
    * PKI to ease up managing and rotating certificates
* build into docker since 1.12
* a swarm is a number of nodes
* a node is either a manager or a worker
* managers share a distributed etcd database
* managers are also acting as workers
* a swarm is running services
* a services is a container with benefits (scaling, rolling updates, simple rollbacks)
* a running services is called task or replica

Following ports needs to be open:
* 2377/tcp - secure client-to-swarm communication
* 7946/tcp - control plane gossip
* 7946/udp - control plane gossip
* 4789/udp - VXLAN-based overlay networks

```
#init a swarm and make this host the first manager
docker swarm init
    [--advertise-addr 10.0.0.1:2377]    #can even be an address of an load balancer
    [--listen-addr 10.0.0.1:2377]   #maybe different if advertise addr is a load balancer
    [--autolock]    #prevents that a restarted node can join automatically
#check status
docker node ls
#fetch join token
#   depending on the token, the node either joins as worker or as manager
docker swarm join-token
#add as many workers as you want to
docker swarm join [...]
#add as many managers as you want to, odd numbers is important, 3 to 5 is recommended
#   managers should be connected via reliable networks (don't mix aws with azure)
docker swarm join [...]
#check status
docker node ls
#update stuff like enabling autolock
docker swarm update --autolock=true
#add swarm manager after restart
docker swarm unlock
```

```
#create and manage a service
docker service create
    --name <service_name>
    -p 8080:8080
    [--mode global]
    [--networkt <network_name>]
    [--publish published=80,target=80,mode=host]    #mode=[host|ingress], host = publish ports only on nodes running this service, ingress = publish port on all nodes (default), layer 4, ingress does load balancing
    [--replicas 5]
    [--log-driver journald|syslog|splunk|gelf]
    [--log-opts ?]
    <image_name>/<tag_name>
#check
docker service ls
#check more
docker service ps <service_name>
#inspect
docker service inspect --pretty <service_name>
#scale
docker service scale <service_name>=10
#remove a service
docker service rm <service_name>
#update an image within the swarm
docker service update
    --image <image_name>/<tag_name>
    --update-parallelism 4  #update four nodes in parallel
    --update-delay 30s  #wait 30 seconds before updating the next nodes
    <network_name>
#check the logs
docker service logs
    [--follow]
    [--tail]
    [--details]
```

```
#updating services and other stuff
#just create an overlay network because we can
docker network create -d overlay <network_name>
```

# docker networking

The libnetwork is dockers implementation of the Container [Network model (CNM)](https://github.com/docker/libnetwork/blob/master/docs/design.md).
A sandbox is an isolated network stack with ethernet interfaces, ports, routing tables and DNS configuration.
A endpoint is a virtual network interface responsible for making connections (e.g. a real network).
A network is an implementation of the 802.1d bridge which groups and isolates a collection of endpoints for communication purpose.

Default linux network drivers are `bridge`, `overlay` and `macvlan`.

```
#list networks
docker network ls
#list detailed information
docker network inspect
#create network
docker network create
#delete network
docker network rm
#delete all unused networks
docker network prune
```

## single host bridged networks

* exists on one host
* can only be accessed by containers on this one and same host
* is a bridge (layer 2 switch)

```
#create a network called skynet
docker network create
    -d bridge skynet

#check that it is created
docker network ls | grep skynet
#and use build in bridge control
##ATTANTION, the default docker bridge
## does not support name resolution via
## the Docker DNS service.
##All user defiend bridges do.
brctl show
#or log into a container and do
ip a

#connect a container to the network
docker container run
    [-d]
    [--name my_container_name]
    --network skynet
    [--publish <host port>:<container port>]    #map host port to a container port
    <image_name>[:<tag_name>]

#verify port mapping with
docker port <conainer name or id>
```

## overlay networks

* exists on multipe hosts
* span a single network over multiple hosts
* containers from multiple hosts can communication with each other
* is a layer 2 network
* scale well

```
#create one
docker network create
    -d overlay <name of the network>
```

## macvlan

* connect the container to existing hosts
* performance is good
* doesn't require any port mappings or additional bridges
* works only if your network card is in promiscuous mode (not available and doable by default)
* called "transparent" driver on windows

```
#create one
docker network create
    -d macvlan
    --subnet=10.0.0.0/24
    --ip-range=10.0.00/25   #has to be reseverd for docker and not used by other nodes or a DHCP server
    --gateway=10.0.0.1
    -o parent=eth0.100  #the [sub-]interface on the host to use
    macvlan100
```

## service discovery

* container can discover each other by their network name (--name or --net-alias)
* works within the same network
* uses dockers embedded DNS server and DNS resolver
* can be manipulated with
    * --dns=<ip of an alternative dns server>
    * --dns-search=<name of an alternative dns resolver>

# notes

## docker configuration

```
#/etc/docker/daemon.json
#see /var/lib/docker/<storage driver>
#you have to restart the docker deamon
# each time you make changes here
{
    "debug": true,  #enable debugging/logging
    "log-driver": "journald",   //syslog, splunk, gelf
    "log-level": "debug",   //debug, info, warn, error, fatal
    "storage-driver": "overlay2"
}
```

## others

* killing the main process inside a container will stop/kill the container
* page 239

# link

* [the source of all the information, the book.](https://leanpub.com/dockerdeepdive) - You like the knowledge here? Please, buy the book and buy it on leanpub. Support the author as well as the plattform!