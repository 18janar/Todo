import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/todo_model.dart';

class TodoDatabase {
  CollectionReference toCollection =
      FirebaseFirestore.instance.collection("TodoList");

  // for todo order based on their assigned date
  Stream<List<TodoModel>> listTodo() {
    return toCollection
        .orderBy("Timestamp", descending: true)
        .snapshots()
        .map(todoFromFirestore);
  } // after that the most recent added items are top on the list

  Future createNewTodo(
    String title,
    DateTime dueDate,
  ) async {
    return await toCollection.add({
      'title': title,
      'Timestamp': FieldValue.serverTimestamp(),
      'dueDate': Timestamp.fromDate(dueDate),
      'isCompleted': false, // Default value
    });
  }

  // for updating the todo
  Future updateTask(String uid, bool newCompletedTask) async {
    await toCollection.doc(uid).update({"isCompleted": newCompletedTask});
  }

  // for deleting the todo
  Future deleteTodo(String uid) async {
    await toCollection.doc(uid).delete();
  }

  List<TodoModel> todoFromFirestore(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      Map<String, dynamic>? data = e.data() as Map<String, dynamic>?;

      return TodoModel(
          uid: e.id,
          title: data?['title'] ?? "",
          isCompleted: data?['isCompleted'] ?? true,
          dueDate: data?['dueDate'] != null
              ? (data?['dueDate'] as Timestamp).toDate()
              : null);
    }).toList();
  }
}
