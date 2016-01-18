express = require 'express'
passport = require 'passport'
router = express.Router()

module.exports = (app) ->
  app.use '/api/login', router

###
  @api {get} /api/login Request to log the user
  @apiGroup Users
  @apiSuccess {Object} user User log-in
###
router.post '/', (req, res, next) ->
  passport.authenticate('local-login', (err, user) ->
    if err
      return next(err)
    if !user
      return res.status(401).send({"err": "Login or password is wrong"})
    req.login user, (err) ->
      if err
        return next(err)
      return res.send(user)
  ) req, res, next


