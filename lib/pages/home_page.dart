import 'package:edu_vista_app/pages/all_categories.dart';
import 'package:edu_vista_app/utils/color.utility.dart';
import 'package:edu_vista_app/widgets/bottom_bar_widget.dart';
import 'package:edu_vista_app/widgets/categories_widget.dart';
import 'package:edu_vista_app/widgets/courses_widget.dart';
import 'package:edu_vista_app/widgets/label_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:paymob_payment/paymob_payment.dart';


class HomePage extends StatefulWidget {
  static const String id = 'HomePage';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome Back! ${FirebaseAuth.instance.currentUser?.displayName}',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                LabelWidget(
                  name: 'Categories',
                  onSeeAllClicked: () {
                    Navigator.pushNamed(context, AllCategories.id);
                  },
                ),
                CategoriesWidget(),
                const SizedBox(height: 20),
                LabelWidget(
                  name: 'Top Rated Courses',
                  onSeeAllClicked: () {},
                ),
                const CoursesWidget(rankValue: 'top rated'),
                const SizedBox(height: 20),
                LabelWidget(
                  name: 'Top Seller Courses',
                  onSeeAllClicked: () {},
                ),
                const CoursesWidget(rankValue: 'top seller'),
                         ElevatedButton(
                    onPressed: () async {
                      PaymobPayment.instance.initialize(
                        apiKey: dotenv.env[
                            'apiKey']!, // from dashboard Select Settings -> Account Info -> API Key
                        integrationID: int.parse(dotenv.env[
                            'integrationID']!), // from dashboard Select Developers -> Payment Integrations -> Online Card ID
                        iFrameID: int.parse(dotenv.env[
                            'iFrameID']!), // from paymob Select Developers -> iframes
                      );

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
                    child: Text('paymob pay'))
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBarWidget(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
