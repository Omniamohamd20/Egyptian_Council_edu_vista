import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista_app/models/category.dart';
import 'package:edu_vista_app/pages/all_courses.dart';
import 'package:edu_vista_app/pages/course_details_page.dart';
import 'package:flutter/material.dart';


class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({super.key});

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  var futureCall = FirebaseFirestore.instance.collection('categories').get();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 40,
        child: FutureBuilder(
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
                  child: Text('No categories found'),
                );
              }

              var categories = List<Category>.from(snapshot.data?.docs
                      .map((e) => Category.fromJson({'id': e.id, ...e.data()}))
                      .toList() ??
                  []);

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (context, index) => const SizedBox(
                  width: 10,
                ),
                itemBuilder: (context, index) => InkWell(
                  onTap: () async {
                    Navigator.pushNamed(context, AllCourses.id,
                        arguments: categories[index].id
                        );
                    
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xffE0E0E0),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: Text(categories[index].name ?? 'No Name'),
                    ),
                  ),
                ),
              );
            }));
  }
}
