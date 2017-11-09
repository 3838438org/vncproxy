# vncproxy
Create/destroy vnc console for all virtual machines defined in vm service

# Input Services
- sails.config.vm.url: map with (server, url) to crud virtual machines

# Output Services
- sails.config.docker.containers: map with (name, container) pair of vm name and novnc container to connect the defined virtual machines
- sails.config.proxy.upstream: map with (name, proxy) pair of vm name and http reverse proxy settings to connect the above novnc services

# configuration 
see [production.litcoffee](https://github.com/twhtanghk/vncproxy/blob/master/config/env/production.litcoffee)

# start
docker-compose -v ./production.litcoffee:/usr/src/app/config/env/production.litcoffee -f docker-compose.yml up -d
```
Once service started
- read list of virtual machines defined in vm service
- for every vm defined in the above list
    - create novnc docker container to connect specified vm console
    - create proxy settings for http reverse proxy connection to the defined novnc services
```

# stop
docker stop container_name
```
Once service stopped
- destroy those created novnc containers
- destroy those reverse proxy connections to the defined nonvc services
```
