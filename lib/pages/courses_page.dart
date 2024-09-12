import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista_app/widgets/bottom_bar_widget.dart';
import 'package:edu_vista_app/widgets/horizontal_courses_widget.dart';
import 'package:flutter/material.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
   late Future<QuerySnapshot<Map<String, dynamic>>> futureCall;
  @override
  void initState() {
    futureCall = FirebaseFirestore.instance
        .collection('courses')
        .get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: const Center(
            child: Text('Courses'),
          )),
      body: 
       
         const Padding(
          padding: EdgeInsets.all(8.0),
        child:  HorizontalCoursesWidget()
         
        ),
         bottomNavigationBar: BottomBarWidget(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        )
    );
  }
}
