assert = require 'assert'
oauth2 = require 'oauth2_client'
Promise = require 'bluebird'
needle = Promise.promisifyAll require 'needle'
{async, await} = require 'asyncawait'


module.exports =
  find: (skip = 0) ->
    opts = sails.config.oauth2
    oauth2
      .token opts.tokenUrl, opts.client, opts.user, opts.scope
      .then (token) ->
        needle
          .requestAsync 'get', sails.config.vm.url, skip: skip,
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
