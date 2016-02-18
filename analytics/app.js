var DICT = {
    "1" : "nodejs",
    "2" : "ruby_on_rails",
    "3" : "django",
    "4" : "flask",
    "5" : "android_studio",
    "6" : "arduino"
};


var express = require('express');
var app = express();

var MongoClient = require('mongodb').MongoClient
, assert = require('assert');

// Connection URL
var url = 'mongodb://localhost:27017/analytics';
// Use connect method to connect to the Server
MongoClient.connect(url, function(err, db) {
    assert.equal(null, err);
    console.log("Connected correctly to server");

    db.close();
});

app.get('/', function (req, res) {
    var array = [];
    var dumpCount = function(arr) {
        var counting = [0, 0, 0, 0, 0, 0];
        for (var i = 0; i < arr.length; i++)
        {
            counting[arr[i].s]++;
            console.log(arr[i].selection);
            console.log(arr[i].appName);
        }
        var retString = "";
        for (var i = 1; i < 7; i++)
        {
            retString += DICT[i] + " : " + counting[i-1];
            retString += "\n";
        }
        retString += "\nTOTAL: " + arr.length;
        return retString;
    };
    MongoClient.connect(url, function(err, db) {
        var cursor = db.collection('documents').find( );
        cursor.each(function(err, doc) {
           assert.equal(err, null);
           if (doc != null) {
              array.push(doc);
           }
           else
           {
               res.write(dumpCount(array));
               res.end();
           }
        });
    });
});

app.get('/script', function(req, res, next){
    console.log(req.query);
    var s = req.query.s;
    var selection = DICT[s];
    var appName = req.query.appName;
    console.log(selection);
    console.log(appName)
    MongoClient.connect(url, function(err, db) {
        assert.equal(null, err);
        var collection = db.collection('documents');
        collection.insertOne({selection:selection, appName:appName, s:s});
        db.close();
        console.log("saved selection.");
    });
    res.send("thank you, startup script.");
});

app.listen(3000, function () {
    console.log('Example app listening on port 3000!');
});