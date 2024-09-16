import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:edu_vista_app/models/course.dart';
import 'package:edu_vista_app/utils/color.utility.dart';
import 'package:flutter/material.dart';


class HorizontalCoursesWidget extends StatefulWidget {
  const HorizontalCoursesWidget({super.key});

  @override
  State<HorizontalCoursesWidget> createState() =>
      _HorizontalCoursesWidgetState();
}

class _HorizontalCoursesWidgetState extends State<HorizontalCoursesWidget> {
  late Future<QuerySnapshot<Map<String, dynamic>>> futureCall;
  // late Future<QuerySnapshot<Map<String, dynamic>>> futureCall_1;

  @override
  void initState() {
    futureCall = FirebaseFirestore.instance.collection('courses').get();
  //  final futureCall_1 = FirebaseFirestore.instance
  //       .collection('course_user_progress')
  //       .doc(FirebaseAuth.instance.currentUser!.uid) // Correctly reference the document
  //       .get(); // Call .get() on the document reference
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureCall,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Error occurred'),
          );
        }

        if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? false)) {
          return const Center(
            child: Text('No courses found'),
          );
        }

        var courses = List<Course>.from(snapshot.data?.docs
                .map((e) => Course.fromJson({'id': e.id, ...e.data()}))
                .toList() ??
            []);
            

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 0, // Remove elevation
                color: ColorUtility.scaffoldBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10), // Optional: adjust border radius
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      // Course Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          courses[index].image ?? 'no image',
                          width: 250,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Course Details
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                courses[index].title ?? 'no name',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.person_2_rounded,
                                      color: ColorUtility.gry),
                                  Text(
                                    courses[index].instructor?.name ??
                                        'no name',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: ColorUtility.gry,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Progress Indicator
                              SizedBox(
                                width: 1200,
                                child: LinearProgressIndicator(
                                  value: 0.2, // Example progress value (20%)
                                  backgroundColor: ColorUtility.gry,
                                  color: ColorUtility.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
