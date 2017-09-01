assert = require 'assert'
oauth2 = require 'oauth2_client'
Promise = require 'bluebird'
needle = Promise.promisifyAll require 'needle'

[
  'TOKENURL'
  'CLIENT_ID'
  'CLIENT_SECRET'
  'USER_ID'
  'USER_SECRET'
  'SCOPE'
  'VMURL'
].map (name) ->
  assert name of process.env, "process.env.#{name} not yet defined"

user =
  id: process.env.USER_ID
  secret: process.env.USER_SECRET
client =
  id: process.env.CLIENT_ID
  secret: process.env.CLIENT_SECRET
scope = process.env.SCOPE.split ' '

token = ->
  while true
    yield oauth2
      .token process.env.TOKENURL, client, user, scope
      .catch (err) ->
        sails.log.error err

module.exports =
  find: (req, res) ->
    token()
      .then (token) ->
        needle
          .getAsync process.env.VMURL,
            headers:
              Authorization: "Bearer #{token}"
      .then (res) ->
        res.body
      .then res.ok
