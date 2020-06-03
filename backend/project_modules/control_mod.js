var users = require("./models/userSchema").users;
var modules = require("./models/modulesSchema").modules;



//Vérifie si un utilisateur avec l'email reçue en paramètre existe
module.exports.userExists = function (email, callback) {
    try {
        if (email != null) {
            users.findOne({
                email: email
            }, function (err, user) {
                if (err) {
                    throw new Error("User unknown")
                } else {
                    callback(user);
                }
            });
        } else {
            throw new Error("Bad Token")
        }
    } catch (e) {
        console.error("error : ", e.message);
    }

};

//------------ Vérifications pour l'ajout d'un module ------------
//Vérification qu'un module match avec les IDs reçus
module.exports.moduleExists = function (publicID, privateID, callback) {
    try {
        modules.findOne({
            publicID: publicID,
            privateID: privateID
        }, function (
            err,
            module
        ) {
            if (err) {
                //Les IDs ne matchent pas => le module correspondant n'existe pas
                throw new Error("This module doesn't exist. Try again.")
            } else {
                callback(module);
            }
        });
    } catch (e) {
        console.error("error : ", e.message);
    }
}

//Vérifie si l'utilisateur a déjà ajouté ce module
module.exports.userOwnsThisModule = function (user, module, callback) {
    if(user.modules.includes(module._id)){
        //Cas 1: module déjà ajouté
        throw new Error("You've already added this module.");
    }
    else{
        //Cas 2: module non encore ajouté
        callback()
    }
}

//Vérifie si le module est déjà associé à un utilisateur
module.exports.isModuleUsed = function (module, callback) {
    if(module.used){
        //Cas 1: module ajouté par un autre utilisateur
        throw new Error("This module isn't available.");
    }
    else{
        //Cas 2: module disponible
        callback()
    }
}