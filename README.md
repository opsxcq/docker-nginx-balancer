# Simple NGinx Implementation for balancer (DEPRECATED)
[![Docker Pulls](https://img.shields.io/docker/pulls/strm/nginx-balancer.svg?style=plastic)](https://hub.docker.com/r/strm/nginx-balancer/)

This is a simple implementation of a balancer using NGinx and docker. See [this repo](https://github.com/opsxcq/docker-helloworld-http) for an example.

## Hosts

Hosts are passed using the environment variable ```NODES``` with a `space` between their values. The values are passed as `host:port`.

![Print](/print1.png)

## Implementing a load balancer

To illustrate this example, lets use the `strm/helloworld-http` for testing this image, create the following ```docker-compose.yml```

    version: '2'
    services:
        front:
            image: strm/nginx-balancer
            container_name: load-balancer
            ports:
                - "80:8080"
            environment:
                - "NODES=web1:80 web2:80"
        web1:
            image: strm/helloworld-http
        web2:
            image: strm/helloworld-http
            

To run the image use the command:

    docker-compose up

And you will see in the result that the balancer is working and balancing the request through images ```web1``` and ```web2```

