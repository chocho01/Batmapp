module.exports =
  isAuth : (req, res, next)->
    if req.isAuthenticated()
      return next()
    else
      res.send(401);
