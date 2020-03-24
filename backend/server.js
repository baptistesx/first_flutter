var express = require("express");
var path = require("path");
jwt = require("jsonwebtoken");
var crypto = require("crypto");
var app = express(); // creation du serveur
app.set("views", path.join("public/views"));
var mustacheExpress = require("mustache-express");

app.engine("mustache", mustacheExpress());
app.set("view engine", "mustache");

app.post("/login", (req, res) => {
  console.log(req.query);
  console.log(req.query);

  res.status(200).send({ email: "world", pwd: "szdzedzedz" });
});

var server = app.listen(8080); // démarrage du serveur sur le port 8080

console.log("Serveur démarré sur le port 8080");
