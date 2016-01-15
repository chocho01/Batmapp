mongoose = require 'mongoose'
Schema = mongoose.Schema

UserSchema = new Schema(
  email:
    type: String
    require: true
    unique: true
  password:
    type: String
    require: true
  firstName:
    type: String
    require: true
  lastName:
    type: String
    require: true

)

mongoose.model 'User', UserSchema

