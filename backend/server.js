//TODO: créer fichier de log
//TODO: décrire chaque paramètre des fonctions + callback
//TODO: gerer tous les cas d'erreur
//TODO: utiliser des callback(code, "reponse") dans mongo_mod.js

var express = require("express");
var app = express();
var http = require("http");
var bodyParser = require("body-parser");
var mongo = require("./project_modules/mongo_mod");
var users = require("./project_modules/models/userSchema").users;
var modules = require("./project_modules/models/modulesSchema").modules;

var sensors = require("./project_modules/models/sensorsSchema").sensors;
var actuators = require("./project_modules/models/actuatorsSchema").actuators;
var datas = require("./project_modules/models/dataSchema").datas;

const KEY = "m yincredibl y(!!1!11!)zpG6z2s8)Key'!";

app.use(
  bodyParser.urlencoded({
    extended: false,
  })
);

//Route pour inscription d'un utilisateur
app.post("/api/signup", function (req, res) {
  console.log("new request: /api/signup");

  var email = req.body.email;
  var password = req.body.pwd;

  mongo.register(email, password, function (code, answer) {
    res.status(code).send(answer);
  });
});

//Route pour connexion de l'utilisateur
app.post("/api/login", function (req, res) {
  console.log("new request: /api/login");

  var email = req.body.email;
  var password = req.body.pwd;

  mongo.logUser(email, password, function (code, answer) {
    res.status(code).send(answer);
  });
});

//Route pour ajouter un module à l'utilisateur
app.post("/api/user/addModule", function (req, res) {
  console.log("new request: /api/user/addModule");

  try {
    //Vérification du JWT (JSON Web Token)
    var email = mongo.checkJWT(req.get("Authorization"), KEY);

    if (email != null) {
      //Récupération de l'utilisateur associé au JWT
      mongo.userExists(email, function (user) {
        if (user != null) {
          //Ajout du module dans la liste des modules de l'utilisateur
          mongo.addModule(
            user,
            req.body.name,
            req.body.place,
            req.body.publicID,
            req.body.privateID,
            function (answer) {
              res.send(answer);
            }
          );
        }
      });
    }
  } catch {
    res.status(401).send("Bad Token");
  }
});

//Mise à jour de l'état d'un actionneur d'id reçu en paramètre
app.post("/api/user/setActuatorState", function (req, res) {
  console.log("new request: /api/user/setActuatorState");

  try {
    //Vérification du JWT (JSON Web Token)
    var email = mongo.checkJWT(req.get("Authorization"), KEY);

    if (email != null) {
      //Récupération de l'utilisateur associé au JWT
      mongo.userExists(email, function (user) {
        if (user != null) {
          var id = req.body.actuatorId;
          var value = req.body.value;

          //TODO: Faire réelle requete au module et changer etat en bdd que si validé par module

          mongo.setActuatorState(id, value, function (code, answer) {
            res.status(code).send(answer);
          });
        }
      });
    }
  } catch {
    res.status(401).send("Bad Token");
  }
});

//Mise à jour du mode automatic de l'actionneur
app.post("/api/user/setActuatorAutomaticMode", function (req, res) {
  console.log("new request: /api/user/setActuatorAutomaticMode");

  try {
    //Vérification du JWT (JSON Web Token)
    var email = mongo.checkJWT(req.get("Authorization"), KEY);

    if (email != null) {
      //Récupération de l'utilisateur associé au JWT
      mongo.userExists(email, function (user) {
        if (user != null) {
          var id = req.body.actuatorId;
          var value = req.body.value;

          //TODO: Faire réelle requete au module et changer etat en bdd que si validé par module

          mongo.setActuatorAutomaticMode(id, value, function (code, answer) {
            res.status(code).send(answer);
          });
        }
      });
    }
  } catch {
    res.status(401).send("Bad Token");
  }
});

//Route pour mise à jour du nom de l'objet (capteur ou module) d'id reçu en paramètre
//Si req.body.isSensor = true => c'est un nom de capteur à mettre à jour
//Sinon c'est celui d'un module
app.post("/api/user/updateModuleName", function (req, res) {
  console.log("new request: /api/user/updateModuleName");

  try {
    //Vérification du JWT (JSON Web Token)
    var email = mongo.checkJWT(req.get("Authorization"), KEY);

    if (email != null) {
      //Récupération de l'utilisateur associé au JWT
      mongo.userExists(email, function (user) {
        if (user != null) {
          var id = req.body.id;
          var newName = req.body.newName;

          console.log("module");
          mongo.updateSensorName(id, newName, function (code, answer) {
            res.status(code).send(answer);
          });
        }
      });
    }
  } catch {
    res.status(401).send("Bad Token");
  }
});

app.get("/api/user/getModules", function (req, res) {
  console.log("new request: /api/user/getModules");

  try {
    //Vérification du JWT (JSON Web Token)
    var email = mongo.checkJWT(req.get("Authorization"), KEY);

    if (email != null) {
      //Récupération de l'utilisateur associé au JWT
      mongo.userExists(email, function (user) {
        if (user != null) {
          mongo.getModules(email, function (code, answer) {
            res.status(code).send(answer);
          });
        }
      });
    }
  } catch {
    res.status(401).send("Bad Token");
  }
});

// Démarrage du serveur
http.createServer(app).listen(process.env.PORT || 8081, function () {
  return console.log(
    "Started user authentication server listening on port 8081"
  );
});

//Connexion à la base de données
mongo.connectDB();
