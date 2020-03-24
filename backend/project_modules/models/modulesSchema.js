const mongoose = require('mongoose')

const modulesSchema = new mongoose.Schema({ email: String, pwd: String });

module.exports.modules = mongoose.model("modules", modulesSchema);