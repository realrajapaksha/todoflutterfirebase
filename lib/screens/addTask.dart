import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

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

  String userId = "";

  bool _isLogin = false;

  Future<void> _saveFirestoreData() async {
    Navigator.pop(context);
    if (userId == "1231") {
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
          .doc(userId)
          .collection("task list")
          .doc(id.toString())
          .set(task)
          .whenComplete(() => {
                _taskNameController.text = "",
                _taskDesController.text = "",
              });
    }
  }

  @override
  void initState() {
    super.initState();

    //Check Google user
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        userId = account!.id;
        _isLogin = true;
      });
    });

    //Check Email user
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          _isLogin = true;
          userId = user.uid;
        });
      }
    });

    _googleSignIn.signInSilently().then((value) => {
          setState(() {
            if (_googleSignIn.currentUser!.id.isNotEmpty) {
              userId = _googleSignIn.currentUser!.id;
            }

            if (userId != "") {
              _isLogin = true;
            }
          })
        });
  }

  @override
  Widget build(BuildContext context) {
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
