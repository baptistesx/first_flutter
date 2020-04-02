const mongoose = require("mongoose");
var Schema = mongoose.Schema,
  ObjectId = Schema.ObjectId;

const modulesSchema = new mongoose.Schema({
  publicID: String,
  privateID: String,
  name: String,
  place: String,
  used: Boolean,
  user: {type: ObjectId, ref: 'users'},
  sensors: [{type: ObjectId, ref: 'sensors'}]
});

module.exports.modules = mongoose.model("modules", modulesSchema);
