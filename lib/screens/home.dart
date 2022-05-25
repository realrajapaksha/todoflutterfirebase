import 'package:flutter/material.dart';
import 'package:todoflutterfirebase/screens/complete.dart';
import 'package:todoflutterfirebase/screens/delete.dart';
import 'package:todoflutterfirebase/screens/todoList.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  PageController pageController = PageController();

  void _onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: const [TodoList(), Complete(), Delete()],
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.white,
        onTap: _onTapped,
        type: BottomNavigationBarType.shifting, // Fixed
        currentIndex: _selectedIndex,
        elevation: 10,
        // selectedItemColor:  Colors.white,
        // selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        // unselectedItemColor: Colors.black38,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              backgroundColor: Colors.teal,
              icon: Icon(Icons.list),
              label: "tODO"),
          BottomNavigationBarItem(
              backgroundColor: Colors.blue,
              icon: Icon(Icons.done),
              label: "Complete"),
          BottomNavigationBarItem(
              backgroundColor: Colors.redAccent,
              icon: Icon(Icons.delete),
              label: "Delete"),
        ],
      ),
    );
  }
}
