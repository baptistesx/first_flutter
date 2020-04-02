const mongoose = require("mongoose");
var Schema = mongoose.Schema,
  ObjectId = Schema.ObjectId;
const dataSchema = new mongoose.Schema({
  sensor: String,
  values: Array,
});

module.exports.sensors = mongoose.model("data", dataSchema);
