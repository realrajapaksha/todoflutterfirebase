import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todoflutterfirebase/models/task.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _taskNameController = TextEditingController();
  var _taskDesController = TextEditingController();

  bool _validateTaskDes = false;
  bool _validateTaskName = false;

  late List<Task> _taskList = <Task>[];

  var db = FirebaseFirestore.instance;
  _connectFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  _saveFirestoreData() async {
    final task = <String, dynamic>{
      "task": _taskNameController.text,
      "descrtiption": _taskDesController.text,
      "date": DateTime.now().toString(),
    };

    Random random = new Random();
    int id = random.nextInt(1000);

    var result = await db
        .collection("tasks")
        .doc(id.toString())
        .set(task)
        .whenComplete(() => {
              print("succesfull"),
            });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _connectFirebase();
    print(_taskList.length);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Firebase"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Column(
            children: [
              TextField(
                controller: _taskNameController,
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
          SizedBox(
            height: 400,
            width: double.infinity,
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('tasks').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                return ListView.builder(
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (ctx, index) {
                      return Card(
                          child: ListTile(
                        title: Text(streamSnapshot.data!.docs[index]['task']),
                        subtitle:
                            Text(streamSnapshot.data!.docs[index]['date']),
                      ));
                    });
              },
            ),
          )
        ]),
      ),
    );
  }
}
