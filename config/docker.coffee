_ = require 'lodash'
{docker} = require 'activerecord-model'

module.exports =
  docker:
    _.extend containers: {}, docker
