import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoflutterfirebase/providers/navigation_provider.dart';
import 'package:todoflutterfirebase/screens/complete.dart';
import 'package:todoflutterfirebase/screens/delete.dart';
import 'package:todoflutterfirebase/screens/todoList.dart';

class Home extends StatefulWidget {
  const Home(this.userId,{Key? key}) : super(key: key);
  final String userId;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController pageController = PageController();

  var screens = [];

  @override
  void initState() {
    super.initState();
    screens = [
      TodoList(widget.userId),
      Complete(widget.userId),
      Delete(widget.userId)
    ];
  }

  @override
  Widget build(BuildContext context) {
    print("Home");
    return ChangeNotifierProvider(
        create: (context) => NavigationData(),
        builder: (BuildContext context, child) {
          return Scaffold(
            body: screens[Provider.of<NavigationData>(context).getIndex],
            bottomNavigationBar: BottomNavigationBar(
              fixedColor: Colors.white,
              onTap: (index) => {
                Provider.of<NavigationData>(context, listen: false)
                    .changeIndex(index),
              },
              type: BottomNavigationBarType.shifting, // Fixed
              currentIndex: Provider.of<NavigationData>(context).getIndex,
              elevation: 10,
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
                    label: "Trash"),
              ],
            ),
          );
        });
  }
}
