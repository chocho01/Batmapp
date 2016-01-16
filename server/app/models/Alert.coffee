# Example model

mongoose =  require 'mongoose'
Schema = mongoose.Schema

AlertSchema = new Schema(
  date:
    type: Date
    required: true
  sender:
    type: String
    required: true
  criticity:
    type: Number
    required: true
  type:
    type: String
    required: true
  geoPosition:
    latitude:
      type: Number
      required: true
    longitude:
      type: Number
       required: true
  receiver:
    type: Array
  police:
    type: Boolean
    required: true
  samu:
    type: Boolean
    required: true
  solved:
    type: Boolean
    required: true
)

mongoose.model 'Alert', AlertSchema
