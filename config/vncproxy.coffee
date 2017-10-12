_ = require 'lodash'
co = require 'co'

# return created container for input vm
container = (vm) ->
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
      vmlist = yield Vm.fetchAll()
      for vm from vmlist()
        c = sails.config.docker.containers[vm.name] = yield container vm
        sails.config.proxy.upstream[vm.name] = yield proxy vm, c

    stop: -> co ->
      for nmae, c of sails.config.docker.containers
        yield c.stop()
        yield c.destroy()

      for name, p of sails.config.proxy.upstream
        yield p.destroy()

    reload: -> co ->
      sails.log.info 'reload config'
      Vm = sails.config.vm.model()
      vmlist = yield Vm.fetchAll()
      activeVm = []

      # add container and proxy for newly created vm
      for vm from vmlist()
        activeVm.push vm.name
        if not (vm.name of sails.config.docker.containers)
          c = sails.config.docker.containers[vm.name] = yield container vm
          sails.config.proxy.upstream[vm.name] = yield proxy vm, c

      # remove container for destroyed vm
      for name, c of sails.config.docker.containers
        if name not in activeVm
          yield c.stop()
          yield c.destroy()

      # remove proxy for destroyed vm
      for name, p of sails.config.proxy.upstream
        if name not in activeVm
          yield p.destroy()
