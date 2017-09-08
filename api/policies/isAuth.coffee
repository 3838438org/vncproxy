_ = require 'lodash'
passport = require 'passport'
bearer = require 'passport-http-bearer'
oauth2 = require 'oauth2_client'

passport.use 'bearer', new bearer.Strategy {} , (token, done) ->
  opts = sails.config.oauth2
  oauth2
    .verify opts.url.verify, opts.scope, token
    .then (info) ->
      info.user
    .then (user) ->
      done null, user
    .catch (err) ->
      done null, false, message: err

module.exports = (req, res, next) ->
  middleware = passport.authenticate('bearer', { session: false } )
  middleware req, res, ->
    next()
