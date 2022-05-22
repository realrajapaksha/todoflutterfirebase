import 'package:flutter/material.dart';

class Delete extends StatefulWidget {
  const Delete({Key? key}) : super(key: key);

  @override
  State<Delete> createState() => _DeleteState();
}

class _DeleteState extends State<Delete> {
  @override
  Widget build(BuildContext context) {
   return const Scaffold(
      body: Center(
        child: Text("delete")
      )
    );
  }
}
