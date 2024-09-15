import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista_app/models/course.dart';

class Cart {
  String? id;
    String? nor;
  bool? isBought;
  Course? course;

  Cart.fromJson(Map<String, dynamic> data) {
    id = data['id'];
       nor = data['nor'];
    course = data['course'] != null ? Course.fromJson(data['course']) : null;

    isBought = data['isBought'];

    // created_date = data['created_date'] != null
    //     ? (data['created_date'] as Timestamp).toDate()
    //     : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
     data['nor'] = nor;
    data['isBought'] = isBought;
    data['course'] = course?.toJson();
    return data;
  }
}
