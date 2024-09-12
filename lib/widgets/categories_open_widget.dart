import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista_app/models/category.dart';
import 'package:edu_vista_app/widgets/courses_widget.dart';
import 'package:edu_vista_app/widgets/courses_widget_by_Categories.dart';
import 'package:flutter/material.dart';

class CategoriesOpenWidget extends StatefulWidget {
  const CategoriesOpenWidget({super.key});

  @override
  State<CategoriesOpenWidget> createState() => _CategoriesOpenWidgetState();
}

class _CategoriesOpenWidgetState extends State<CategoriesOpenWidget> {
  var futureCall = FirebaseFirestore.instance.collection('categories').get();
  int? openedCategoryIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400, // Adjust height as needed
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

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    title: Text(categories[index].name ?? 'no name'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      setState(() {
                        // Toggle the opened category index
                        openedCategoryIndex =
                            openedCategoryIndex == index ? null : index;
                      });
                    },
                  ),
                  // Only show CoursesWidget for the selected category
                  if (openedCategoryIndex == index)
                    CoursesWidgetByCategories(categoryId: categories[index].id??''),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
