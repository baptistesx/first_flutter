var mongoose = require("mongoose");
var modules = require("./models/modulesSchema").modules;
var users = require("./models/userSchema").users;
var datas = require("./models/dataSchema").datas;
var jwt = require("jsonwebtoken");
var crypto = require("crypto");
var sensors = require("./models/sensorsSchema").sensors;
var validator = require("email-validator");
var actuators = require("./models/actuatorsSchema").actuators;
const KEY = "m yincredibl y(!!1!11!)zpG6z2s8)Key'!";

//Setup et connexion à la base de données MongoDb
module.exports.connectDB = function () {
  var mongoDB = "mongodb://localhost/monitoring";
  mongoose.connect(mongoDB, {
    useUnifiedTopology: true,
    useNewUrlParser: true,
  });

  //Get the default connection
  var db = mongoose.connection;

  //Bind connection to error event (to get notification of connection errors)
  db.on("error", console.error.bind(console, "MongoDB connection error:"));
};

//Vérifie si le token match bien avec l'email
module.exports.checkJWT = function (token, KEY) {
  return jwt.verify(token, KEY, { algorithm: "HS256" }).email;
};

//Encyrption du password reçu en paramètre
module.exports.encryptPwd = function (pwd, callback) {
  callback(crypto.createHash("sha256").update(pwd).digest("hex"));
};
//TODO: trouver comment déclarer qu'une seule fois cette fonction
encryptPwd = function (pwd, callback) {
  callback(crypto.createHash("sha256").update(pwd).digest("hex"));
};

//Vérifie si un utilisateur avec l'email reçue en paramètre existe
module.exports.userExists = function (email, callback) {
  users.findOne({ email: email }, function (err, user) {
    callback(user);
  });
};

//Vérification des conditions et association d'un module à un utilisateur
module.exports.addModule = function (
  user,
  moduleName,
  modulePlace,
  publicID,
  privateID,
  callback
) {
  //Vérification de l'existence du module (les deux ID doivent matcher)
  moduleExists(publicID, privateID, function (module) {
    if (module != null) {
      //On vérifie si l'utilisateur n'a pas déjà ajouté ce module
      userOwnsThisModule(user, module, function (res) {
        if (res) {
          //Cas 1: module déjà ajouté
          callback("You've already added this module.");
        } else {
          //Cas 2: module non encore ajouté

          //On vérifie si le module est associé à un autre utilisateur
          isModuleUsed(module, function (isUsed) {
            if (isUsed) {
              //Cas 1: module ajouté par un autre utilisateur
              callback("This module isn't available.");
            } else {
              //Cas 2: module disponible
              console.log(
                "le module d'id: " +
                  publicID +
                  "n'est pas deja utilisé => liaison avec le user"
              );

              //On associe ce module a l'utilisateur
              linkModule2User(user, module, moduleName, modulePlace, function (
                res
              ) {
                if (res == null)
                  callback("The module has been added with success!");
                else callback("Error while adding the module");
              });
            }
          });
        }
      });
    } else {
      //Les IDs ne matchent pas => le module correspondant n'existe pas
      callback("This module doesn't exist. Try again.");
    }
  });
};

//Vérification qu'un module match avec les IDs reçus
function moduleExists(publicID, privateID, callback) {
  modules.findOne({ publicID: publicID, privateID: privateID }, function (
    err,
    module
  ) {
    callback(module);
  });
}

//Vérifie si l'utilisateur a déjà ajouté ce module
function userOwnsThisModule(user, module, callback) {
  callback(user.modules.includes(module._id));
}

//Vérifie si le module est déjà associé à un utilisateur
function isModuleUsed(module, callback) {
  callback(module.used);
}

//Associe le module à l'utilisateur
function linkModule2User(user, module, moduleName, modulePlace, callback) {
  modules
    .updateOne(
      { _id: module._id },
      {
        $set: {
          name: moduleName,
          place: modulePlace,
          used: true,
          user: user._id,
        },
      }
    )
    .then((obj) => {
      users.updateOne(
        { email: user.email },
        { $push: { modules: module._id } },
        function (err) {
          callback(err);
        }
      );
    });
}

//Verification
module.exports.register = function (email, password, callback) {
  //Vérification du format de l'email
  var emailVerif = validator.validate(email);

  if (emailVerif) {
    //Le format de l'email est correct
    users.find(
      {
        email: email,
      },
      function (err, user) {
        if (user.length != 0) {
          //Cas 1: cette adresse email est déjà utilisée
          callback(409, "An user with that username already exists");
        } else {
          //Cas 2: cette adresse email n'est pas déjà utilisée => création de l'utilisateur
          //Le password est encrypté
          encryptPwd(password, function (encPassword) {
            createUser(email, encPassword, function (answer) {
              callback(201, answer);
            });
          });
        }
      }
    );
  } else {
    //Mauvais format d'email
    callback(409, "Bad email format");
  }
};

//Inscription d'un utilisateur
createUser = function (email, encPassword, callback) {
  var newUser = new users({ email: email, pwd: encPassword });
  newUser.save(function (err, user) {
    if (err) {
      return handleError(err);
    }
    callback("User well created!");
  });
};

//Vérification et connexion de l'utilisateur (renvoie un JWT)
module.exports.logUser = function (email, password, callback) {
  //Le password est encrypté
  encryptPwd(password, function (encPassword) {
    //Recherche d'un utilisateur qui match l'email et le password encrypté
    users.find(
      //TODO: utiliser findOne?
      {
        email: email,
        pwd: encPassword,
      },
      function (err, user) {
        if (user.length != 0) {
          //L'utilisateur existe bien

          var payload = {
            email: email,
          };

          //Génération du JWT (JSON Web Token)
          var token = jwt.sign(payload, KEY, {
            algorithm: "HS256",
            expiresIn: "15d",
          });

          callback(200, token);
        } else {
          callback(401, "There's no user matching that");
        }
      }
    );
  });
};

//Mise à jour du nom du module d'id reçu en paramètre
module.exports.updateModuleName = function (id, newName, callback) {
  modules
    .updateOne(
      { _id: id },
      {
        $set: {
          name: newName,
        },
      }
    )
    .then((obj) => {
      callback(200, "ok");
    });
};

//Mise à jour de la place du module d'id reçu en paramètre
module.exports.updateModulePlace = function (id, newPlace, callback) {
  modules
    .updateOne(
      { _id: id },
      {
        $set: {
          place: newPlace,
        },
      }
    )
    .then((obj) => {
      callback(200, "ok");
    });
};

//Mise à jour du nom du capteur d'id reçu en paramètre
module.exports.updateSensor = function (id, newName, callback) {
  sensors
    .updateOne(
      { _id: id },
      {
        $set: {
          name: newName,
        },
      }
    )
    .then((obj) => {
      callback(200, "ok");
    });
};

//Mise à jour du nom du capteur d'id reçu en paramètre
module.exports.updateSensorName = function (id, newName, callback) {
  console.log(id);
  console.log(newName);
  sensors
    .updateOne(
      { _id: id },
      {
        $set: {
          name: newName,
        },
      }
    )
    .then((obj) => {
      callback(200, "ok");
    });
};

//Mise à jour de l'état de l'actionneur d'id recu en paramètre
//avec la valeur value reçue en paramètre
module.exports.setActuatorState = function (id, value, callback) {
  actuators
    .updateOne(
      { _id: id },
      {
        $set: {
          state: value,
        },
      }
    )
    .then((obj) => {
      callback(200, "Success");
    });
};

//Mise à jour du mode automatique de l'actionneur d'id recu en paramètre
//avec la valeur value reçue en paramètre
module.exports.setActuatorAutomaticMode = function (id, value, callback) {
  actuators
    .updateOne(
      { _id: id },
      {
        $set: {
          automaticMode: value,
        },
      }
    )
    .then((obj) => {
      callback(200, "Success");
    });
};

module.exports.getModules = function (email, callback) {
  var o = {}; // empty Object
  o = []; // empty Array, which you can push() values into
  var ok = true;
  users
    .findOne({ email: email }, function (err, user) {
      //renvoie le user trouvé
      if (user.modules.length == 0) {
        console.log();
        callback(200, JSON.stringify(o));
        ok = false;
      }
    })
    .populate({
      //Remplace l'ObjectId du champ "modules" de user par l'objet correpsondant
      path: "modules",
      model: "modules",
      //Remplace l'ObjectId du champ "sensors" du module peuplé précédemment par l'objet correpsondant
      populate: [
        {
          path: "sensors",
          model: "sensors",
          populate: {
            path: "sensorData.data",
            model: "datas",
            options: { limit: 0 },
          },
        },
        {
          path: "actuators",
          model: "actuators",
        },
      ],
    })
    .exec(function (err, user) {
      if (err) return handleError(err);
      if (ok) {
        callback(200, user.modules);
      }
    });
};

//Réinitialise le module et le désassocie du user
module.exports.freeModule = function (email, id, callback) {
  console.log("remove " + id);
  modules
    .updateOne(
      { _id: id },
      {
        $set: {
          name: "ModuleN",
          place: "PlaceN",
          used: false,
          user: undefined,
        },
      }
    )
    .then((obj) => {
      users.findOne({ email: email }, function(err, user){
        user.modules.remove(id);
        user.save();
      });
      callback(200, "Success");
    });
  callback(200, "ok");
};
