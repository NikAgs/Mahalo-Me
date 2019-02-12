'use strict';

const functions = require('firebase-functions');
const randomId = require('random-id');
const logging = require('@google-cloud/logging')();
const stripe = require('stripe')(functions.config().stripe.token);
const currency = functions.config().stripe.currency || 'USD';
const admin = require('firebase-admin');
var request = require('request');

admin.initializeApp();

var db = admin.firestore();

exports.addExpressID = functions.https.onRequest(async(req, res) => {
  
  const code = req.query.code;
  const id = req.query.state;

  console.log("Auth code from Stripe Connect: " + code);
  console.log("UserID from Stripe Connect: " + id);

  var dataString = 'client_secret=' + functions.config().stripe.token + '&code=' + code + '&grant_type=authorization_code';

  var options = {
      url: 'https://connect.stripe.com/oauth/token',
      method: 'POST',
      body: dataString
  };

  function callback(error, response, body) {
      if (!error && response.statusCode === 200) {
          console.log("Response from Stripe Connect Handshake: " + body);
          body = JSON.parse(body);

          if (body.error) {
            res.write(`<html lang="en">
            <head>
              <meta charset="utf-8" />
              <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
              <meta name="viewport" content="width=device-width, initial-scale=1">
              <title></title>
              <link href='https://fonts.googleapis.com/css?family=Lato:300,400|Montserrat:700' rel='stylesheet' type='text/css'>
              <style>
                @import url(//cdnjs.cloudflare.com/ajax/libs/normalize/3.0.1/normalize.min.css);
                @import url(//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css);
              </style>
              <link rel="stylesheet" href="https://2-22-4-dot-lead-pages.appspot.com/static/lp918/min/default_thank_you.css">
              <script src="https://2-22-4-dot-lead-pages.appspot.com/static/lp918/min/jquery-1.9.1.min.js"></script>
              <script src="https://2-22-4-dot-lead-pages.appspot.com/static/lp918/min/html5shiv.js"></script>
            </head>
            <body>
              <header class="site-header" id="header">
                <h1 class="site-header__title" data-lead-id="site-header-title">Oh No!</h1>
              </header>
              <div class="main-content">
                <i class="fa fa-close main-content__checkmark" id="checkmark" style="color: red"></i>
                <p class="main-content__body" data-lead-id="main-content-body">There was a problem with setting up your bank information. Please try again in a little while.</p>
              </div>
            </body>
            </html>`);
          } else {

            const accountID = body.stripe_user_id;
            console.log("Stripe Connect Account ID: " + accountID);

            (db.collection('users').doc(id).set({
              account_id: accountID
            }, { merge: true }));
            
            res.write(`<html lang="en">
            <head>
              <meta charset="utf-8" />
              <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
              <meta name="viewport" content="width=device-width, initial-scale=1">
              <title></title>
              <link href='https://fonts.googleapis.com/css?family=Lato:300,400|Montserrat:700' rel='stylesheet' type='text/css'>
              <style>
                @import url(//cdnjs.cloudflare.com/ajax/libs/normalize/3.0.1/normalize.min.css);
                @import url(//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css);
              </style>
              <link rel="stylesheet" href="https://2-22-4-dot-lead-pages.appspot.com/static/lp918/min/default_thank_you.css">
              <script src="https://2-22-4-dot-lead-pages.appspot.com/static/lp918/min/jquery-1.9.1.min.js"></script>
              <script src="https://2-22-4-dot-lead-pages.appspot.com/static/lp918/min/html5shiv.js"></script>
            </head>
            <body>
              <header class="site-header" id="header">
                <h1 class="site-header__title" data-lead-id="site-header-title">THANK YOU!</h1>
              </header>
              <div class="main-content">
                <i class="fa fa-check main-content__checkmark" id="checkmark"></i>
                <p class="main-content__body" data-lead-id="main-content-body">Your bank information has been updated. Keep in mind, it may take a few minutes before you can withdraw from your MahaloMe balance.</p>
              </div>
            </body>
            </html>`);
          }
          
          res.end();
      }
  }

  request(options, callback);

});

exports.generateMahaloMeID = functions.auth.user().onCreate(async (user) => {

  var len = 6;
  var pattern = 'A0';

  // Couldn't figure out how to make this work. We want to check if the randomly
  // generated ID already matches up with a user before using it

  // let generateID = function (id) {
  //   var docRef = db.collection('users').doc(id);
  //   docRef.get()
  //     .then((docSnapshot) => {
  //       if (docSnapshot.exists) {
  //         return generateID(randomId(len, pattern));
  //       } else {
  //         return id;
  //       }
  //     })
  //     .catch((err) => {
  //       if (err) {
  //         console.log("Uhoh there was a problem generating a random ID");
  //       }
  //     });
  // };


  // Generate MahaloMe ID
  var id = randomId(len, pattern);
  console.log("ID generated: " + id);

  await (db.collection('users').doc(id).set({
    email: user.email.toString(),
    uid: user.uid.toString()
  }));

  await (admin.auth().updateUser(user.uid, {
    displayName: id
  }));

  // the user starts with no money
  await (db.collection('balances').doc(id).set({
    balance: 0,
    uid: user.uid.toString()
  }));

  // Create Stripe User
  var customer = await (stripe.customers.create({ email: user.email }));
  await (db.collection('users').doc(id).set({
    customer_id: customer.id
  }, { merge: true }));

  console.log('Created user with user id: ' + id);

  return id;
});


// Charge the Stripe customer whenever an amount is written to the Realtime database
exports.createStripeCharge = functions.firestore.document('users/{userId}/charges/{id}').onCreate(async (snap, context) => {
  const val = snap.data();
  try {
    // Look up the Stripe customer id written in createStripeCustomer
    const snapshot = await admin.firestore().collection(`users`).doc(context.params.userId).get()
    const snapval = snapshot.data();
    const customer = snapval.customer_id
    // Create a charge using the pushId as the idempotency key
    // protecting against double charges
    const amount = val.amount;
    const idempotencyKey = context.params.id;
    const charge = { amount, currency, customer };
    if (val.source !== null) {
      charge.source = val.source;
    }
    const response = await stripe.charges.create(charge, { idempotency_key: idempotencyKey });

    var balance = (await db.collection('balances').doc(context.params.userId).get()).data().balance;

    await (db.collection('balances').doc(context.params.userId).set({
      balance: balance + (amount / 100)
    }, { merge: true }));

    console.log("Changed user: " + context.params.userId + " balance to " + balance + (amount / 100));
    // If the result is successful, write it back to the database
    return snap.ref.set(response, { merge: true });
  } catch (error) {
    // We want to capture errors and render them in a user-friendly way, while
    // still logging an exception with StackDriver
    console.log(error);
    await snap.ref.set({ error: userFacingMessage(error) }, { merge: true });
    return reportError(error, { user: context.params.userId });
  }
});

// Create a destination charge to payout user whenever a withdraw is posted to the database
exports.payUser = functions.firestore.document('users/{userId}/withdraws/{id}').onCreate(async (snap, context) => {
  try {
    // Look up the Stripe account id
    const snapshot = await admin.firestore().collection(`users`).doc(context.params.userId).get()
    const amount = snap.data().amount;
    console.log("Amount being withdrawn: " + amount);
    
    const accountID = snapshot.data().account_id;
    console.log("Account ID: " + accountID);

    var balance = (await db.collection('balances').doc(context.params.userId).get()).data().balance;
    console.log("Account balance before withdraw: " + balance);

    if (amount > balance) {
      return await snap.ref.set({ error: "Balance isn't high enough" }, { merge: true });
    }

    var charge = await stripe.charges.create({
      amount: amount * 100,
      currency: "usd",
      source: "tok_visa",
      destination: {
        account: accountID,
      },
    });

    console.log("Charge: " + JSON.stringify(charge, null, 2));

    await (db.collection('balances').doc(context.params.userId).set({
      balance: balance - amount
    }, { merge: true }));
 
    console.log("Changed user: " + context.params.userId.toString() + " balance to " + (balance - amount).toString());

    return await snap.ref.set({ message: "Success" }, { merge: true });

  } catch (error) {
    // We want to capture errors and render them in a user-friendly way, while
    // still logging an exception with StackDriver
    console.log(error);
    await snap.ref.set({ error: userFacingMessage(error) }, { merge: true });
    return reportError(error, { user: context.params.userId });
  }
});

// Add a payment source (card) for a user by writing a stripe payment source token to Realtime database
exports.addPaymentSource = functions.firestore.document('/users/{userId}/tokens/{pushId}').onCreate(async (snap, context) => {
  const source = snap.data();
  const token = source.token;
  if (source === null) {
    return null;
  }

  try {
    const snapshot = await admin.firestore().collection('users').doc(context.params.userId).get();
    const customer = snapshot.data().customer_id;
    const response = await stripe.customers.createSource(customer, { source: token });
    return admin.firestore().collection('users').doc(context.params.userId).collection("sources").doc(response.id).set(response, { merge: true });
  } catch (error) {
    await snap.ref.set({ 'error': userFacingMessage(error) }, { merge: true });
    return reportError(error, { user: context.params.userId });
  }
});

// Delete a payment source (card) for a user
exports.deletePaymentSource = functions.firestore.document('/users/{userId}/deleted/{pushId}').onCreate(async (snap, context) => {
  const customerId = snap.data().customerId;
  const sourceId = snap.data().sourceId;

  admin.firestore().collection('users').doc(context.params.userId).collection('deleted').doc(context.params.pushId).delete();
  admin.firestore().collection('users').doc(context.params.userId).collection('sources').doc(sourceId).delete();

  stripe.customers.deleteSource(
    customerId,
    sourceId,
    (err, source) => {
      if (err) console.log('There was a problem deleting the credit card');
      return console.log('Deleted source: ' + source.id);
    }
  );
});

// When a user deletes their account, clean up after them
exports.cleanupUser = functions.auth.user().onDelete(async (user) => {
  try {
    const snapshot = await admin.database().ref('/users/' + user.displayName).once('value');
    const customerId = snapshot.val().customer_id;
    console.log('Deleting Stripe user: ' + customerId);
    stripe.customers.del(customerId);
  } finally {
    await admin.firestore().collection('users').doc(user.displayName).set();
    admin.firestore().collection('users').doc(user.displayName).delete();
  }
});

// Transfers money between 2 users by adjusting their balances accordingly
exports.transferMoney = functions.firestore.document('/users/{userId}/transfers/{pushId}').onCreate(async (snap, context) => {
  const sender = context.params.userId;
  const receiver = snap.data().receiver;
  const amount = Number(snap.data().amount);
  const errorLocation = db.collection('users').doc(sender).collection('transfers').doc(context.params.pushId);

  try {
    if (isNaN(amount) || (amount < 0)) {
      return errorLocation.set({
        error: "Amount must be > 0"
      }, { merge: true });
    }

    const senderBalance = Number((await db.collection('balances').doc(sender).get()).data().balance);
    const receiverBalance = Number((await db.collection('balances').doc(receiver).get()).data().balance);

    if (senderBalance < amount) {
      return errorLocation.set({
        error: "Your balance isn't high enough to send $" + amount
      }, { merge: true });
    }

    await db.collection('balances').doc(receiver).set({
      balance: receiverBalance + amount
    }, { merge: true });

    await db.collection('balances').doc(sender).set({
      balance: senderBalance - amount
    }, { merge: true });


    await db.collection('users').doc(receiver).collection('received').add({
      sender: sender,
      amount: amount,
      timestamp: new Date()
    });

    await db.collection('users').doc(sender).collection('transfers').doc(context.params.pushId).set({
      timestamp: new Date()
    }, { merge: true });

    return db.collection('users').doc(sender).collection('sent').add({
      amount: amount,
      receiver: receiver,
      timestamp: new Date()
    });

  } catch (e) {
    console.log(e);
    return errorLocation.set({
      error: "There was a problem transferring to MahaloMe user: " + receiver
    }, { merge: true });
  }
});


// To keep on top of errors, we should raise a verbose error report with Stackdriver rather
// than simply relying on console.error. This will calculate users affected + send you email
// alerts, if you've opted into receiving them.
function reportError(err, context = {}) {
  // This is the name of the StackDriver log stream that will receive the log
  // entry. This name can be any valid log stream name, but must contain "err"
  // in order for the error to be picked up by StackDriver Error Reporting.
  const logName = 'errors';
  const log = logging.log(logName);

  // https://cloud.google.com/logging/docs/api/ref_v2beta1/rest/v2beta1/MonitoredResource
  const metadata = {
    resource: {
      type: 'cloud_function',
      labels: { function_name: process.env.FUNCTION_NAME },
    },
  };

  // https://cloud.google.com/error-reporting/reference/rest/v1beta1/ErrorEvent
  const errorEvent = {
    message: err.stack,
    serviceContext: {
      service: process.env.FUNCTION_NAME,
      resourceType: 'cloud_function',
    },
    context: context,
  };

  // Write the error log entry
  return new Promise((resolve, reject) => {
    log.write(log.entry(metadata, errorEvent), (error) => {
      if (error) {
        return reject(error);
      }
      return resolve();
    });
  });
}


// Sanitize the error message for the user
function userFacingMessage(error) {
  return error.type ? error.message : 'An error occurred, developers have been alerted';
}