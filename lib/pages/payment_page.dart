import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:paymob_payment/paymob_payment.dart';

class PaymentPage extends StatefulWidget {
  static const String id = 'PaymentPage';
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Center(child: const Text('Payment Method')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Content of your page
            Text('Payment Page'),

            const SizedBox(height: 20),

            ListTile(
               tileColor: const Color.fromARGB(255, 234, 231, 231),
              title: const Text('Card'),
              trailing: const Icon(Icons.circle,color: Colors.grey,),
              onTap: () async {
                // Initialize PaymobPayment
                PaymobPayment.instance.initialize(
                  apiKey: dotenv.env['apiKey']!,
                  integrationID: int.parse(dotenv.env['integrationID']!),
                  iFrameID: int.parse(dotenv.env['iFrameID']!),
                );

                // Make Payment
                final PaymobResponse? response =
                    await PaymobPayment.instance.pay(
                  context: context,
                  currency: "EGP",
                  amountInCents: "20000", // 200 EGP
                );

                if (response != null) {
                  print('Response: ${response.transactionID}');
                  print('Response: ${response.success}');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
