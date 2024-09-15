import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista_app/blocs/course/course_bloc.dart';
import 'package:edu_vista_app/models/cart.dart';
import 'package:edu_vista_app/models/course.dart';
import 'package:edu_vista_app/pages/course_details_page.dart';
import 'package:edu_vista_app/utils/color.utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseWidgetOnCart extends StatefulWidget {
  const CourseWidgetOnCart({super.key});

  @override
  State<CourseWidgetOnCart> createState() => _CourseWidgetOnCartState();
}

class _CourseWidgetOnCartState extends State<CourseWidgetOnCart> {
   int? openedButtonsIndex;
  late Future<QuerySnapshot<Map<String, dynamic>>> futureCall;

  @override
  void initState() {
    futureCall = FirebaseFirestore.instance.collection('cart').get();
    
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

        var coursesInCart = List<Cart>.from(snapshot.data?.docs
                .map((e) => Cart.fromJson({'id': e.id, ...e.data()}))
                .toList() ??
            []);

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: coursesInCart.length,
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
                      // ClipRRect(
                      //   borderRadius: BorderRadius.circular(10),
                      //   child: Image.network(
                      //     coursesInCart[index].course!.image ?? 'no image',
                      //     width: 220,
                      //     height: 120,
                      //     fit: BoxFit.cover,
                      //   ),
                      // ),
                      const SizedBox(width: 16),
                      // Course Details
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                        coursesInCart[index].nor ??'gg'
                                ,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {                               
                                             openedButtonsIndex =
                                              openedButtonsIndex == index
                                                  ? null
                                                  : index;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.arrow_drop_down_rounded,
                                        color: ColorUtility.main,
                                      ))
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.person_2_rounded,
                                      color: ColorUtility.gry),
                                  Text(
                                    coursesInCart[index].course?.instructor?.name ??
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
                              Row(
                                children: [
                                  Text((coursesInCart[index].course?.rating ?? 0.0)
                                      .toString()),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  BlocBuilder<CourseBloc, CourseState>(
                                      builder: (ctx, state) {
                                    return Row(
                                      children: List.generate(5, (indexEx) {
                                        return IconButton(
                                          iconSize: 15,
                                          icon: Icon(
                                            indexEx.toDouble() <
                                                    (coursesInCart[index].course?.rating ??
                                                        0.0)
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: ColorUtility.main,
                                          ),
                                          padding: EdgeInsets
                                              .zero, // Remove default padding
                                          constraints:
                                              BoxConstraints(), // Remove constraints to reduce space
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection(
                                                    'courses') // Replace with your collection name
                                                .doc(coursesInCart[index].id)
                                                .update({
                                              // 'rating':indexEx+1
                                              'rating': indexEx + 1
                                            });
                                          },
                                        );
                                      }),
                                    );
                                  }),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    '\$${(coursesInCart[index].course?.price ?? 0.0).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: ColorUtility.main,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10,),
                            if (openedButtonsIndex == index)
                                  Row(
                                      children: [
                                        ElevatedButton(
                                          style: 
                                           ElevatedButton.styleFrom(
                                             minimumSize: Size(110, 50),
                                          backgroundColor: const Color.fromARGB(255, 175, 175, 175),
                                           shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                10), // Rounded corners
                                          ),
                                           ),

                                            onPressed: () {},
                                            child: Text('cancel',
                                             style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                             ),
                                            )),
                                            SizedBox(width: 5,),
                                        ElevatedButton(
                                           style: ElevatedButton.styleFrom(
                                            minimumSize: Size(110, 50),

                                            backgroundColor: ColorUtility.secondary,
                                               shape: RoundedRectangleBorder(
                                                
                                            borderRadius: BorderRadius.circular(
                                                10), // Rounded corners
                                          ),
                                        ),
                                            onPressed: () {},
                                            child: Text('Buy now',
                                             style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                             ),
                                             
                                            )),
                                      ],
                                    )
                                  
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
