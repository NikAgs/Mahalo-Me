'use strict';

const functions = require('firebase-functions');
const randomId = require('random-id');
const logging = require('@google-cloud/logging')();
const stripe = require('stripe')(functions.config().stripe.token);
const currency = functions.config().stripe.currency || 'USD';
const admin = require('firebase-admin');

admin.initializeApp();

var db = admin.firestore();

exports.generateMahaloMeID = functions.auth.user().onCreate(async (user) => {

  var len = 6;
  var pattern = 'A0';
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
    email: user.email.toString()
  }));

  await (db.collection('users').doc(id).set({
    uid: user.uid.toString()
  }, { merge: true }));

  await (admin.auth().updateUser(user.uid, {
    displayName: id
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
  await admin.firestore().collection('users').doc(user.displayName).delete();
  const snapshot = await admin.database().ref('/users/' + user.displayName).once('value');
  const customerId = snapshot.val().customer_id;
  console.log('Deleting Stripe user: ' + customerId);
  return stripe.customers.del(customerId);
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