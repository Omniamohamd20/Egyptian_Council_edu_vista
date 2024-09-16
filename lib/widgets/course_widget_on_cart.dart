import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista_app/blocs/course/course_bloc.dart';
import 'package:edu_vista_app/models/course.dart';
import 'package:edu_vista_app/pages/payment_page.dart';
import 'package:edu_vista_app/utils/color.utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  List<Course> coursesInCart = [];

  @override
  void initState() {
    super.initState();
    futureCall = FirebaseFirestore.instance
        .collection('courses')
        .where('users_buys',
            arrayContains: FirebaseAuth.instance.currentUser?.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureCall,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error occurred'));
        }

        if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? false)) {
          return const Center(child: Text('No courses found'));
        }

        coursesInCart = List<Course>.from(snapshot.data?.docs
                .map((e) => Course.fromJson({'id': e.id, ...e.data()}))
                .toList() ??
            []);

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: coursesInCart.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 0,
                      color: ColorUtility.scaffoldBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                coursesInCart[index].image ?? 'no image',
                                width: 220,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
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
                                          coursesInCart[index].title ??
                                              'no Title',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: ColorUtility.gry,
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
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.person_2_rounded,
                                            color: ColorUtility.gry),
                                        Text(
                                          coursesInCart[index]
                                                  .instructor
                                                  ?.name ??
                                              'no name',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: ColorUtility.gry,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                            (coursesInCart[index].rating ?? 0.0)
                                                .toString()),
                                        SizedBox(width: 10),
                                        BlocBuilder<CourseBloc, CourseState>(
                                          builder: (ctx, state) {
                                            return Row(
                                              children:
                                                  List.generate(5, (indexEx) {
                                                return IconButton(
                                                  iconSize: 15,
                                                  icon: Icon(
                                                    indexEx.toDouble() <
                                                            (coursesInCart[
                                                                        index]
                                                                    .rating ??
                                                                0.0)
                                                        ? Icons.star
                                                        : Icons.star_border,
                                                    color: ColorUtility.main,
                                                  ),
                                                  padding: EdgeInsets.zero,
                                                  constraints: BoxConstraints(),
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection('courses')
                                                        .doc(
                                                            coursesInCart[index]
                                                                .id)
                                                        .update({
                                                      'rating': indexEx + 1,
                                                    });
                                                  },
                                                );
                                              }),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '\$${(coursesInCart[index].price ?? 0.0).toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: ColorUtility.main,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    if (openedButtonsIndex == index)
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: Size(110, 50),
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 175, 175, 175),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () {},
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: Size(110, 50),
                                              backgroundColor:
                                                  ColorUtility.secondary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, PaymentPage.id);
                                            },
                                            child: Text(
                                              'Buy Now',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
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
              ),
              Text(
                'Total Price: \$${calculateTotalPrice().toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }

  double calculateTotalPrice() {
    double total = 0.0;

    for (var item in coursesInCart) {
      double price = item.price ?? 0.0; // Default to 0.0 if price is null
      total += price;
    }

    return total;
  }
}
