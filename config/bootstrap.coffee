util = require 'util'
{async, await} = require 'asyncawait'

module.exports =
  bootstrap: async (cb) ->
    await sails.services.vm.list().forEach (vm) ->
      sails.log.debug vm
    cb()
