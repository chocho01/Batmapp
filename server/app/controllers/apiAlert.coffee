express  = require 'express'
router = express.Router()
mongoose = require 'mongoose'
#AlertRepository  = require '../repository/AlertRepository.coffee'

module.exports = (app) ->
  app.use '/api/alerts', router

router.get '/', (req, res, next) ->
  res.json()
#  Article.find (err, articles) ->
#    return next(err) if err
#    res.render 'index',
#      title: 'Generator-Express MVC'
#      articles: articles
