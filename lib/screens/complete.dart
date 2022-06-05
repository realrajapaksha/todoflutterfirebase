import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Complete extends StatefulWidget {
  final String userId;
  const Complete(this.userId, {Key? key}) : super(key: key);

  @override
  State<Complete> createState() => _CompleteState();
}

class _CompleteState extends State<Complete> {
  var db = FirebaseFirestore.instance;

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
        .collection("delete list")
        .doc(id.toString())
        .set(task)
        .whenComplete(() => {_deleteFirestoreData(id)});
  }

  Future<void> _deleteFirestoreData(String id) async {
    db
        .collection("tasks")
        .doc(widget.userId)
        .collection("complete list")
        .doc(id)
        .delete()
        .then(
          (doc) => print("Document deleted"),
          onError: (e) => print("Error updating document $e"),
        );
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
          .collection("complete list")
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
                          trailing: IconButton(
                              alignment: Alignment.topCenter,
                              onPressed: () {
                                _saveFirestoreData(
                                    id, date, taskname, description);
                              },
                              icon:
                                  const Icon(Icons.delete, color: Colors.red)),
                        ));
                  });
            } else {
              return (const Center(child: Text("Complete Your First Task")));
            }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("complete");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: taskList(),
      ),
    );
  }
}
