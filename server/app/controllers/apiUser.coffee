express = require 'express'
router = express.Router()
UserRepository = require '../repository/UserRepository.coffee'
Authentification = require '../utils/Authentification.coffee'
gm = require('gm')
imageMagick = gm.subClass({ imageMagick: false })
multer = require('multer')
storage = multer.diskStorage(
  destination: (req, image, cb)->
    cb(null, 'public/img/profil')
  filename: (req, file, cb)->
    cb(null, req.user._id + ".png")
)
upload = multer({storage: storage})

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


router.post '/upload', upload.single('file'), (req, res, next) ->
  console.log(req.file)
  imageMagick(req.file.path)
    .resize('400', '300', '^')
    .gravity('Center')
    .crop('400', '300')
    .write(req.file.destination+"/large-"+req.file.filename, (err)->
      console.log(err)
    )

  imageMagick(req.file.path)
    .resize('500', '500', '^')
    .gravity('Center')
    .crop('500', '500')
    .write(req.file.path, (err)->
      if (!err)
        UserRepository.updateImage(req.user, req.file.filename, (err, user)->
          if(err)
            res.status(400).send(err)
          else
            res.send(user)
        )
      else
        res.status(400).send(err)
    )
