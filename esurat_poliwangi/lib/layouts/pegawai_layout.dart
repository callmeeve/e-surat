import 'package:esurat_poliwangi/screens/pegawai/home_screen.dart';
import 'package:esurat_poliwangi/screens/pegawai/profile_screen.dart';
import 'package:flutter/material.dart';

class PegawaiLayout extends StatefulWidget {
  const PegawaiLayout({super.key});

  @override
  State<PegawaiLayout> createState() => _PegawaiLayoutState();
}

class _PegawaiLayoutState extends State<PegawaiLayout> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const PegawaiHomeScreen(),
      const PegawaiProfileScreen(),
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
