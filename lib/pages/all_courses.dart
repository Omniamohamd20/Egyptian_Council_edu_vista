import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista_app/blocs/course/course_bloc.dart';
import 'package:edu_vista_app/models/course.dart';
import 'package:edu_vista_app/pages/course_details_page.dart';
import 'package:edu_vista_app/utils/color.utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllCourses extends StatefulWidget {
  static const String id = 'AllCourses';
  final String category_id;

  const AllCourses({
    super.key,
    required this.category_id,
  });

  @override
  State<AllCourses> createState() => _AllCoursesState();
}

class _AllCoursesState extends State<AllCourses> {
  late Future<QuerySnapshot<Map<String, dynamic>>> futureCall;

  @override
  void initState() {
    print(widget.category_id);

    futureCall = FirebaseFirestore.instance
        .collection('courses')
        // .where('qLwLBJM0Fdw5OrIY48Rh', isEqualTo: widget.category_id)
        .get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Add Scaffold here
      appBar: AppBar(
        title: Text('All Courses'),
      ),
      body: FutureBuilder(
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

          return GridView.count(
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            shrinkWrap: true,
            crossAxisCount: 2,
            children: List.generate(courses.length, (index) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    CourseDetailsPage.id,
                    arguments: courses[index],
                  );
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
                          borderRadius: BorderRadius.circular(40.0),
                          child: Image.network(
                            courses[index].image ?? 'image error',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Rating
                      Row(
                        children: [
                          const SizedBox(width: 20),
                          Text((courses[index].rating ?? 0.0).toString()),
                          const SizedBox(width: 5),
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
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('courses')
                                          .doc(courses[index].id)
                                          .update({'rating': indexEx + 1});
                                    },
                                  );
                                }),
                              );
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 20),
                          Text(
                            courses[index].title ?? 'No Name',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 15),
                          const Icon(Icons.person),
                          Text(courses[index].instructor?.name ?? 'No Name'),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 20),
                          Text(
                            '\$${(courses[index].price ?? 0.0).toStringAsFixed(2)}',
                            style: TextStyle(
                              color: ColorUtility.main,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
