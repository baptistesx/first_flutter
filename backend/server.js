var express = require("express");
var app = express();
var http = require("http");
var bodyParser = require("body-parser");
var mongo = require("./project_modules/mongo_mod");
var users = require("./project_modules/models/userSchema").users;
var modules = require("./project_modules/models/modulesSchema").modules;

var sensors = require("./project_modules/models/sensorsSchema").sensors;
var modules = require("./project_modules/models/dataSchema").data;

var jwt = require("jsonwebtoken");
var crypto = require("crypto");
var validator = require("email-validator");
const KEY = "m yincredibl y(!!1!11!)zpG6z2s8)Key'!";

app.use(
  bodyParser.urlencoded({
    extended: false
  })
);
app.set("view engine", "moustache");

app.post("/api/user/module", function(req, res) {
  console.log(req.body);
  var name = req.body.name;
  var place = req.body.place;
  var publicID = req.body.publicID;
  var privateID = req.body.privateID;

  var str = req.get("Authorization");
  console.log("new request");
  try {
    var email = jwt.verify(str, KEY, { algorithm: "HS256" }).email;
    console.log(email);
    //Verifie authentification de l'utilisateur
    users.findOne({ email: email }, function(err, user) {
      //verifie que le module existe dans modules
      modules.findOne({ publicID: publicID, privateID: privateID }, function(
        err,
        module
      ) {
        //Si le module existe
        if (module != null) {
          var moduleID = module._id;
          var moduleUsed = module.used;
          //Si l'utilisateur l'a deja ajouté
          if (user.modules.includes(moduleID))
            res.send("vous avez deja ajouté ce module");
          else {
            //Sinon
            //Si module deja utilisé par un autre user
            if (moduleUsed) {
              res.send("module non disponible");
            } else {
              //On lie ce module a l'utilisateur
              console.log(user.id);
              modules
                .updateOne(
                  { _id: moduleID },
                  {
                    $set: {
                      name: name,
                      place: place,
                      used: true,
                      user: user._id
                    }
                  }
                )
                .then(obj => {
                  users
                    .updateOne(
                      { email: email },
                      { $push: { modules: moduleID } }
                    )
                    .then(obj => {
                      res.send("Le module a bien été ajouté.");
                    });
                });
            }
          }
        } else {
          res.send("ce module n'existe pas, ressayez");
        }
      });
    });
  } catch {
    res.status(401);
    res.send("Bad Token");
  }

  // res.send("okoko");
});

app.post("/signup", function(req, res) {
  console.log(req.body);
  var email = req.body.email;

  var emailVerif = validator.validate(email);
  // res.status(200);
  // res.send("An user with that username already exists");

  if (emailVerif) {
    var password = crypto
      .createHash("sha256")
      .update(req.body.pwd)
      .digest("hex");

    users.find(
      {
        email: email,
        pwd: req.body.pwd
      },
      function(err, docs) {
        if (docs.length != 0) {
          console.error("can't create user " + req.body.email);
          res.status(409);
          res.send("An user with that username already exists");
        } else {
          console.log("Can create user " + req.body.email);
          var newUser = new users({ email: email, pwd: password });
          newUser.save(function(err, user) {
            if (err) {
              return handleError(err);
            }
            console.log(user + " saved to users collection.");
          });
          res.status(201);
          res.send("Success");
        }
      }
    );
  } else {
    console.error("can't create user " + req.body.email);
    res.status(409);
    console.log("mauvais format email");

    res.send("mauvais format email");
  }
});

app.get("/test", function(req, res) {
  console.log("new request");
  // var tab2=
  var tab =
    '[{"name": "toto", "place": "maison"},{"name": "toto", "place": "maison"},{"name": "toto", "place": "maison"}]';
  res.send(tab);
});

app.post("/login", function(req, res) {
  console.log(req.body);
  var email = req.body.email;

  var password = crypto
    .createHash("sha256")
    .update(req.body.pwd)
    .digest("hex");

  users.find(
    {
      email: email,
      pwd: password
    },
    function(err, docs) {
      if (docs.length != 0) {
        var payload = {
          email: email
        };

        var token = jwt.sign(payload, KEY, {
          algorithm: "HS256",
          expiresIn: "15d"
        });
        console.log(email + "Success connection");
        // res.send(email + "Success connection");
        res.send(token);
      } else {
        res.status(401);
        console.log(req.body);

        console.log("erreur connexion");

        res.send("There's no user matching that");
      }
    }
  );
});

app.get("/api/user/modules", function(req, res) {
  var o = {}; // empty Object
  o = []; // empty Array, which you can push() values into

  var j = 0;
  var str = req.get("Authorization");
  console.log("new request");
  try {
    var email = jwt.verify(str, KEY, { algorithm: "HS256" }).email;
    console.log(email);
    users
      .findOne({ email: email }, function(err, user) {
        //renvoie le user trouvé
        if (user.modules.length == 0) {
          console.log();
          res.json(o);
        }
      })
      .populate({
        //Remplace l'ObjectId du champ "modules" de user par l'objet correpsondant
        path: "modules",
        model: "modules",
        //Remplace l'ObjectId du champ "sensors" du module peuplé précédemment par l'objet correpsondant
        populate: { path: "sensors", model: "sensors" }
      })
      .exec(function(err, user) {
        if (err) return handleError(err);
        console.log('%j',user);
        res.send(user.modules);
      });
  } catch {
    res.status(401);

    res.send("Bad Token");
  }
});

// Démarrage du serveur
http.createServer(app).listen(process.env.PORT || 8081, function() {
  return console.log(
    "Started user authentication server listening on port 8081"
  );
});
mongo.connectDB();
