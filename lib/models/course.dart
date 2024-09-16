import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista_app/models/category.dart';
import 'package:edu_vista_app/models/instructor.dart';

class Course {
  String? id;
  String? title;
  String? image;
  Category? category;
  String? currency;
  String? rank;
  bool? has_certificate;
  Instructor? instructor;
  double? price;
  int? rating;
  int? total_hours;
  DateTime? created_date;
  List<String> users_buys; // Added users_buys field

  Course({
    this.id,
    this.title,
    this.image,
    this.category,
    this.currency,
    this.rank,
    this.has_certificate,
    this.instructor,
    this.price,
    this.rating,
    this.total_hours,
    this.created_date,
    List<String>? users_buys,
  }) : users_buys = users_buys ?? []; // Initialize users_buys

  Course.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'],
        image = data['image'],
        category = data['category'] != null
            ? Category.fromJson(data['category'])
            : null,
        currency = data['currency'],
        rank = data['rank'],
        has_certificate = data['has_certificate'],
        instructor = data['instructor'] != null
            ? Instructor.fromJson(data['instructor'])
            : null,
        price = data['price'] is int
            ? (data['price'] as int).toDouble()
            : data['price'],
        rating =
            data['rating'] is int ? (data['rating'] as int) : data['rating'],
        total_hours = data['total_hours'],
        created_date = data['created_date'] != null
            ? (data['created_date'] as Timestamp).toDate()
            : null,
        users_buys = List<String>.from(
            data['users_buys'] ?? []); // Initialize users_buys from JSON

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    data['category'] = category?.toJson();
    data['currency'] = currency;
    data['rank'] = rank;
    data['has_certificate'] = has_certificate;
    data['instructor'] = instructor?.toJson();
    data['price'] = price;
    data['rating'] = rating;
    data['total_hours'] = total_hours;
    data['users_buys'] = users_buys; // Add users_buys to JSON
    return data;
  }
}
