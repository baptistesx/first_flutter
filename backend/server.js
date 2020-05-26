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

var jwt = require("jsonwebtoken");
var crypto = require("crypto");
var validator = require("email-validator");
const KEY = "m yincredibl y(!!1!11!)zpG6z2s8)Key'!";

app.use(
  bodyParser.urlencoded({
    extended: false,
  })
);
app.set("view engine", "moustache");

app.post("/api/user/module", function (req, res) {
  console.log(req.body);
  // var name = req.body.name;
  // var place = req.body.place;
  // var publicID = req.body.publicID;
  // var privateID = req.body.privateID;

  // var str = req.get("Authorization");
  console.log("new request");
  try {
    var email = mongo.checkJWT(req.get("Authorization"), KEY); //, verify(str, KEY, { algorithm: "HS256" }).email;
    console.log(email);

    if (email != null) {
      mongo.userExists(email, function (user) {
        if (user != null) {
          mongo.addModule(
            user,
            req.body.name,
            req.body.place,
            req.body.publicID,
            req.body.privateID,
            function (answer) {
              console.log(answer);
              res.send(answer);
            }
          );
        }
      });
    }

    // //Verifie authentification de l'utilisateur
    // users.findOne({ email: email }, function(err, user) {
    //   //verifie que le module existe dans modules
    //   modules.findOne({ publicID: publicID, privateID: privateID }, function(
    //     err,
    //     module
    //   ) {
    //     //Si le module existe
    //     if (module != null) {
    //       var moduleID = module._id;
    //       var moduleUsed = module.used;
    //       //Si l'utilisateur l'a deja ajouté
    //       if (user.modules.includes(moduleID))
    //         res.send("vous avez deja ajouté ce module");
    //       else {
    //         //Sinon
    //         //Si module deja utilisé par un autre user
    //         if (moduleUsed) {
    //           res.send("module non disponible");
    //         } else {
    //           //On lie ce module a l'utilisateur
    //           console.log(user.id);
    //           modules
    //             .updateOne(
    //               { _id: moduleID },
    //               {
    //                 $set: {
    //                   name: name,
    //                   place: place,
    //                   used: true,
    //                   user: user._id
    //                 }
    //               }
    //             )
    //             .then(obj => {
    //               users
    //                 .updateOne(
    //                   { email: email },
    //                   { $push: { modules: moduleID } }
    //                 )
    //                 .then(obj => {
    //                   res.send("Le module a bien été ajouté.");
    //                 });
    //             });
    //         }
    //       }
    //     } else {
    //       res.send("ce module n'existe pas, ressayez");
    //     }
    //   });
    // });
  } catch {
    res.status(401);
    res.send("Bad Token");
  }

  // res.send("okoko");
});

app.post("/signup", function (req, res) {
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
        pwd: password,
      },
      function (err, docs) {
        console.log(
          "résultat de la requête: " + docs + " et docs.length=" + docs.length
        );
        if (docs.length != 0) {
          console.error("can't create user " + req.body.email);
          res.status(409).send("An user with that username already exists");
        } else {
          console.log("Can create user " + req.body.email);
          var newUser = new users({ email: email, pwd: password });
          newUser.save(function (err, user) {
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

app.get("/test", function (req, res) {
  console.log("new request");
  // var tab2=
  var tab =
    '[{"name": "toto", "place": "maison"},{"name": "toto", "place": "maison"},{"name": "toto", "place": "maison"}]';
  res.send(tab);
});

app.post("/login", function (req, res) {
  console.log(req.body);
  var email = req.body.email;

  var password = crypto.createHash("sha256").update(req.body.pwd).digest("hex");

  users.find(
    {
      email: email,
      pwd: password,
    },
    function (err, docs) {
      if (docs.length != 0) {
        var payload = {
          email: email,
        };

        var token = jwt.sign(payload, KEY, {
          algorithm: "HS256",
          expiresIn: "15d",
        });
        console.log(email + "Success connection");
        // res.send(email + "Success connection");
        res.send(token);
      } else {
        console.log(req.body);

        console.log("erreur connexion");

        res.status(401).send("There's no user matching that");
      }
    }
  );
});
function custom_sort(a, b) {
  // var maDate = new Date((a.date).toString())
  console.log(a.date);
  return -(new Date(a.date).getTime() - new Date(b.date).getTime());
}

app.post("/api/user/setActuator", function (req, res) {
  console.log(req.body);
  var id = req.body.actuatorId;
  var value = req.body.value;

  //Faire réelle requete au module et changer etat en bdd que si validé par module

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
      res.status(200);
      res.send("Success");
    });
});

app.get("/api/user/modules", function (req, res) {
  var dataIdTab = [];
  // var obj = new Object({aaaa: "ahah", bbbb: "bhbh"});
  // console.log("obj=%j",obj)
  // var newObj = obj.toString().replace(/ahah/, "chch");
  // console.log("newObj=%s",newObj)

  // datas.findOne({ sensor: "5e81197a68819b45fce01000" }, function (err, data) {
  //   console.log("data=" + data);
  //   // var tab = data.values;
  //   data.values.sort(custom_sort);
  //   console.log("values=" + data.values);
  //   console.log(data.values)
  //   // console.log("date=" + data.values[0].value);
  //   // var maDate = data.values[0].date;
  //   // console.log("maDate=" + maDate);
  //   // var data2 = Object.assign({data});

  //   // console.log("before datas=%j",data2)
  //   // // var tab=[];
  //   // // tab.push(data2.values[0])
  //   // console.log("values:%j",data2.values)
  //   // data2= {} ;
  //   // console.log("after data2=%j",data2)
  //   // console.log("myTab=",myTab)
  //   // var val = myTab.sort(function (a, b) {
  //   //   var dateA = new Date(a.date),
  //   //     dateB = new Date(b.date);
  //   //   return dateA - dateB;
  //   // });
  //   // console.log(val);
  //   res.send("ok");
  // });
  // .sort({ "values.date": -1 })
  // .exec(function (val) {
  //   // console.log(val);
  //   res.send("ok");
  // });
  var o = {}; // empty Object
  o = []; // empty Array, which you can push() values into
  var ok = true;
  var j = 0;
  var str = req.get("Authorization");
  console.log("new request");
  try {
    var email = jwt.verify(str, KEY, { algorithm: "HS256" }).email;
    // console.log(email);
    users
      .findOne({ email: email }, function (err, user) {
        // console.log("user=" + user);
        //renvoie le user trouvé
        if (user.modules.length == 0) {
          console.log();
          res.json(o);
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
          // for (let [key, module] of Object.entries(user.modules)) {
          //   for (let [key, sensor] of Object.entries(module.sensors)) {
          //     for (let [key, sensorData] of Object.entries(sensor.sensorData)) {
          //       // var val=sensorData;
          //       // console.log("val=%j",val)
          //       // val=0
          //       // console.log("val=%j",val)

          //       // console.log("value:" + sensorData.data);
          //       // sensorData.data = 0;
          //       console.log("value:" + sensorData.data);
          //       dataIdTab.push(sensorData.data);
          //       // datas.findOne({ _id: sensorData.data }, function (err, result) {
          //       //   result.values.sort(custom_sort);
          //       //   sensorData.data = result.values[0];
          //       // });
          //       // value3.data = myTab;
          //     }
          //   }
          // }
          console.log("%j", user);
          // console.log("dataIdTab="+dataIdTab)
          // dataIdTab.forEach(element => {
          //   datas
          // });
          // console.log("%j", user);
          res.send(user.modules);
        }
      });
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
mongo.connectDB();
