var mongoose = require("mongoose");
var modules = require("./models/modulesSchema").modules;
var users = require("./models/userSchema").users;
var datas = require("./models/dataSchema").datas;
var jwt = require("jsonwebtoken");
var crypto = require("crypto");

module.exports.connectDB = function() {
  //Set up default mongoose connection
  var mongoDB =
  "mongodb://localhost/monitoring";
  mongoose.connect(mongoDB, {
    useUnifiedTopology: true,
    useNewUrlParser: true
  });

  //Get the default connection
  var db = mongoose.connection;

  //Bind connection to error event (to get notification of connection errors)
  db.on("error", console.error.bind(console, "MongoDB connection error:"));
};

module.exports.checkJWT = function(str, KEY) {
  return jwt.verify(str, KEY, { algorithm: "HS256" }).email;
};

module.exports.userExists = function(email, callback) {
  console.log("email=" + email);
  users.findOne({ email: email }, function(err, user) {
    console.log("user=" + user);
    callback(user);
  });
};

module.exports.addModule = function(
  user,
  moduleName,
  modulePlace,
  publicID,
  privateID,
  callback
) {
  moduleExists(publicID, privateID, function(module) {
    if (module != null) {
      console.log("le module d'id: "+publicID + "existe bien: " + module)
      //verifie que le module existe dans modules

      userOwnsThisModule(user, module, function(res) {
        if (res) {
          console.log("l'utilisateur possède deja le module d'id: "+publicID)

          callback("You've already added this module.");
        } else {
          console.log("l'utilisateur ne possède pas deja le module d'id: "+publicID)

          //Sinon

          isModuleUsed(module, function(isUsed) {
            if (isUsed) {
              console.log("le module d'id: "+publicID + "est deja utilisé")

              //Si module deja utilisé par un autre user
              callback("This module isn't available.");
            } else {
              console.log("le module d'id: "+publicID + "n'est pas deja utilisé => liaison avec le user")

              //On lie ce module a l'utilisateur
              linkModule2User(
                user,
                module,
                moduleName,
                modulePlace,
                function(res) {
                  if (res == null)
                    callback("The module has been added with success!");
                  else callback("Error while adding the module");
                }
              );
            }
          });
        }
      });
    } else {
      console.log("le module d'id: "+publicID + "n'existe pas")

      // ce module n'existe pas, ressayez
      callback("This module doesn't exist. Try again.");
    }
  });
};

function moduleExists(publicID, privateID, callback) {
  modules.findOne({ publicID: publicID, privateID: privateID }, function(
    err,
    module
  ) {
    callback(module);
  });
}

function userOwnsThisModule(user, module, callback) {
  callback(user.modules.includes(module._id));
}

function isModuleUsed(module, callback) {
  callback(module.used);
}

function linkModule2User(user, module, moduleName, modulePlace, callback) {
  modules
    .updateOne(
      { _id: module._id },
      {
        $set: {
          name: moduleName,
          place: modulePlace,
          used: true,
          user: user._id
        }
      }
    )
    .then(obj => {
      users.updateOne(
        { email: user.email },
        { $push: { modules: module._id } },
        function(err) {
          callback(err);
        }
      );
      // .then(obj => {
      //   callback(true);
      // });
    });
}
