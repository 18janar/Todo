import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  final String uid;
  final String title;
  late final bool isCompleted;
  final DateTime? dueDate; // Nullable DateTime for due date

  TodoModel({
    required this.uid,
    required this.title,
    required this.isCompleted,
    this.dueDate,
  });

  // Method to convert a Todo object to a map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
    };
  }

  // Method to create a Todo object from a map
  factory TodoModel.fromMap(Map<String, dynamic> map, String id) {
    return TodoModel(
      uid: id,
      title: map['title'],
      isCompleted: map['isCompleted'],
      dueDate: map['dueDate'] != null
          ? (map['dueDate'] as Timestamp).toDate()
          : null,
    );
  }
}
