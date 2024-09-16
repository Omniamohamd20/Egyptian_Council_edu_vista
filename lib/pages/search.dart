import 'package:edu_vista_app/widgets/categories_widget.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State< Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            }),
       
        title: Center(child: Text('Search')),
      ),
      body: Center(
        child: CategoriesWidget(),
      ),
    
      
    );
  }
}