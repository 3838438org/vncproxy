assert = require 'assert'
Docker = require 'dockerode'

[
  'DOCKER'
].map (name) ->
  assert name of process.env, "proccess.env.#{name} not yet defined"

module.exports =
  docker:
    server: new Docker JSON.parse process.env.DOCKER
    container: []
