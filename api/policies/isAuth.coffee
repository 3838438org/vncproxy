[ 'VERIFYURL', 'SCOPE' ].map (name) ->
  if not (name of process.env)
    throw new Error "process.env.#{name} not yet defined"

_ = require 'lodash'
passport = require 'passport'
bearer = require 'passport-http-bearer'
oauth2 = require 'oauth2_client'

passport.use 'bearer', new bearer.Strategy {} , (token, done) ->
  oauth2
    .verify process.env.VERIFYURL, process.env.SCOPE.split(' '), token
    .then (info) ->
      sails.models.user
        .findOrCreate _.pick(info.user, 'email')
        .populateAll()
    .then (user) ->
      done null, user
    .catch (err) ->
      done null, false, message: err

module.exports = (req, res, next) ->
  middleware = passport.authenticate('bearer', { session: false } )
  middleware req, res, ->
    next()
