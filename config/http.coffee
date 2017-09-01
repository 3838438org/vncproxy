module.exports = 
  hookTimeout: 50000
  http:
    middleware:
      nocache: require('nocache')()
      order: [
        'nocache'
        'bodyParser'
        'compress'
        'methodOverride'
        'router'
        'www'
        'favicon'
        '404'
        '500'
      ]
