import 'package:esurat_poliwangi/screens/direktur/home_screen.dart';
import 'package:esurat_poliwangi/screens/direktur/profile_screen.dart';
import 'package:flutter/material.dart';

class DirekturLayout extends StatefulWidget {
  const DirekturLayout({super.key});

  @override
  State<DirekturLayout> createState() => _DirekturLayoutState();
}

class _DirekturLayoutState extends State<DirekturLayout> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const DirekturHomeScreen(),
      const DirekturProfileScreen(),
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
