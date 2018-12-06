import 'package:stripe_api/stripe_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../global.dart';

Future<void> addCreditCard(
    String number, String expDate, String cvv, String postalCode) async {
  Stripe.init('pk_test_vrAU1Vlga7ystZleoAsLBub8');
  number = number.replaceAll(' ', "");
  int month = int.parse(expDate.substring(0, 2));
  int year = int.parse(expDate.substring(3));

  StripeCard card =
      new StripeCard(number: number, cvc: cvv, expMonth: month, expYear: year);

  Stripe.instance.createCardToken(card).then((c) {
    Firestore.instance
        .collection('users')
        .document(firebaseUser.displayName)
        .collection('tokens')
        .add({'token': c.id});
  }).catchError((error) {
    print(error);
  });
}

Future<void> deleteCreditCard(customerId, sourceId) async {
  Firestore.instance
      .collection('users')
      .document(firebaseUser.displayName)
      .collection('deleted')
      .add({"sourceId": sourceId, "customerId": customerId});
}

Future<void> chargeCard(amount) async {
  try {
    var source = (await Firestore.instance
            .collection('users')
            .document(firebaseUser.displayName)
            .collection('sources')
            .getDocuments())
        .documents[0]
        .data["id"];

    await Firestore.instance
        .collection('users')
        .document(firebaseUser.displayName)
        .collection('charges')
        .add({"amount": amount, "source": source});
  } catch (e) {
    print("There was a problem with charging the user");
  }
}
