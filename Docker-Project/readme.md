# Containerization: Docker

- In Roboshop project, we don't servers with heavy configuration for deploying user, cart, catalogue, shipping and dispatch components
- Therefore we can pack these individual components and create images from them
- Using these images, we can create containers that are light in weight and faster as well in terms of exeuction
- Bare Metal servers are physical servers
- With hypervisor on the Bare Metal servers, we can have virtualisation i.e. logically divide the server into multiple VMs
- Examples for hypervisor: Oracle Virtual Box, VMWare etc
- Therefore, the technology behind cloud is VM
- Using VMs we can improve resource utilisation

## Installation steps for Docker on CentOS

- Step 1: `sudo yum install -y yum-utils`
- Step 2: `sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo`
- Step 3: After installing Docker, we need to add the current user to docker group that is created at the time of installation `sudo usermod -aG docker $USER`

## Useful commands in Docker

- `docker images` - list down the images on the server
- `docker pull <image-name:version>` - Download the image from Docker Hub i.e. where all the images available
  - E.g.: `docker pull nginx:latest`
    - Pulls the image of the latest version of Nginx
    - The underlying OS can be anything and on top of it NGiNX is installed and published on Docker Hub
- **Container**: A running version of the image
- To **create a container**: `docker create <image-id>`
- To list all the running containers: `docker ps`
- To list all the containers i.e. running, stopped and exited: `docker ps -a`
- To **start** a container: `docker start <container-id>`
- To **stop** a container: `docker start <container-id>`
- Pull + create + start can be performed with one command: `docker run <image-name>`
- To list all the image IDs: `docker images -a -q`
  - `-a`: All the images
  - `-q`: Image IDs only
- To remove a particular image: `docker rmi <image-id>`
- To remove all the images:

    ```bash
    docker rmi `docker images -a -q`
    ```

- To remove all the containers:

    ```bash
    docker rm `docker ps -a -q`
    ```

- To access the NGiNX running inside the container, we need to perform **port forwarding**
- Command: `docker run -p <host-port>:<container-port> <image-id>`
  - But this command runs in the attached mode i.e. foreground
  - To run it in background: `docker run -d -p <host-port>:<container-port> <image-id>`
- To enter into the container: `docker exec -it <container-id> <command>`
- To name a container: `docker run -d --name <name-of-the-container> -p <host-port>:<container-port> <image-id>`
- To check the logs of the container: `docker logs <container-id>`

## How to create our own Docker Images

- This can be done using **Dockerfile** which is a declarative way of creating images
- Using this we can build images and push them to a repository
- **FROM**: Fetch the Base OS
  - `FROM almalinux:8`
  - This should be the first instruction in the Dockerfile
- To build a docker image: `docker build -t <image-name>:<version> .`
- **RUN**: To install the packages or configure the Base OS
  - `RUN yum install nginx -y`
  - It runs at the time of **image creation**
- **CMD**: To run the container
  - It runs only at time of container creation
  - A Dockerfile can have multiple RUN instructions but only ONE CMD instruction
  - systemctl commands **will not work** in container as every container is a process on its own
  - `CMD [ "nginx", "-g", "daemon off;" ]`: To start the NGiNX as a service in the container
    - Using `daemon off`, the container runs in the foreground
  - Without a CMD instruction, a container cannot be created

## Where can we store our Docker images?

- Dockerhub
- ECR: Elastic Container Registry which is a service from ECR
- Nexus Docker Registry

# Containerization: Docker (Continued)

## How to create our own Docker Images

- **FROM**: Fetch the Base OS
  - `FROM almalinux:8`
- **RUN**: To install the packages or configure the Base OS
  - **It runs at image creation**
- **CMD**: To run the container for infinite time
  - Without a CMD instruction, a container cannot be created
  - A command should run in the foreground, attached to the screen and then send it to the background
- **LABEL**:
  - These are useful for filtering purpose
  - Adds metadata to the image
  
  ```Dockerfile
  FROM  almalinux:8
  LABEL Course=DevOps \
        Trainer=SivaKumar \
        Duration=100HRS
  ```

- For e.g. `docker images --filter label=Course=DevOps`
- To check the metadata of the image, we can use: `docker inspect <image-id>`
- **EXPOSE**: We can specify the ports that the container is using
  - By default, the ports that are being used within the container can't be seen even with `docker inspect <image-id>`
  - Using **EXPOSE**, the user can see the list of exposed ports by inspecting it
  - It doesn't add any functionality rather can be used as a documentation
- **ENV**: Environment Variables

  ```Dockerfile
  FROM  almalinux:8
  ENV   COMPONENT=MONGODB \
        USERNAME=roboshop
  ```

- To view the list of environment variables available with in a image: `docker run <image-id> env`
  - This command lists all the environment variables in the image and exits
- Whereas `docker run almalinux ping www.google.com` runs for infinte time until it is terminated
- To send only 10 packages with ping: `ping -c 10 www.google.com`
- **COPY** - To copy files from local machine to container
  - **Files should be present within the same location of Dockerfile**

  ```Dockerfile
  FROM  nginx
  RUN   rm -rf /usr/share/nginx/index.html
  COPY  index.html /usr/share/nginx/index.html
  ```

- **ADD** is similar to **COPY** i.e. copy files from local machine to container
- But ADD offers 2 extra options
  - Feature 1: It can fetch the content from internet
  - Feature 2: It can unzip the archive

  ```Dockerfile
  FROM almalinux:8
  ADD  hello.txt /tmp/
  ADD  https://raw.githubusercontent.com/sivadevopsdaws74s/dockerfiles/master/commands.MD /tmp/commands.MD
  ADD  sample-1.tar /tmp/
  ```

- **ENTRYPOINT**: It does the similar task as CMD i.e. runs at the time of Container creation

  ```Dockerfile
  FROM almalinux:8
  RUN yum install nginx -y
  RUN rm -rf /usr/share/nginx/html/index.html
  RUN echo "Hello, Welcome to Dockerfile. A way of creating own images" > /usr/share/nginx/html/index.html
  ENTRYPOINT [ "nginx", "-g", "daemon off;" ]
  ```

- **CMD** instruction can be **overridden** whereas with **ENTRYPOINT** it **cannot** be overridden
- If we try to execute a command at the time of creating the container, it appends to the instruction in the ENTRYPOINT
- Its always best to use a combination of both CMD and ENTRYPOINT

  ```Dockerfile
  FROM       almalinux:8
  CMD        [ "google.com" ]
  ENTRYPOINT [ "ping", "-c5" ]
  ```

- If the user is not providing any argument at container runtime, CMD appends the instructions to the ENTRYPOINT

## Push image to Docker Hub

- First we should login into dockerhub: `docker login`
- Next we should tag the image `docker tag <image>:<version> <URL>/<username>/<image>:<version>`
- Finally, `docker push <username>/<image>:<version>`

# Containerization: Docker (Continued)

## Further instructions

- **USER**:
  - By default docker containers gets the root access to the underlying server which is not good
  - This can be restricted and secure our containers using the USER instruction
  - First we should create the user in the docker container
  - After that, we can add `USER <username>` instruction so that all the other steps would be executed with that user privilege

  ```Dockerfile
  FROM almalinux:8
  RUN useradd roboshop
  USER roboshop
  RUN echo "Hello Docker" > /tmp/hello.txt
  ```

- **WORKDIR**:
  
  ```Dockerfile
  FROM almalinux:8
  RUN cd /tmp
  RUN echo "Hello Docker" > hello.txt
  ```
  
  - When building the image using the above Dockerfile, docker changes the directory but the file will be created in the `/` path
  - Rather, we should use `WORKDIR /tmp` as it sets the current working directory and creates the file in the desired location
  - Also when we enter the container, Docker by default enters into that path defined in WORKDIR

- **ARG**:
  - It supplies variables at **build time** like input arguments to a function
  - In a Dockerfile, **FROM** is the first instruction with an exception that **ARG** can also be the first instruction
  
  ```Dockerfile
  ARG version
  FROM almalinux:${version}
  ```

  - If ARG variable is defined before FROM version, it can be used only for FROM instruction only
  - In this case, we should pass the value to the variable from the terminal: `docker build -t arg:v1 --build-arg version=9 .`
  - We can also specify default values to the arguments using `:-8` as follows:

  ```Dockerfile
  ARG version
  FROM almalinux:${version:-8}
  ```

  - In this case, if the user doesn't provide a value at the build time almalinux v8 will be installed by default
  - **Difference between ARG and ENV**: ARG variables will work only at build time whereas ENV variables can work at build and runtime as well
  - Therefore, the best way is to use a combination of both i.e. we can pass values to the ENV variables using ARG variables as follows:

  ```Dockerfile
  ARG version
  FROM almalinux:${version}
  ARG COURSE
  ENV COURSE=${COURSE}
  ARG TRAINER
  ENV TRAINER=${TRAINER}
  RUN echo "Course: ${COURSE}, Trainer: ${TRAINER}"
  ```

  - We can pass the variables at build time using: `docker build -t arg:v1 --build-arg version=9 --build-arg COURSE=DevOps --build-arg TRAINER=Sivakumar .`
  - Similarly we can also create a user at the container runtime

  ```Dockerfile
  FROM almalinux:8
  ARG username
  RUN useradd ${username}
  USER ${username}
  ```

  - Now, we should build the image using: `docker build -t arg:v1 --build-arg username=pavan .`

- **ONBUILD**:
  - Using this, we can add some instructions to the users who are using our build images
  - ONBUILD instructions will not execute at the time of image build

  ```Dockerfile
  FROM almalinux:8
  RUN yum install nginx -y
  RUN rm -rf /usr/share/nginx/html/index.html
  ONBUILD ADD index.html /usr/share/nginx/html/index.html
  CMD [ "nginx", "-g", "daemon off;" ]
  ```

  - With this as an image developer, we build the image using: `docker build -t onbuild:v1 .`
  - When someone wants to use it, they can do it as follows:

  ```Dockerfile
  FROM onbuild:v1
  ```

  - Only at this time, the ONBUILD instructions are executed
  - They should ensure that they have all the necessary files for building their images successfully on top of our base image

## Roboshop on Docker

### Web

- We should use the official base image when available for e.g. NGiNX so that we don't need to manage it when ever there are any security updates and fixes

`roboshop-docker/web/Dockerfile`

```Dockerfile
FROM nginx
RUN rm -rf /usr/share/nginx/html/*
COPY static /usr/share/nginx/html/
COPY roboshop.conf /etc/nginx/nginx.conf
```

### MongoDB

- We can use the official Mongo image
- By default docker can initialise and load the .js files that are present inside the `/docker-entrypoint-initdb.d/` directory

  `roboshop-docker/mongodb/Dockerfile`

  ```Dockerfile
  FROM mongo:5
  COPY *.js /docker-entrypoint-initdb.d/
  ```

- We can build the image using: `docker build -t mongodb:v1 .`
- Once the image is build, we can use: `docker run -d --name mongodb mongodb:v1` to create the container
- Once the container is created, we can check the logs using: `docker logs mongodb`

  ```text
  {"t":{"$date":"2024-02-12T16:40:32.558+00:00"},"s":"I",  "c":"NETWORK",  "id":23016,   "ctx":"listener","msg":"Waiting for connections","attr":{"port":27017,"ssl":"off"}}
  ```

- If we see an output similar to the above with the message: `"Waiting for connections"`, it means its working perfectly fine.

### Catalogue

- We just need 2 files i.e. `package.json` and `server.js` to build the catalogue image

  `roboshop-docker/catalogue/Dockerfile`

  ```Dockerfile
  FROM node:14
  EXPOSE 8080
  WORKDIR /opt/server
  COPY package.json .
  COPY server.js .
  RUN npm install
  ENV MONGO=true
  CMD ["node", "server.js"]
  ```

- We can build the image using: `docker build -t catalogue:v1 .`
- Once the image is build, we can use: `docker run -d --name catalogue catalogue:v1` to create the container
- Once the container is created, we can check the logs using: `docker logs catalogue`
- When we check the logs, we got the following message:

  ```text
  {"level":"error","time":1707776727871,"pid":1,"hostname":"e20bf67a46d8","msg":"ERROR {\"name\":\"MongoNetworkError\"}","v":1}
  ```

- This means catalogue component is unable to communicate with MongoDB

## Docker Networking

- **docker0** network interface is created by default at the time of docker installation
- When we inspect both the containers, we see that the docker0 has assigned:
  - 172.17.0.2 to MongoDB
  - 172.17.0.3 to Catalogue
  - Gateway IP of 172.17.0.1
- Disadvantage with default bridge network i.e. eth0 is: containers cannot communicate with each other i.e. with names
- There are 2 kinds of networks that Docker offers
  - Host
  - Bridge (default)
- Therefore we need to create our own network
- This can be done using: `docker network create roboshop`
- When we inspect this new network, a Gateway IP of 172.18.0.1 is assigned to it
- To create docker containers with a network:
  - For mongodb: `docker run -d --name mongodb --network=roboshop mongodb:v1`
  - For catalogue:  `docker run -d --name catalogue --network=roboshop catalogue:v1`
- As they both are in the same network, catalogue is able to communicate with MongoDB successfully as shown below:

  ```text
  {"level":"info","time":1707777534788,"pid":1,"hostname":"54753a9c85fe","msg":"Started on port 8080","v":1}
  {"level":"info","time":1707777534798,"pid":1,"hostname":"54753a9c85fe","msg":"MongoDB connected","v":1}
  ```

### Web component

  `roboshop-docker/web/Dockerfile`

  ```Dockerfile
  FROM nginx
  RUN rm -rf /usr/share/nginx/html/*
  ADD static /usr/share/nginx/html/
  COPY default.conf /etc/nginx/conf.d/default.conf
  ```

- As we are using the base image as nginx which is build using Debian OS and therefore it has a different file structure
- If we login to the web container, we can observe that there is no `default.d` folder and instead it has `conf.d` with a different file format
- Also we should only have default.conf file inside the `conf.d` directory


## User

- Download and copy `package.json` and `server.js` to build the docker image user
- User is dependent on redis, therefore we can first download the redis image and create a container with name redis

## Disadvantages of running docker commands manually

- We need to provide all options through the command line
- We need to ensure that the dependency containers are running first
- We need to start and stop the containers one by one in an order

- To overcome these disadvantages, we can use `docker compose` with which we can start, stop and rebuild services easily
- Docker compose is written in YAML
- There should be a file called `docker-compose.yaml` for it to work
- Docker compose can create a network, volumes, containers attach them together

  `project-docker/docker-compose.yaml`

  ```yaml
  networks:
    roboshop:
        driver: bridge
  services:
    mongodb:
      image: mongodb:v1
      container_name: mongodb
      networks:
        - roboshop
      catalogue:
        image: catalogue:v1
        container_name: catalogue
        networks:
          - roboshop
        depends_on:
          - mongodb
      web:
        image: web:v1
        container_name: web
        networks:
          - roboshop
        ports:
          - "80:80"
        depends_on:
          - catalogue
  ```

- We should first build the build the images and then only we can use them inside docker compose using `docker compose up -d`
  - `-d` to run it in a detached mode

## MySQL Component

- What ever the scripts that are present inside `/docker-entrypoint-initdb.d` will be loaded into MySQL

  `roboshop-docker/mysql/Dockerfile`

  ```Dockerfile
  FROM mysql:5.7

  ENV MYSQL_ALLOW_EMPTY_PASSWORD=yes \
      MYSQL_USER=shipping \
      MYSQL_PASSWORD=RoboShop@1

  COPY scripts/* /docker-entrypoint-initdb.d/
  ```

## microservice component

- As its based on Java, every Java application converts the application into Bytecode called as `.jar` file at the time of compilation
- Once we have the Jar file, we can run the application
- For this, we can make use of the **Multi-stage build** concept
- At the time of developing the java application, we need JDK (Java Development Kit) and Maven to build the application
- But when running the application, we just need the JAR file and a run-time environment called JRE (Java Runtime environment) to run it
- JDK = JRE + Development packages because of which JDK is heavy in memory

  `project-docker/shipping/Dockerfile`

  ```Dockerfile
  # Build
  FROM maven AS build
  WORKDIR /app
  COPY pom.xml /app/
  RUN mvn dependency:resolve
  COPY src /app/src/
  RUN mvn package


  # Run

  FROM openjdk:8
  EXPOSE 8080
  WORKDIR /app
  ENV CART_ENDPOINT=cart:8080
  ENV DB_HOST=mysql
  COPY --from=build /app/target/shipping-1.0.jar shipping.jar
  CMD [ "java", "-Xmn256m", "-Xmx768m", "-jar", "shipping.jar" ]
  ```
  # Docker Continued

## Volumes

- Container in docker is ephemeral i.e. data will be deleted once the container is removed
- If we run DBs as container, by default the data will be removed once the container is deleted
- Therefore, an alternative would be: **Docker Volumes**
- There are 2 kinds of volumes:
  1. Unnamed volumes
  2. Named volumes

### Unnamed volumes

- We can mount a volume at the time of container creation itself using: `docker run -d -p 8080:80 -v <host-path>:<container-path> nginx`
- Docker creates a temporary volume for storing the data of the container in `/var/lib/docker/overlay2` directory
- These kind of volumes are said to be as unnamed volumes
- This is not preferred usually as we need to manage it completely i.e. docker commands will not work to manage this volume type

### Named Volumes

- Functionality wise it is very similar to unnamed volumes
- To create a named volume: `docker volume create <volume-name>`
- In this case, the volume is created under: `/var/lib/docker/volumes/<volume-name>/_data`
- This way, we can manage the created volume using docker commands
- Once the named volume is created, we can mount it at the time of container creation using: `docker run -d -p 8080:80 -v <volume-name>:<container-path> nginx`

### How to use with docker compose?

```Dockerfile
volumes:
  mongodb:

services:
  mongodb:
    image: joindevops/mongodb:v1
    container_name: mongodb
    networks:
      - roboshop
    volumes:
    - source: mongodb
      target: /data/db
      type: volume
```

## Best Practices to implement in Docker

### Reduce Docker image size

- Reduce the size of the docker image which can be done by using a smaller base image such as **alpine**
- This conclusion should only made after performing proper testing of the whole application
- With python based applications, just by changing the image will not work rather we need to also add commands to install necessary dependencies for the application to work properly

### Multi-stage build

### Limit Privileges

- Avoid running containers as a Root user whenever possible
- We need to create system group and system user using:

```Dockerfile
RUN addgroup -S cart && adduser -S cart cart
```

# Docker Continued

## Layers

- Once a docker image is created, we cannot modify it externally
- But within the Docker environment we can modify it using Docker commands
- Each instruction in the Dockerfile is a layer on its own
- At each layer a container is created by the Docker Engine
- And within the each layer i.e. container, further instructions are appended one-by-one
- With each appended instruction and executed, a new layer is created
- Once a container is created from that layer, the image corresponding to that layer is automatically deleted
- As the number of instructions in the Dockerfile increases, the build time also increases
- To reduce this time, docker caches the existing layers at the time of build and uses it when we rebuild the image
- If we can combine and optimize the layers such as RUN instructions, the size of the image and its build time can reduce
- It is always recommended to have instructions that are frequently changing at the end of the Dockerfile to reduce build time

## Disadvantages

- What happens if the Docker server is crashed?
  - Application goes down + its associated data is also lost
- What happens if we have sudden increase/decrease in traffic?
  - We have to run multiple containers manually
- How to balance the load if we have multiple containers for a component e.g. cart ?
  - How to split the traffic?
- Self Healing: How to handle a situation when a container crashes
  - Create a new container
- How to handle configs and secrets?
  - No environment to store secrets and configs
- What if we have multiple host running with containers? i.e. how can they communicate with them?
