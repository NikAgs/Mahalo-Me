import 'package:stripe_api/stripe_api.dart';

Future<void> addCreditCard(
    String number, String expDate, String cvv, String postalCode) async {
  Stripe.init('pk_live_PtasgnsC5reW9HYygmXU4qlL');
  number = number.replaceAll(' ', "");
  int month = int.parse(expDate.substring(0, 2));
  int year = int.parse(expDate.substring(3));

  StripeCard card =
      new StripeCard(number: number, cvc: cvv, expMonth: month, expYear: year);

  Stripe.instance.createCardToken(card).then((c) {
    print(c.id);
  }).catchError((error) {
    print(error);
  });
}
