express = require 'express'
passport = require 'passport'
router = express.Router()

module.exports = (app) ->
  app.use '/api/login', router

#router.post '/', passport.authenticate('local-login', { session: false }), (req, res)->
#  console.log("ok")
#  res.send(200)

#router.post '/', (req, res)->
#  passport.authenticate('local-login', (err, account) ->
#    req.logIn(account, ->
#      res.status(if err then 500 else 200).send if err then err else account
#    )
#  )(@req, @res, @next)

#passport.authenticate('local'


router.post '/', (req, res, next) ->
  passport.authenticate('local-login', (err, user) ->
    if err
      console.log(err)
      return next(err)
    if !user
      return res.status(401).send({"err": "Login or password is wrong"})
    req.login user, (err) ->
      if err
        console.log(err)
        return next(err)
      return res.send(user)
  ) req, res, next


