import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/payment.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  TextEditingController amountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();
  final formKey4 = GlobalKey<FormState>();
  final formKey5 = GlobalKey<FormState>();
  final formKey6 = GlobalKey<FormState>();

  List<String> currencyList = ['USD', 'INR', 'EUR', 'GBP', 'AUD', 'CAD'];
  String selectedCurrency = 'USD';

  bool hasDonated = false;

  Future<void> initPaymentSheet() async {
    try {
      // 1. create payment intent on the server
      final data = await createPaymentIntent(
          name: nameController.text,
          address: addressController.text,
          pin: pincodeController.text,
          city: cityController.text,
          state: stateController.text,
          country: countryController.text,
          currency: selectedCurrency,
          amount: amountController.text);

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: 'Test Merchant',
          paymentIntentClientSecret: data['client_secret'],
          // Customer keys
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['id'],
          style: ThemeMode.dark,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image(
              image: AssetImage("assets/image.jpg"),
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            hasDonated
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Thank you for ${amountController.text} $selectedCurrency donation",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Your donation will help us to continue our work',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent.shade400,
                              ),
                              child: Text(
                                'Donate again',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () => setState(() {
                                hasDonated = false;
                                amountController.clear();
                              }),
                            )),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Support us with donation',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: ResuableTextField(
                                  hint: 'Any amount is appreciated',
                                  controller: amountController,
                                  formKey: formKey,
                                  title: 'Donation Amount',
                                  isNumber: true),
                            ),
                            SizedBox(width: 10),
                            DropdownMenu<String>(
                              dropdownMenuEntries:
                                  currencyList.map<DropdownMenuEntry<String>>(
                                (String value) {
                                  return DropdownMenuEntry<String>(
                                    value: value,
                                    label: value,
                                  );
                                },
                              ).toList(),
                              inputDecorationTheme: InputDecorationTheme(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 00, vertical: 10),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade600))),
                              initialSelection: currencyList.first,
                              onSelected: (String? value) => setState(() {
                                selectedCurrency = value!;
                              }),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        ResuableTextField(
                            hint: 'Ex: John Doe',
                            controller: nameController,
                            formKey: formKey1,
                            title: 'Name',
                            isNumber: false),
                        SizedBox(height: 10),
                        ResuableTextField(
                            hint: 'Ex: 123, Main Street',
                            controller: addressController,
                            formKey: formKey2,
                            title: 'Address Line',
                            isNumber: false),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: ResuableTextField(
                                  hint: 'Ex: Abidjan',
                                  controller: cityController,
                                  formKey: formKey3,
                                  title: 'City',
                                  isNumber: false),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 5,
                              child: ResuableTextField(
                                  hint: 'State',
                                  controller: stateController,
                                  formKey: formKey4,
                                  title: 'Ex: Lagunes',
                                  isNumber: false),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: ResuableTextField(
                                  hint: 'Ex: In for CIV',
                                  controller: countryController,
                                  formKey: formKey5,
                                  title: 'Country (Short Code)',
                                  isNumber: false),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 5,
                              child: ResuableTextField(
                                  hint: 'Ex: 123456',
                                  controller: pincodeController,
                                  formKey: formKey6,
                                  title: 'PinCode',
                                  isNumber: true),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent.shade400,
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate() &&
                                  formKey1.currentState!.validate() &&
                                  formKey2.currentState!.validate() &&
                                  formKey3.currentState!.validate() &&
                                  formKey4.currentState!.validate() &&
                                  formKey5.currentState!.validate() &&
                                  formKey6.currentState!.validate()) {
                                await initPaymentSheet();
                                try {
                                  await Stripe.instance.presentPaymentSheet();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      'Payment Successful',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.green,
                                  ));
                                  nameController.clear();
                                  addressController.clear();
                                  cityController.clear();
                                  stateController.clear();
                                  countryController.clear();
                                  pincodeController.clear();
                                  amountController.clear();
                                  setState(() {
                                    hasDonated = true;
                                  });
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error: $e')),
                                  );
                                }
                              }
                            },
                            child: Text(
                              'Donate',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
