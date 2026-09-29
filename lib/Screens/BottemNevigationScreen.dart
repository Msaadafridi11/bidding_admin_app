import 'package:bidding_admin/Screens/AdminAddData.dart';
import 'package:bidding_admin/Screens/AdminCarListsScreen.dart';
import 'package:bidding_admin/Screens/AdminProfileScreen.dart';
import 'package:flutter/material.dart';

class Bottemnevigationscreen extends StatefulWidget {
  const Bottemnevigationscreen({super.key});

  @override
  State<Bottemnevigationscreen> createState() => _BottemnevigationscreenState();
}

class _BottemnevigationscreenState extends State<Bottemnevigationscreen> {
  int _currentIndex = 0;
  List<Widget> ListIndex = [
    Adminadddata(),
    Admincarlistsscreen(),
    AdminProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IndexedStack(
          index: _currentIndex,
          children: ListIndex,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[300],
        currentIndex: _currentIndex,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_3), label: ''),
        ],
      ),
    );
  }
}
