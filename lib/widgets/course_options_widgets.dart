import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista_app/blocs/course/course_bloc.dart';
import 'package:edu_vista_app/models/course.dart';
import 'package:edu_vista_app/models/lecture.dart';
import 'package:edu_vista_app/utils/app_enums.dart';
import 'package:edu_vista_app/utils/color.utility.dart';
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
                                icon: Icon(Icons.file_download_outlined))
                          ],
                        ),
                       Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              lectures![index].description ?? 'No description',
                              style: TextStyle(
                                  color: selectedLecture?.id == lectures![index].id
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
                                icon: Icon(Icons.play_circle_outline_outlined))
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
        return const SizedBox.shrink();

      case CourseOptions.Certificate:
        return const SizedBox.shrink();

      case CourseOptions.More:
        return const SizedBox.shrink();
      default:
        return Text('Invalid option ${widget.courseOption.name}');
    }
  }
}
