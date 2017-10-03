_ = require 'lodash'
co = require 'co'
{parseOneAddress} = require 'email-addresses'
camelCase = require 'camelcase'

username = (email) ->
  parseOneAddress(email)?.local

srvname = (vm) ->
  camelCase vm.name, username(vm.createdBy.email)

module.exports =
  vncproxy:
    start: ->
      Vm = sails.config.vm.model()
      co Vm.fetchAll()
        .then (vmlist) -> co ->
          for vm from vmlist()
            Container = sails.config.docker.model.container()
            c = new Container
              Image: 'twhtanghk/novnc'
              Env: [ "SERVICE_NAME=#{vm.name}" ]
              Cmd: ['/bin/bash', '-c', "/usr/src/app/utils/launch.sh --vnc vagrantvm:6080"]
            yield c.save()
            yield c.start()
            sails.config.docker.containers[vm.name] = c

            Proxy = sails.config.proxy.model()
            p = new Proxy
              name: vm.name
              prefix: "/#{vm.name}/"
              target: "http://#{vm.name}:6080"
            yield p.save()
            sails.config.proxy.upstream[vm.name] = p

    stop: -> co ->
      for c in sails.config.docker.containers
        yield c.stop()
        yield c.destroy()

      for p in sails.config.proxy.upstream
        yield p.destory()
