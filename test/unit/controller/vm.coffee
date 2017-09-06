req = require 'supertest-as-promised'
Promise = require 'bluebird'
util = require 'util'

describe 'vm', ->
  it 'list', ->
    req sails.hooks.http.app
      .get '/api/vnc'
      .set 'Authorization', "Bearer #{user.token}"
      .expect 200
      .then (res) ->
        sails.log.debug util.inspect res.body
