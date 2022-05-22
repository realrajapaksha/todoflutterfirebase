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
        onTap: _onTapped,
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedIndex,
        elevation: 4,
        selectedItemColor: const Color.fromARGB(255, 35, 35, 35),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedItemColor: Colors.black38,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "tODO"),
          BottomNavigationBarItem(icon: Icon(Icons.done), label: "Complete"),
          BottomNavigationBarItem(icon: Icon(Icons.delete), label: "Delete"),
        ],
      ),
    );
  }
}
