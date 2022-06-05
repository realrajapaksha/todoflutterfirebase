import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoflutterfirebase/providers/addtask_provider.dart';

class AddTask extends StatefulWidget {
  final String userId;
  const AddTask(this.userId, {Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var _taskNameController = TextEditingController();
  var _taskDesController = TextEditingController();
  var _name_focus = FocusNode();

  var db = FirebaseFirestore.instance;

  Future<void> _saveFirestoreData() async {
    Random random = new Random();
    int id = random.nextInt(1000);

    final task = <String, dynamic>{
      "id": id,
      "task": _taskNameController.text,
      "descrtiption": _taskDesController.text,
      "date": DateTime.now().toString(),
    };

    await db
        .collection("tasks")
        .doc(widget.userId)
        .collection("task list")
        .doc(id.toString())
        .set(task)
        .whenComplete(() => {
              _taskNameController.text = "",
              _taskDesController.text = "",
              Navigator.pop(context)
            });
  }

  @override
  Widget build(BuildContext context) {
    print("add task");
    return ChangeNotifierProvider(
        create: (context) => TaskData(),
        builder: (BuildContext context, child) {
          return Consumer<TaskData>(builder: (context, value, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: _taskNameController,
                  focusNode: _name_focus,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Enter Task Name",
                    labelText: "Task Name",
                    errorText: value.validateTaskName ? "can't be empty" : null,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: _taskDesController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Enter Task Description",
                    labelText: "Task Description",
                    errorText: value.validateTaskDes ? "can't be empty" : null,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.teal,
                        textStyle: const TextStyle(fontSize: 15)),
                    onPressed: () async {
                      _taskNameController.text.isEmpty
                          ? Provider.of<TaskData>(context, listen: false)
                              .changeValidateName(true)
                          : Provider.of<TaskData>(context, listen: false)
                              .changeValidateName(false);
                      _taskDesController.text.isEmpty
                          ? Provider.of<TaskData>(context, listen: false)
                              .changeValidateDes(true)
                          : Provider.of<TaskData>(context, listen: false)
                              .changeValidateDes(false);

                      if (Provider.of<TaskData>(context, listen: false)
                                  .validateTaskName ==
                              false &&
                          Provider.of<TaskData>(context, listen: false)
                                  .validateTaskDes ==
                              false) {
                        //save data firebase
                        _saveFirestoreData();
                      }
                    },
                    child: const Text("Save")),
              ],
            );
          });
        });
  }
}
