module.exports =
  find: (req, res) ->
    sails.services.vm.find()
      .then res.ok, res.serverError
