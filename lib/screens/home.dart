import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoflutterfirebase/screens/splashscreen.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _taskNameController = TextEditingController();
  var _taskDesController = TextEditingController();
  var _name_focus = FocusNode();

  bool _validateTaskDes = false;
  bool _validateTaskName = false;

  var db = FirebaseFirestore.instance;

  String userId = "";

  bool _isLogin = false;

  Future<void> _saveFirestoreData() async {
    if (userId != "") {
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

  Future<void> _deleteFirestoreData(String id) async {
    db
        .collection("tasks")
        .doc(userId)
        .collection("task list")
        .doc(id)
        .delete()
        .then(
          (doc) => print("Document deleted"),
          onError: (e) => print("Error updating document $e"),
        );
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
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
          print(user.uid);
        }
      });
      _googleSignIn.signInSilently();
    }
  }

  void _navigateSplash() {
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen()),
        ModalRoute.withName("/Home"));
  }

  Future<void> _handleSignOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await FirebaseAuth.instance.signOut().whenComplete(() => {
          prefs.setBool("username", false),
          print("auth out"),
          _navigateSplash()
        });
    await _googleSignIn.signOut().whenComplete(() => {
          prefs.setBool("username", false),
          print("google out"),
          _navigateSplash()
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget taskList() {
    if (_isLogin == true) {
      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .doc(userId)
            .collection("task list")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (ctx, index) {
                  String day =
                      DateTime.parse(streamSnapshot.data!.docs[index]['date'])
                          .day
                          .toString();
                  String month =
                      DateTime.parse(streamSnapshot.data!.docs[index]['date'])
                          .month
                          .toString();
                  String year =
                      DateTime.parse(streamSnapshot.data!.docs[index]['date'])
                          .year
                          .toString();
                  return Card(
                      child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text(streamSnapshot.data!.docs[index]['task']),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text("$year.$month.$day"),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(streamSnapshot.data!.docs[index]['descrtiption'])
                      ],
                    ),
                    trailing: IconButton(
                        alignment: Alignment.topCenter,
                        onPressed: () {
                          _deleteFirestoreData(streamSnapshot
                              .data!.docs[index]["id"]
                              .toString());
                        },
                        icon: const Icon(Icons.delete, color: Colors.red)),
                  ));
                });
          } else {
            return const Center(
              child: Text("Create Your First Task!"),
            );
          }
        },
      );
    } else {
      return (const Center(child: Text("No Taks Found")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: _handleSignOut, icon: const Icon(Icons.logout))
        ],
        title: const Text("Flutter Firebase"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Column(
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
                height: 10,
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
                width: 20.0,
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
                    if (_validateTaskName == false &&
                        _validateTaskDes == false) {
                      //save data firebase
                      _saveFirestoreData();
                    }
                  },
                  child: const Text("Save")),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Flexible(
              child: SizedBox(
                  height: 400, width: double.infinity, child: taskList())),
        ]),
      ),
    );
  }
}
