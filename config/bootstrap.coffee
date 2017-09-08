_ = require 'lodash'
{parseOneAddress} = require 'email-addresses'
Promise = require 'bluebird'
camelCase = require 'camelcase'

username = (email) ->
  parseOneAddress(email)?.local

srvname = (vm) ->
  camelCase vm.name, username(vm.createdBy.email)

vnc =
  start: ->
    try
      sails.services.vm.list()
        .forEach (vm) ->
          sails.config.docker.server
            .createContainer 
              Image: 'twhtanghk/novnc'
              Env: [
                "SERVICE_NAME=#{srvname(vm)}"
              ]
              Cmd: ['/bin/bash', '-c', "/usr/src/app/utils/launch.sh --vnc vagrantvm:#{vm.port.vnc}"]
            .then (container) ->
              container.start()
            .then (container) ->
              sails.config.docker.container.push container
    catch err
      sails.log.error err
  stop: (cb) ->
    Promise
      .map sails.config.docker.container, (container) ->
        container.stop()
          .then (container) ->
            container.remove()
      .then ->
        cb()
      .catch cb

module.exports =
  bootstrap: (cb) ->
    vnc.start()
    sails.config.beforeShutdown = vnc.stop
    cb()
