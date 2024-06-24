import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/TO%20DO/Model/todo_model.dart';
import 'package:myapp/TO%20DO/Service/todo_database_Service.dart';
import 'package:myapp/TO%20DO/loader.dart';
import 'package:myapp/TO%20DO/mytodo_dialog.dart';

class ToDolist extends StatefulWidget {
  const ToDolist({Key? key}) : super(key: key);

  @override
  State<ToDolist> createState() => _ToDolistState();
}

class _ToDolistState extends State<ToDolist> {
  TextEditingController todoTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent[100],
      body: SingleChildScrollView(
        child: SafeArea(
          child: StreamBuilder<List<TodoModel>>(
            stream: TodoDatabase().listTodo(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Loader();
              }
              List<TodoModel>? todo = snapshot.data;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Center(
                        child: Text(
                          "ToDo List",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListView.builder(
                      itemCount: todo!.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(todo[index].uid),
                          background: Container(
                            alignment: Alignment.centerLeft,
                            color: Colors.black12,
                            child: Center(child: Icon(Icons.delete)),
                          ),
                          onDismissed: (direction) async {
                            await TodoDatabase().deleteTodo(todo[index].uid);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: ListTile(
                                onTap: () {
                                  bool newCompleteTask =
                                      !todo[index].isCompleted;
                                  TodoDatabase().updateTask(
                                    todo[index].uid,
                                    newCompleteTask,
                                  );
                                  setState(() {
                                    todo[index].isCompleted = newCompleteTask;
                                  });
                                },
                                leading: Container(
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    color: Colors.greenAccent[200],
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: todo[index].isCompleted
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        )
                                      : Container(),
                                ),
                                title: Text(todo[index].title),
                                subtitle: todo[index].dueDate != null
                                    ? Text(
                                        DateFormat.yMMMd()
                                            .add_jm()
                                            .format(todo[index].dueDate!),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      )
                                    : Text(
                                        "No due date",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final DateTime? selectedDateTime = await showDialog<DateTime>(
            context: context,
            builder: (context) => ToDoDialog(
              todoTitleController: todoTitleController,
            ),
          );

          if (selectedDateTime != null) {
            await TodoDatabase().createNewTodo(
              todoTitleController.text.trim(),
              selectedDateTime,
            );

            setState(() {}); // Update the UI after adding todo
            todoTitleController.clear();
          }
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
