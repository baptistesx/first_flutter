const mongoose = require('mongoose')

const usersSchema = new mongoose.Schema({ email: String, pwd: String, modules: Array});

module.exports.users = mongoose.model("users", usersSchema);