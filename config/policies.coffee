module.exports =
  policies:
    VncController:
      'reload': ['isAuth', 'isClient']
