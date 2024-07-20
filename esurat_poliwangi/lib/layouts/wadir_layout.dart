import 'package:flutter/material.dart';
import 'package:esurat_poliwangi/screens/wadir/home_screen.dart';
import 'package:esurat_poliwangi/screens/wadir/profile_screen.dart';

class WadirLayout extends StatefulWidget {
  const WadirLayout({super.key});

  @override
  State<WadirLayout> createState() => _WadirLayoutState();
}

class _WadirLayoutState extends State<WadirLayout> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const WadirHomeScreen(),
      const WadirProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
