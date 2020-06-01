const mongoose = require("mongoose");
var Schema = mongoose.Schema,
  ObjectId = Schema.ObjectId;

const sensorsSchema = new mongoose.Schema({
  name: String,
  sensorData: [
    { dataType: String, unit: String, 
      limitMin: Number,
      limitMax: Number,
      setupValue: Number,
      automaticMode: Boolean,
      data: { type: ObjectId, ref: "datas" } },
  ],
  module: { type: ObjectId, ref: "modules" },
});

module.exports.sensors = mongoose.model("sensors", sensorsSchema);
