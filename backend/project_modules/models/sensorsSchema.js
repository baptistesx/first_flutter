const mongoose = require("mongoose");
var Schema = mongoose.Schema,
  ObjectId = Schema.ObjectId;
const sensorsSchema = new mongoose.Schema({
  name: String,
  type: String,
  unit: String,
  data: {type: ObjectId, ref: 'data'},
});

module.exports.sensors = mongoose.model("sensors", sensorsSchema);
