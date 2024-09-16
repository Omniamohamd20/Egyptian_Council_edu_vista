import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista_app/blocs/course/course_bloc.dart';
import 'package:edu_vista_app/models/course.dart';
import 'package:edu_vista_app/models/lecture.dart';
import 'package:edu_vista_app/utils/app_enums.dart';
import 'package:edu_vista_app/utils/color.utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseOptionsWidgets extends StatefulWidget {
  final CourseOptions courseOption;
  final Course course;
  final void Function(Lecture) onLectureChosen;
  const CourseOptionsWidgets(
      {required this.courseOption,
      required this.course,
      required this.onLectureChosen,
      super.key});

  @override
  State<CourseOptionsWidgets> createState() => _CourseOptionsWidgetsState();
}

class _CourseOptionsWidgetsState extends State<CourseOptionsWidgets> {
  late Future<QuerySnapshot<Map<String, dynamic>>> futureCall;

  @override
  void initState() {
    init();
    super.initState();
  }

  List<Lecture>? lectures;
  bool isLoading = false;
  void init() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 1200), () async {});
    if (!mounted) return;
    lectures = await context.read<CourseBloc>().getLectures();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Lecture? selectedLecture;

  @override
  Widget build(BuildContext context) {
    switch (widget.courseOption) {
      case CourseOptions.Lecture:
        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (lectures == null || (lectures!.isEmpty)) {
          return const Center(
            child: Text('No lectures found'),
          );
        } else {
          return GridView.count(
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            shrinkWrap: true,
            crossAxisCount: 2,
            children: List.generate(lectures!.length, (index) {
              return InkWell(
                onTap: () {
                  widget.onLectureChosen(lectures![index]);
                  selectedLecture = lectures![index];
                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: selectedLecture?.id == lectures![index].id
                        ? ColorUtility.secondary
                        : const Color(0xffE0E0E0),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              lectures![index].title ?? 'No Name',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      selectedLecture?.id == lectures![index].id
                                          ? Colors.white
                                          : Colors.black),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.file_download_outlined))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              lectures![index].description ?? 'No description',
                              style: TextStyle(
                                  color:
                                      selectedLecture?.id == lectures![index].id
                                          ? Colors.white
                                          : Colors.black),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Duration ${(lectures?[index].duration ?? 0.0).toStringAsFixed(0)} min',
                              style: TextStyle(
                                color:
                                    selectedLecture?.id == lectures![index].id
                                        ? Colors.white
                                        : Colors.black,
                              ),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                    Icons.play_circle_outline_outlined))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        }

      case CourseOptions.Download:
        return GridView.count(
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          shrinkWrap: true,
          crossAxisCount: 2,
          children: List.generate(lectures!.length, (index) {
            return InkWell(
              onTap: () {
                widget.onLectureChosen(lectures![index]);
                selectedLecture = lectures![index];
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: selectedLecture?.id == lectures![index].id
                      ? ColorUtility.secondary
                      : const Color(0xffE0E0E0),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            lectures![index].title ?? 'No Name',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color:
                                    selectedLecture?.id == lectures![index].id
                                        ? Colors.white
                                        : Colors.black),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.done_all))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            lectures![index].description ?? 'No description',
                            style: TextStyle(
                                color:
                                    selectedLecture?.id == lectures![index].id
                                        ? Colors.white
                                        : Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Duration ${(lectures?[index].duration ?? 0.0).toStringAsFixed(0)} min',
                            style: TextStyle(
                              color: selectedLecture?.id == lectures![index].id
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                  Icons.play_circle_outline_outlined))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      case CourseOptions.Certificate:
        final displayName =
            FirebaseAuth.instance.currentUser?.displayName ?? 'User';
        final courseTitle = widget.course.title ?? 'Unknown Course';
        final DateTime now = DateTime.now();

        return Container(
          padding: const EdgeInsets.all(20),
          width: 350,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Certificate of Completion',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'This Certifies that',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                displayName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                courseTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Issued on ${now.day}-${now.month}-${now.year}', // Using current date here
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 5),
              const Text(
                'Virginia M. Patterson',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        );

      case CourseOptions.More:
        return Column(
          children: [
            //instructor
            ListTile(
              tileColor: const Color.fromARGB(255, 206, 203, 203),
              title: const Text("About Instructor"),
              trailing: const SizedBox(
                width: 30,
                child: Row(
                  children: [
                    Icon(Icons.arrow_forward_ios,
                        size: 15, color: Colors.black),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("About Instructor"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Instructor Name: ${widget.course.instructor?.name ?? 'No name'}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Graduation From: ${widget.course.instructor?.graduation_from ?? ''}',
                            style: const TextStyle(
                                fontSize: 14, color: ColorUtility.mediumBlack),
                          ),
                          Text(
                            'Years of Experience: ${widget.course.instructor?.years_of_experience ?? ''}',
                            style: const TextStyle(
                                fontSize: 14, color: ColorUtility.mediumBlack),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            "Cancel",
                            style: const TextStyle(
                                fontSize: 14, color: ColorUtility.main),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              tileColor: const Color.fromARGB(255, 206, 203, 203),
              title: const Text("Course Resources"),
              trailing: const SizedBox(
                width: 30,
                child: Row(
                  children: [
                    Icon(Icons.arrow_forward_ios,
                        size: 15, color: Colors.black),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              onTap: () {
                setState(() {});
              },
            ),
          ],
        );
      default:
        return Text(' option ${widget.courseOption.name}');
    }
  }
}
