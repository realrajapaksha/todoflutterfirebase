import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoflutterfirebase/screens/addTask.dart';
import 'package:todoflutterfirebase/screens/splashscreen.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

class TodoList extends StatefulWidget {
  final String userId;
  const TodoList(this.userId, {Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  var db = FirebaseFirestore.instance;

  late final List<bool> _isChecked = List<bool>.filled(500, false);

  Future<void> _saveFirestoreData(
      String id, String datetime, String taskname, String description) async {
    final task = <String, dynamic>{
      "id": id,
      "task": taskname,
      "descrtiption": description,
      "date": datetime,
    };

    await db
        .collection("tasks")
        .doc(widget.userId)
        .collection("complete list")
        .doc(id.toString())
        .set(task)
        .whenComplete(() => {_deleteFirestoreData(id)});
  }

  Future<void> _deleteFirestoreData(String id) async {
    db
        .collection("tasks")
        .doc(widget.userId)
        .collection("task list")
        .doc(id)
        .delete()
        .then(
          (doc) => print("Document deleted"),
          onError: (e) => print("Error updating document $e"),
        );
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
    String loginFrom = prefs.getString("loginFrom") ?? "";
    if (loginFrom == "google") {
      await _googleSignIn.signOut().whenComplete(() => {
            prefs.setBool("username", false),
            prefs.setString("loginFrom", ""),
            _navigateSplash()
          });
    } else if (loginFrom == "email") {
      await FirebaseAuth.instance.signOut().whenComplete(() => {
            prefs.setBool("username", false),
            prefs.setString("loginFrom", ""),
            _navigateSplash()
          });
    }
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.black;
    }
    return Colors.blue;
  }

  Widget taskList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.userId)
          .collection("task list")
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        switch (streamSnapshot.connectionState) {
          case ConnectionState.none:
            return const Center(
              child: Text("No Internet Connection"),
            );

          case ConnectionState.waiting:
            return const Center(
              child: Text("Loading Task.."),
            );
          case ConnectionState.done:

          case ConnectionState.active:
            if (streamSnapshot.data!.docs.isNotEmpty) {
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
                    String id =
                        streamSnapshot.data!.docs[index]['id'].toString();
                    String date = streamSnapshot.data!.docs[index]['date'];
                    String taskname = streamSnapshot.data!.docs[index]['task'];
                    String description =
                        streamSnapshot.data!.docs[index]['descrtiption'];
                    return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 10.0,
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Text(streamSnapshot.data!.docs[index]['task'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  )),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 3,
                              ),
                              Text("$year.$month.$day"),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                streamSnapshot.data!.docs[index]
                                    ['descrtiption'],
                                style: const TextStyle(color: Colors.white54),
                              )
                            ],
                          ),
                          leading: Checkbox(
                            checkColor: Colors.white,
                            fillColor:
                                MaterialStateProperty.resolveWith(getColor),
                            value: _isChecked[index],
                            onChanged: ((value) => {
                                  setState(
                                    () {
                                      _isChecked[index] = value!;
                                      _saveFirestoreData(
                                          id, date, taskname, description);
                                    },
                                  )
                                }),
                          ),
                        ));
                  });
            } else {
              return (const Center(child: Text("Create Your First Task")));
            }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("todolist");
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: _handleSignOut, icon: const Icon(Icons.logout))
        ],
        title: const Text("MY tODO"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: taskList(),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.teal,
          child: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  backgroundColor: Color.fromARGB(255, 37, 37, 37),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0))),
                  builder: (context) {
                    return SingleChildScrollView(
                      child: Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                20.0, 20.0, 20.0, 10.0),
                            child: AddTask(widget.userId),
                          )),
                    );
                  });
            },
            color: Colors.white,
          )),
    );
  }
}
