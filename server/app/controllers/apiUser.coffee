express  = require 'express'
router = express.Router()
UserRepository  = require '../repository/UserRepository.coffee'
Authentification  = require '../utils/Authentification.coffee'

module.exports = (app) ->
  app.use '/api/users', router

###
  @api {get} /users/ Request all Users informations
  @apiGroup Users
  @apiSuccess {Object[]} users List of user
  @apiSuccess {String}   users.email   Users email.

###
router.get '/', Authentification.isAuth, (req, res, next) ->
  UserRepository.getAll (err, users) ->
    return next(err) if err
    res.json(users)

###
  @api {post} /users/ Create a user
  @apiGroup Users
  @apiSuccess {Object} user User created
###
router.post '/', (req, res, next) ->
  UserRepository.createUser req.body, (err, user) ->
    if err
      res.status(400).json()
    else
      res.json(user)


###
  @api {post} /update-position/ Request all Users informations
  @apiGroup Users
  @apiSuccess {Object[]} users List of user
  @apiSuccess {String}   users.email   Users email.

###
router.post '/update-position', Authentification.isAuth, (req, res, next) ->
  UserRepository.updatePosition req.body, req.user, (err, user) ->
    if err
      res.status(400).json()
    else
      res.json(user)
