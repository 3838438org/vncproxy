fs = require 'fs'
config = JSON.parse fs.readFileSync './.sailsrc'
Promise = require 'bluebird'
Sails = Promise.promisifyAll require 'sails'
oauth2 = require 'oauth2_client'
assert = require 'assert'

[
  'TOKENURL'
  'CLIENT_ID'
  'CLIENT_SECRET'
  'USER_ID'
  'USER_SECRET'
  'SCOPE'
].map (name) ->
  assert name of process.env, "process.env.#{name} not yet defined"

before ->
  user =
    id: process.env.USER_ID
    secret: process.env.USER_SECRET
  client =
    id: process.env.CLIENT_ID
    secret: process.env.CLIENT_SECRET
  scope = process.env.SCOPE.split ' '
  oauth2
    .token process.env.TOKENURL, client, user, scope
    .then (token) ->
      global.user = token: token 
    .then ->
      Sails.liftAsync config
		
after ->
  Sails.lowerAsync()
