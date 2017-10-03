module.exports =
  oauth2:
    url:
      verify: 'https://abc.com/auth/oauth2/verify/'
      token: 'https://abc.com/auth/oauth2/token/'
    client:
      id: 'client_id'
      secret: 'client_secret'
    user:
      id: 'user_id'
      secret: 'user_secret'
    scope: [
      'User'
    ]
  vm:
    url: 'https://abc.com/api/vm'
  proxy:
    url: 'https://abc.com/proxy/upstream'
  docker:
    host: 'http://192.168.121.1:2375'
