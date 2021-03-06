mongoose = require 'mongoose'
Schema = mongoose.Schema

UserSchema = new Schema(
  email:
    type: String
    required: true
    unique: true
    validate: [/.+\@.+\..+/, 'Email n\'est pas valide']
  password:
    type: String
    required: true
  firstName:
    type: String
    required: true
  lastName:
    type: String
    required: true
  lastPosition:
    latitude:
      type: Number
    longitude:
      type: Number
  profilPicture:
    type: String
    default : "default.jpg"
  token:
    type : String
)

mongoose.model 'user', UserSchema

