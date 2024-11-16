import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future createPaymentIntent({
  required String name,
  required String address,
  required String pin,
  required String city,
  required String state,
  required String country,
  required String currency,
  required String amount,
}) async {
  print("Enter inside createPaymentIntent");
  final url = Uri.parse("https://api.stripe.com/v1/payment_intents");
  final secretKey = dotenv.env['STRIPE_SECR_KEY'];
  final body = {
    "amount": amount,
    "currency": currency.toLowerCase(),
    "automatic_payment_methods[enabled]": "true",
    "description": "Test Donation",
    "shipping[name]": name,
    "shipping[address][line1]": address,
    "shipping[address][postal_code]": pin,
    "shipping[address][city]": city,
    "shipping[address][state]": state,
    "shipping[address][country]": country,
  };
  print("Before sending the request");
  final response = await http.post(
    url,
    headers: {
      "Authorization": "Bearer $secretKey",
      "Content-Type": "application/x-www-form-urlencoded"
    },
    body: body,
  );
  print("Response status: ${response}");
  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    print(json);
    return json;
  } else {
    print(response.body);
    return null;
  }
}
