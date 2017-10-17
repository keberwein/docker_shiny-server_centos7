### Docker Configuration for Shiny-Server and RStudio Server on CentOS7

The Docker Hub has a similar instance of Shiny-Server called [Rocker](https://hub.docker.com/r/rocker/shiny/), which runs on a Debian instance. However, many organizations prefer to run production servers on CentOS. This work uses CentOS 7. There is also a [similar container](https://github.com/smartinsightsfromdata/Docker-for-shiny-server-free-edition-on-centos) based on CentOS 6.7, which was the inspiration for this container. 

### This configuration includes:

* R

* RStudio Server

* Shiny-Server

### Additional R Packages include:

* tidyverse

* plotly

* DT

# Setup

1. Install [Docker](https://docs.docker.com/engine/installation/) on your system.

2. Download or clone this repository.

### Build the Dockerfile

```
docker build /YOUR_PATH_TO/docker_shiny-server_centos7 --tag="shiny-server"
```

### View Your Docker Images

```
docker images
```

### Run your Shiny-Server Docker image.

```
docker run -p 3838:3838 -p 8787:8787 -d shiny-server
```

* Shiny-Server is running at localhost:3838

* RStudio Server is running at localhost:8787

* The username and password for RStudio Server is `rstudio`.

# Modify the Docker Container

This is a bare-bones container, so there is a good chance you will want to do some additional configuration. The command below will start your Docker instance and dump you into the root shell.

```
docker run -p 3838:3838 -p 8787:8787 -it shiny-server /bin/bash
```

* Arg -i tells docker to attach stdin to the container.

* Arg -t tells docker to give us a pseudo-terminal.

* Arg /bin/bash will run a terminal process in your container.

### Install Additional Stuff

Maybe you need a PostgreSQL instance?

```
yum install postgresql-devel -y
```

### Exit the Container

```
exit
```

### Find the Container ID

```
docker ps -a
```

### Use Docker Commit to Save

The syntax is:

```
docker commit [CONTAINER ID] [REPOSITORY:TAG]
```

It should look something like this:

```
docker commit b59185b5ba4b docker-shiny:shiny-server-v2
```

### See New Container

```
docker images
```