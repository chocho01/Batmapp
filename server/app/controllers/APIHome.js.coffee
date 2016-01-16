express  = require 'express'
router = express.Router()
UserRepository  = require '../repository/UserRepository.coffee'

module.exports = (app) ->
  app.use '/', router

###
  Request to get all users
###
router.get '/', (req, res, next) ->
  UserRepository.getAll (err, users) ->
    return next(err) if err
    res.json(users)
