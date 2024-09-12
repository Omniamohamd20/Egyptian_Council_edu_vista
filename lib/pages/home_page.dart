import 'package:edu_vista_app/pages/all_categories.dart';
import 'package:edu_vista_app/utils/color.utility.dart';
import 'package:edu_vista_app/widgets/bottom_bar_widget.dart';
import 'package:edu_vista_app/widgets/categories_widget.dart';
import 'package:edu_vista_app/widgets/courses_widget.dart';
import 'package:edu_vista_app/widgets/label_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


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
