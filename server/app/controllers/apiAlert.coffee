express = require 'express'
router = express.Router()
AlertRepository = require '../repository/AlertRepository.coffee'
AlertLauncher = require '../services/AlertLauncher.coffee'
Authentification = require '../utils/Authentification.coffee'

module.exports = (app) ->
  app.use '/api/alerts', router


###
  @api {get} /alerts/ Request all alerts informations
  @apiGroup Alerts
  @apiSuccess {Object[]} alerts List of alerts
  @apiSuccess {Date}   alert.date   Alert creation date
  @apiSuccess {Number}   alert.criticity   Alert criticity
  @apiSuccess {String}   alert.type   Alert type
  @apiSuccess {Number}   alert.geoPosition.latitude   position of user
  @apiSuccess {Number}   alert.geoPosition.longitude   position of user
###
router.get '/', (req, res, next) ->
  AlertRepository.getAll req.user, (err, alerts)->
    res.json(alerts)

###
  @api {get} /user/:id Request all alerts informations for a user
  @apiGroup Alerts
  @apiSuccess {Alert[]} alerts List of alerts
  @apiParam {String} id  User id
###
router.get '/user/:id', Authentification.isAuth, (req, res, next) ->
  AlertRepository.getUserAlers req.params.id, req.user, (err, alerts)->
    res.json(alerts)

###
  @api {post} /alerts/ Request create an alert
  @apiGroup Alerts
  @apiSuccess {Object} alerts created
  @apiSuccess {Date}   alert.date   Alert creation date
  @apiSuccess {Number}   alert.criticity   Alert criticity
  @apiSuccess {String}   alert.type   Alert type
  @apiSuccess {Object}   alert.geoPosition   position of user
  @apiSuccess {Number}   alert.geoPosition.latitude   position of user
  @apiSuccess {Number}   alert.geoPosition.longitude   position of user
###
router.post '/', Authentification.isAuth, (req, res, next) ->
  AlertRepository.createAlert req.body, req.user, (err, alert)->
    if(err)
      res.status(400).json(err)
    else
      res.json(alert)

###
   @api {post} /alerts/command Request create an alert from vocal speech
   @apiGroup Alerts
   @apiParam {[String]} msg    List of speech command
   @apiSuccess {String} result of command
###
router.post '/command', Authentification.isAuth, (req, res, next) ->
  command = req.body.msg
  AlertLauncher command, req.user, (result)->
    res.send({result: result})


###
  @api {post} /alerts/call-police/:alertID call the police for alert
  @apiGroup Alerts
###
router.post '/call-police/:alertID', Authentification.isAuth, (req, res, next) ->
  AlertRepository.callPolice req.params.alertID, req.user, (err, alert)->
    if(err)
      res.status(400).json(err)
    else
      res.json(alert)

###
@api {post} /alerts/call-samu/:alertID call the samu for alert
@apiGroup Alerts
###
router.post '/call-samu/:alertID', Authentification.isAuth, (req, res, next) ->
  AlertRepository.callSamu req.params.alertID, req.user, (err, alert)->
    if(err)
      res.status(400).json(err)
    else
      res.json(alert)

###
  @api {post} /alerts/ongoing/:alertID set user going on alert
  @apiGroup Alerts
###
router.post '/ongoing/:alertID', Authentification.isAuth, (req, res, next) ->
  AlertRepository.onGoing req.params.alertID, req.user, (err, alert)->
    if(err)
      res.status(400).json(err)
    else
      res.json(alert)

###
@api {post} /alerts/resolve/:alertID set the alert resolved
@apiGroup Alerts
###
router.post '/resolve/:alertID', Authentification.isAuth, (req, res, next) ->
  AlertRepository.resolve req.params.alertID, req.user, (err, alert)->
    if(err)
      res.status(400).json(err)
    else
      res.json(alert)
