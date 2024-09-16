import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista_app/models/course.dart';


class Cart{
  String? id;
 Course? course;
  bool? is_bought;
  DateTime? created_date;

  Cart.fromJson(Map<String, dynamic> data) {
    id = data['id'];
   
    course =
        data['course'] != null ? Course.fromJson(data['course']) : null;
 
    is_bought = data['is_bought'];

    created_date = data['created_date'] != null
        ? (data['created_date'] as Timestamp).toDate()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
  
    data['course'] = course?.toJson();
    
    data['is_bought'] = is_bought;

    return data;
  }
}
