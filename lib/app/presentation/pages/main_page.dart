import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';

import '../../core/routes/navigate.dart';
import 'home/home_page.dart';
import 'poin/point_page.dart';
import 'profile/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _pages = const <Widget>[
    HomePage(),
    Placeholder(),
    PointPage(),
    ProfilePage(),
  ];

  int _selectedPage = 0;

  void _pageOnTap(int page) {
    // halaman aktivitas berada di index ke-1 dari navbar
    if (page == 1) {
      // Jika index 1, push halaman Activity
      Navigator.pushNamed(context, To.ACTIVITY);
    } else {
      // Jika bukan halaman aktivitas
      setState(() => _selectedPage = page);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPage],
      bottomNavigationBar: Stack(
        children: [
          BottomNavigationBar(
            elevation: 0,
            onTap: _pageOnTap,
            currentIndex: _selectedPage,
            backgroundColor: Colors.white,
            selectedLabelStyle: const TextStyle(fontSize: 14),
            unselectedLabelStyle: const TextStyle(fontSize: 14),
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                label: 'Beranda',
                icon: Icon(Iconsax.home),
                activeIcon: Icon(Iconsax.home5),
              ),
              BottomNavigationBarItem(
                label: 'Aktivitas',
                icon: Icon(Iconsax.record_circle),
              ),
              BottomNavigationBarItem(
                label: 'Poin',
                icon: Icon(Iconsax.gift),
                activeIcon: Icon(Iconsax.gift5),
              ),
              BottomNavigationBarItem(
                label: 'Profil',
                icon: Icon(Iconsax.profile_circle),
                activeIcon: Icon(Iconsax.profile_circle5),
              ),
            ],
          ),

          // divider
          Positioned(
            top: 0,
            right: 16,
            left: 16,
            child: Container(
              width: MediaQuery.of(context).size.width - 32,
              color: Colors.grey,
              height: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
