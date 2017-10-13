module.exports =
  policies:
    VncController:
      'reload': ['isAuth', 'isAdmin']
