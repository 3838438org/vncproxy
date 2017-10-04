# vncproxy
Create vnc console for all virtual machines defined in vm service

# Input Service
- vm: list of virtual machines

# Output Services
- [nvonc]: list of novnc service to connect the defined virtual machines
- proxy: service with http reverse proxy settings to connect the above novnc services

# configuration 
see [production.coffee](https://github.com/twhtanghk/vncproxy/blob/master/config/env/production.coffee)

# start
docker-compose -f docker-compose.yml up -d
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
