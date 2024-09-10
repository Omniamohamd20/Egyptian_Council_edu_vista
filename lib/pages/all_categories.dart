import 'package:edu_vista_app/widgets/categories_open_widget.dart';
import 'package:edu_vista_app/widgets/categories_widget.dart';
import 'package:edu_vista_app/widgets/label_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class  AllCategories extends StatefulWidget {
  static const String id = 'AllCategories';

  const AllCategories({super.key});


  @override
  State< AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State< AllCategories> {
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
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
          ),]
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // Added SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                LabelWidget(
                  name: 'Categories',
                  onSeeAllClicked: () {},
                ),
                const CategoriesOpenWidget(),
                const SizedBox(
                  height: 20,
                ),
           
            
              ],
            ),
          ),
        ),
      ),
    );
  }
}
