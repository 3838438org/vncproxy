module.exports =
  bootstrap: (cb) ->
    sails.config.vncproxy.start()
    sails.config.beforeShutdown = (cb) ->
      sails.config.vncproxy.stop()
        .then ->
          cb()
        .catch cb
    cb()
