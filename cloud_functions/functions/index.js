const functions = require('firebase-functions');
const randomId = require('random-id');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp();

var db = admin.firestore();


exports.generateMahaloMeID = functions.auth.user().onCreate((user) => {

  var id = randomId(6, 'A0');
  var docRef = db.collection('users').doc(id);

  docRef.set({
    email: user.email
  });

  admin.auth().updateUser(user.uid, {
    displayName: id
  });

  console.log('created user with user id: ' + id);

  return id;
});


