LocalStrategy = require('passport-local').Strategy
md5 = require('md5')
mongoose = require('mongoose')
UserModel = mongoose.model('user')

module.exports = (passport) ->
  passport.serializeUser (user, done) ->
    done null, user
    return
  passport.deserializeUser (id, done) ->
    done null, id
    return
  passport.use 'local-login', new LocalStrategy({
    usernameField: 'user'
    passwordField: 'password'
    passReqToCallback: true
  }, (req, username, password, done) ->
    UserModel.findOne { email: username }, (err, user) ->
      if !user
        return done(null, false)
      # Si il existe un utilisateur avec le bon mot de passe alors on le connecte
      if user.password == md5(password)
        done null, user
      else
        done null, false
  )
