//TODO: créer fichier de log (écrire dans un fichier: date, heure, commande, resultat)

//TODO: décrire chaque paramètre des fonctions + callback

//TODO: gerer tous les cas d'erreur

//TODO: utiliser des callback(code, "reponse") dans mongo_mod.js

//TODO: passer le serveur en https, voir server_https_to_check.js
// + https://www.zem.fr/creer-un-serveur-https-nodejs-express/ pour générer le certificat

//TODO: faire en sorte que toutes les requetes sur les modules soient bien exécutées
// sur le user après l'avoir checké

//TODO: supprimer le paramètre sensorDataIndex car devenu inutile comme on a descendu d'un niveau

//TODO: coup de formattage auto

//TODO: supprimer commentaires inutiles (console.log)

//TODO: ajouter tableau d'actuators au schema du module

var express = require("express");
var app = express();
var http = require("http");
var bodyParser = require("body-parser");
var mongo = require("./project_modules/mongo_mod");
var controler = require("./project_modules/control_mod");
var jwt = require("jsonwebtoken");

const KEY = "m yincredibl y(!!1!11!)zpG6z2s8)Key'!";

app.use(bodyParser.urlencoded({
  extended: false
}));

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
  //Vérification du JWT (JSON Web Token)
  //Vérifie si le token match bien avec l'email
  var email = jwt.verify(req.get("Authorization"), KEY, {
    algorithm: "HS256"
  }).email;

  //Ajout du module dans la liste des modules de l'utilisateur
  mongo.addModule(
    email,
    req.body.name,
    req.body.place,
    req.body.publicID,
    req.body.privateID,
    function (answer, code) {
      res.status(code).send(answer);
    }
  );
});

//Mise à jour de l'état d'un actionneur d'id reçu en paramètre
app.post("/api/user/setActuatorState", function (req, res) {
  console.log("new request: /api/user/setActuatorState");

  var id = req.body.actuatorId;
  var value = req.body.value;
  //Vérification du JWT (JSON Web Token)
  var email = jwt.verify(req.get("Authorization"), KEY, {
    algorithm: "HS256"
  }).email;

  //Récupération de l'utilisateur associé au JWT
  controler.userExists(email, function (err, user) {
    if (user != null) {

      //TODO: Faire réelle requete au module et changer etat en bdd que si validé par module

      mongo.setActuatorState(id, value, function (code, answer) {
        res.status(code).send(answer);
      });
    } else {
      res.status(401).send(err)
    }
  });
});

//Mise à jour du mode automatic de l'actionneur
app.post("/api/user/setActuatorAutomaticMode", function (req, res) {
  console.log("new request: /api/user/setActuatorAutomaticMode");

  var id = req.body.actuatorId;
  var value = req.body.value;
  //Vérification du JWT (JSON Web Token)
  var email = jwt.verify(req.get("Authorization"), KEY, {
    algorithm: "HS256"
  }).email;

  //Récupération de l'utilisateur associé au JWT
  controler.userExists(email, function (err, user) {
    if (user != null) {

      //TODO: Faire réelle requete au module et changer etat en bdd que si validé par module

      mongo.setActuatorAutomaticMode(id, value, function (code, answer) {
        res.status(code).send(answer);
      });
    } else {
      res.status(401).send(err)
    }
  });
});

//Mise à jour du mode automatic de l'actionneur
app.post("/api/user/updateSensorAutomaticMode", function (req, res) {
  console.log("new request: /api/user/updateSensorAutomaticMode");

  var sensorId = req.body.sensorId;
  var sensorDataIndex = req.body.sensorDataIndex;
  var newValue = req.body.newValue;
  //Vérification du JWT (JSON Web Token)
  var email = jwt.verify(req.get("Authorization"), KEY, {
    algorithm: "HS256"
  }).email;

  //Récupération de l'utilisateur associé au JWT
  controler.userExists(email, function (err, user) {
    if (user != null) {
      //TODO: Faire réelle requete au module et changer etat en bdd que si validé par module

      mongo.updateSensorDataAutomaticMode(
        sensorId,
        newValue,
        function (code, answer) {
          res.status(code).send(answer);
        }
      );
    } else {
      res.status(401).send(err)
    }
  });
});

//Mise à jour de la config d'un sensorData
app.post("/api/user/updateSensorDataConfig", function (req, res) {
  console.log("new request: /api/user/updateSensorDataConfig");

  var sensorId = req.body.sensorId;
  var sensorDataIndex = req.body.sensorDataIndex;
  var newNominalValue = req.body.newNominalValue;
  var newAcceptableMin = req.body.newAcceptableMin;
  var newAcceptableMax = req.body.newAcceptableMax;
  var newCriticalMin = req.body.newCriticalMin;
  var newCriticalMax = req.body.newCritiacalMax;
  //Vérification du JWT (JSON Web Token)
  var email = jwt.verify(req.get("Authorization"), KEY, {
    algorithm: "HS256"
  }).email;

  //Récupération de l'utilisateur associé au JWT
  controler.userExists(email, function (err, user) {
    if (user != null) {

      //TODO: Faire réelle requete au module et changer etat en bdd que si validé par module

      mongo.updateSensorDataConfig(
        sensorId,
        sensorDataIndex,
        newNominalValue,
        newAcceptableMin,
        newAcceptableMax,
        newCriticalMin,
        newCriticalMax,
        function (code, answer) {
          res.status(code).send(answer);
        }
      );
    } else {
      res.status(401).send(err)
    }
  });

});

//Route pour mise à jour du module d'id reçu en paramètre
app.post("/api/user/updateModule", function (req, res) {
  console.log("new request: /api/user/updateModule");

  var id = req.body.id;
  var newName = req.body.newName;
  var newPlace = req.body.newPlace;
  //Vérification du JWT (JSON Web Token)
  var email = jwt.verify(req.get("Authorization"), KEY, {
    algorithm: "HS256"
  }).email;

  //Récupération de l'utilisateur associé au JWT
  controler.userExists(email, function (err, user) {
    if (user != null) {
      // console.log(newName);
      // console.log(newPlace);
      var response = "ok";
      var codeResponse = 200;
      if (newName != "") {
        mongo.updateModuleName(id, newName, function (code, answer) {
          codeResponse = code;
          response = answer;
        });
      }
      if (newPlace != "") {
        mongo.updateModulePlace(id, newPlace, function (code, answer) {
          codeResponse = code;
          response = answer;
        });
      }
      res.status(codeResponse).send(response);
    } else {
      res.status(401).send(err)
    }
  });
});

//Route pour mise à jour d'un capteur d'id reçu en paramètre
app.post("/api/user/updateSensor", function (req, res) {
  console.log("new request: /api/user/updateSensor");

  var id = req.body.id;
  var newName = req.body.newName;
  //Vérification du JWT (JSON Web Token)
  var email = jwt.verify(req.get("Authorization"), KEY, {
    algorithm: "HS256"
  }).email;

  //Récupération de l'utilisateur associé au JWT
  controler.userExists(email, function (err, user) {
    if (user != null) {
      // console.log(newName);
      mongo.updateSensor(id, newName, function (code, answer) {
        res.status(code).send(answer);
      });
    } else {
      res.status(401).send(err)
    }
  });
});

//Utilisateur "supprime" un module de sa liste => libérer module mais pas supprimer
app.post("/api/user/removeModule", function (req, res) {
  console.log("new request: /api/user/removeModule");

  //Vérification du JWT (JSON Web Token)
  var email = jwt.verify(req.get("Authorization"), KEY, {
    algorithm: "HS256"
  }).email;

  //Récupération de l'utilisateur associé au JWT
  controler.userExists(email, function (err, user) {
    if (user != null) {
      var id = req.body.id;

      mongo.freeModule(email, id, function (code, answer) {
        res.status(code).send(answer);
      });
    } else {
      res.status(401).send(err);
    }
  });
});

app.get("/api/user/getModules", function (req, res) {
  console.log("new request: /api/user/getModules");

  //Vérification du JWT (JSON Web Token)
  var email = jwt.verify(req.get("Authorization"), KEY, {
    algorithm: "HS256"
  }).email;

  //Récupération de l'utilisateur associé au JWT
  controler.userExists(email, function (err, user) {
    if (user != null) {
      mongo.getModules(email, function (code, answer) {
        console.log("%j", answer);
        res.status(code).send(answer);
      });
    } else {
      res.status(401).send(err);
    }
  });
});

app.get("/api/user/updateActuatorStateById", function (req, res) {
  console.log("new request: /api/user/updateActuatorStateById");

  //Vérification du JWT (JSON Web Token)
  var email = jwt.verify(req.get("Authorization"), KEY, {
    algorithm: "HS256"
  }).email;

  //Récupération de l'utilisateur associé au JWT
  controler.userExists(email, function (err, user) {
    if (user != null) {
      var actuatorId = req.body.actuatorId;
      var newValue = req.body.newValue;

      mongo.updateActuatorStateById(actuatorId, newValue, function (code, answer) {
        console.log("%j", answer);
        res.status(code).send(answer);
      });
    } else {
      res.status(401).send(err);
    }
  });
});

// Démarrage du serveur
http.createServer(app).listen(process.env.PORT || 8081, function () {
  return console.log(
    "Started user authentication server listening on port 8081"
  );
});

//Connexion à la base de données
mongo.connectDB();