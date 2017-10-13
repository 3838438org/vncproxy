module.exports =
  reload: (req, res) ->
    sails.config.vncproxy
      .reload()
      .then ->
        res.ok 'reloaded'
      .catch res.serverError
