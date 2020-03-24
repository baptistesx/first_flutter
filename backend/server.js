var express = require("express");
var app = express();
var http = require("http");
var bodyParser = require("body-parser");
var mongo = require("./project_modules/mongo_mod");
var users = require("./project_modules/models/userSchema").users;
var modules = require("./project_modules/models/modulesSchema").modules;
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
    }
    else{
        console.error("can't create user " + req.body.email);
        res.status(409);
        console.log("mauvais format email");
        
        res.send("mauvais format email");
    }
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

app.get("/api/user/modules",function (req, res) {

    var str = req.get("Authorization");
    try {
        var email = jwt.verify(str, KEY, { algorithm: "HS256" }).email;

        users.findOne({email:email},function (err, user) { 
            console.log(user.modules);
            res.send(user.modules)
         })
        // res.send("Very Secret Data");
    } catch {
        res.status(401);

        res.send("Bad Token");
    }
});

app.post("api/user/addModule", function (req, res) { 

 })

// Démarrage du serveur
http.createServer(app).listen(process.env.PORT || 8080, function() {
    return console.log(
        "Started user authentication server listening on port 8080"
    );
});
mongo.connectDB();
