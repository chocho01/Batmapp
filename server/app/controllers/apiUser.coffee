express  = require 'express'
router = express.Router()
UserRepository  = require '../repository/UserRepository.coffee'

module.exports = (app) ->
  app.use '/api/users', router

###
  Request to get all users
###
router.get '/', (req, res, next) ->
  UserRepository.getAll (err, users) ->
    return next(err) if err
    res.json(users)

###
  Request to create a user
###
router.post '/', (req, res, next) ->
  console.log req.body
  UserRepository.createUser req.body, (err, user) ->
    return next(err) if err
    res.json(user)
