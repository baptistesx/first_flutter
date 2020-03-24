var mongoose = require("mongoose");
var users = require("./models/userSchema").users;
var jwt = require("jsonwebtoken");
var crypto = require("crypto");

module.exports.connectDB = function() {
    //Set up default mongoose connection
    var mongoDB = "mongodb://127.0.0.1:8080/project";
    mongoose.connect(mongoDB, {
        useNewUrlParser: true
    });

    //Get the default connection
    var db = mongoose.connection;

    //Bind connection to error event (to get notification of connection errors)
    db.on("error", console.error.bind(console, "MongoDB connection error:"));
};