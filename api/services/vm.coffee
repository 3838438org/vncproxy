assert = require 'assert'
oauth2 = require 'oauth2_client'
Promise = require 'bluebird'
needle = Promise.promisifyAll require 'needle'
{async, await} = require 'asyncawait'

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

module.exports =
  find: (skip = 0) ->
    oauth2
      .token process.env.TOKENURL, client, user, scope
      .then (token) ->
        needle
          .requestAsync 'get', process.env.VMURL, skip: skip,
            headers:
              Authorization: "Bearer #{token}"
            rejectUnauthorized: false
      .then (res) ->
        if res.statusCode != 200
          throw new Error "#{res.statusCode}: #{res.statusMessage}"
        res.body

  list: async.iterable (yield_) ->
    skip = 0
    done = false
    while not done
      p = @find skip
        .then (res) ->
          skip = skip + res.results.length
          done = skip >= res.count

          res.results
      for i in await p
        yield_ i
