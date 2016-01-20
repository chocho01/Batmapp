express  = require 'express'
router = express.Router()
mongoose = require 'mongoose'
AlertRepository  = require '../repository/AlertRepository.coffee'

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
  AlertRepository.getAll (alerts)->
    res.json(alerts)



###
  @api {post} /alerts/ Request all alerts informations
  @apiGroup Alerts
  @apiSuccess {Object} alerts created
  @apiSuccess {Date}   alert.date   Alert creation date
  @apiSuccess {Number}   alert.criticity   Alert criticity
  @apiSuccess {String}   alert.type   Alert type
  @apiSuccess {Number}   alert.geoPosition.latitude   position of user
  @apiSuccess {Number}   alert.geoPosition.longitude   position of user
###
router.post '/', (req, res, next) ->
  AlertRepository.createAlert req.body, (alert)->
    res.json(alert)
