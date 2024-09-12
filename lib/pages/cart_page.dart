import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
    static const String id = 'CartPage';


  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Center(child: const Text('categories')),
      ),
      body: Center(
        child: Text('data'),
      ),
    );
  }
}
