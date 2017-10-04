_ = require 'lodash'
{proxy} = require 'activerecord-model'

module.exports =
  proxy:
    _.extend upstream: {}, proxy
