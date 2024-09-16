import 'package:edu_vista_app/pages/courses_page.dart';
import 'package:edu_vista_app/pages/home_page.dart';
import 'package:edu_vista_app/pages/profile.dart';
import 'package:edu_vista_app/pages/search.dart';
import 'package:edu_vista_app/utils/color.utility.dart';
import 'package:flutter/material.dart';

class BottomBarWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  BottomBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  // Update the _onTap method to accept context
  void _onTap(BuildContext context, int index) {
    Navigator.of(context)
        .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
      return _children[index]; 
    }));
  }

  final List<Widget> _children = [
    HomePage(),
    CoursesPage(),
    Search(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: Colors.black),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_rounded, color: Colors.black),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search, color: Colors.black),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, color: Colors.black),
          label: '',
        ),
      ],
      currentIndex: currentIndex, // Use the currentIndex parameter
      selectedItemColor:
          ColorUtility.secondary, // Customize this color as needed
      onTap: (index) => _onTap(context, index), // Pass context and index
    );
  }
}
