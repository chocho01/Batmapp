# Example model

mongoose =  require 'mongoose'
Schema = mongoose.Schema

AlertSchema = new Schema(
  date:
    type: Date
    required: true
  sender:
    id :
      type: String
      required: true
    name :
      type: String
      required: true
    profilPicture:
      type: String
      default : "default.jpg"
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
    default : false
  samu:
    type: Boolean
    default : false
  solved:
    type: Boolean
    default : false
)

mongoose.model 'alert', AlertSchema

