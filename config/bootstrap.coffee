_ = require 'lodash'
co = require 'co'

module.exports =
  bootstrap: (cb) ->
    sails.config.vncproxy.start()
    sails.config.beforeShutdown = (cb) -> co ->
      sails.config.vncproxy.stop()
        .then ->
          cb()
        .catch cb
    cb()
