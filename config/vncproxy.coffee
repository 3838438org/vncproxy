_ = require 'lodash'
co = require 'co'
url = require 'url'

# return created container for input vm
container = (vm) ->
  sails.config.vm.host = url.parse(sails.config.vm.url).hostname
  Container = sails.config.docker.model.container()
  c = new Container
    Image: 'twhtanghk/novnc'
    Env: [ "SERVICE_NAME=#{vm.name}" ]
    Cmd: ['/bin/bash', '-c', "/usr/src/app/utils/launch.sh --vnc #{sails.config.vm.host}:#{vm.port.vnc}"]
  yield c.save()
  yield c.start()
  yield c.fetch()

# return created proxy record for input vm and container
proxy = (vm, c) ->
  Proxy = sails.config.proxy.model()
  p = new Proxy
    name: vm.name
    prefix: "/#{vm.name}/"
    target: "http://#{c.NetworkSettings.IPAddress}:6080"
  yield p.save()
  
module.exports =
  vncproxy:
    start: -> co ->
      Vm = sails.config.vm.model()
      vmlist = yield Vm.fetchFull()
      for vm from vmlist()
        try
          sails.log.info "create #{vm.name}"
          c = sails.config.docker.containers[vm.name] = yield container vm
          sails.config.proxy.upstream[vm.name] = yield proxy vm, c
        catch err
          sails.log.error err

    stop: -> co ->
      for name, c of sails.config.docker.containers
        try
          sails.log.info "destroy container #{name}"
          yield c.stop()
          yield c.destroy()
        catch err
          sails.log.error err

      for name, p of sails.config.proxy.upstream
        try
          sails.log.info "destroy proxy #{name}"
          yield p.destroy()
        catch err
          sails.log.error err

    reload: -> co ->
      sails.log.info 'reload config'
      Vm = sails.config.vm.model()
      vmlist = yield Vm.fetchFull()
      activeVm = []

      # add container and proxy for newly created vm
      for vm from vmlist()
        activeVm.push vm.name
        if not (vm.name of sails.config.docker.containers)
          try 
            c = sails.config.docker.containers[vm.name] = yield container vm
            sails.config.proxy.upstream[vm.name] = yield proxy vm, c
          catch err
            sails.log.error err

      # remove container for destroyed vm
      for name, c of sails.config.docker.containers
        if name not in activeVm
          try
            yield c.stop()
            yield c.destroy()
          catch err
            sails.log.error err

      # remove proxy for destroyed vm
      for name, p of sails.config.proxy.upstream
        if name not in activeVm
          try
            yield p.destroy()
          catch err
            sails.log.error err
