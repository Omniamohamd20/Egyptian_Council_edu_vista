import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista_app/blocs/course/course_bloc.dart';
import 'package:edu_vista_app/models/course.dart';
import 'package:edu_vista_app/pages/course_details_page.dart';
import 'package:edu_vista_app/utils/color.utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoursesWidget extends StatefulWidget {
  final String rankValue;

  const CoursesWidget({required this.rankValue, super.key});

  @override
  State<CoursesWidget> createState() => _CoursesWidgetState();
}

class _CoursesWidgetState extends State<CoursesWidget> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> streamCall;

  @override
  void initState() {
    super.initState();
    streamCall = FirebaseFirestore.instance
        .collection('courses')
        .where('rank', isEqualTo: widget.rankValue)
        .orderBy('created_date', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: streamCall,
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

        return GridView.count(
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          shrinkWrap: true,
          crossAxisCount: 2,
          children: List.generate(courses.length, (index) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, CourseDetailsPage.id,
                    arguments: courses[index]);
              },
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: const Color(0xffE0E0E0),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 135,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              40.0), // Match with decoration for rounded corners
                          child: Image.network(
                            courses[index].image ?? 'image error',
                            fit: BoxFit.cover, // Adjust the fit as needed
                          ),
                        ),
                      ),
                      //rating
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Text((courses[index].rating ?? 0.0).toString()),
                          SizedBox(
                            width: 5,
                          ),
                          BlocBuilder<CourseBloc, CourseState>(
                              builder: (ctx, state) {
                            return Row(
                              children: List.generate(5, (indexEx) {
                                return IconButton(
                                  iconSize: 15,
                                  icon: Icon(
                                    indexEx.toDouble() <
                                            (courses[index].rating ?? 0.0)
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: ColorUtility.main,
                                  ),
                                  padding:
                                      EdgeInsets.zero, // Remove default padding
                                  constraints:
                                      BoxConstraints(), // Remove constraints to reduce space
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection(
                                            'courses') // Replace with your collection name
                                        .doc(courses[index].id)
                                        .update({'rating': indexEx + 1});
                                  },
                                );
                              }),
                            );
                          }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            courses[index].title ?? 'No Name',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Icon(Icons.person),
                          Text(courses[index].instructor?.name ?? 'No Name'),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            '\$${(courses[index].price ?? 0.0).toStringAsFixed(2)}',
                            style: TextStyle(
                              color: ColorUtility.main,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          )
                        ],
                      ),
                    ]),
              ),
            );
          }),
        );
      },
    );
  }
}
