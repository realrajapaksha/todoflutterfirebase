import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  bool _validateTaskDes = false;
  bool _validateTaskName = false;

  var db = FirebaseFirestore.instance;

  bool _isLogin = false;

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
            errorText: _validateTaskName ? "can't be empty" : null,
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
            errorText: _validateTaskDes ? "can't be empty" : null,
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
              setState(() {
                _taskNameController.text.isEmpty
                    ? _validateTaskName = true
                    : _validateTaskName = false;
                _taskDesController.text.isEmpty
                    ? _validateTaskDes = true
                    : _validateTaskDes = false;
              });
              if (_validateTaskName == false && _validateTaskDes == false) {
                //save data firebase
                _saveFirestoreData();
              }
            },
            child: const Text("Save")),
      ],
    );
  }
}
