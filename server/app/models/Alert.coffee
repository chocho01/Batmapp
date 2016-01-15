# Example model

mongoose = require 'mongoose'
Schema = mongoose.Schema

AlertSchema = new Schema(
  date:
    type: Date
    require: true
  sender:
    type: String
    require: true
  criticity:
    type: Number
    require: true
  type:
    type: String
    require: true
  geoPosition:
    latitude:
      type: Number
      require: true
    longitude:
      type: Number
      require: true
  receiver:
    type: Array
  police:
      type: Boolean
      require: true
  samu:
    type: Boolean
    require: true
  solved:
    type: Boolean
    require: true
)

mongoose.model 'Alert', AlertSchema

