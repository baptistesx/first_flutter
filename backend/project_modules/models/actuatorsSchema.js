const mongoose = require("mongoose");
var Schema = mongoose.Schema,
  ObjectId = Schema.ObjectId;

const actuatorsSchema = new mongoose.Schema({
  name: String,
  module: { type: ObjectId, ref: "modules" },
  state: Boolean,
  value: Number,
  startTime: Date,
  stopTime: Date, 
});

module.exports.actuators = mongoose.model("actuators", actuatorsSchema);
