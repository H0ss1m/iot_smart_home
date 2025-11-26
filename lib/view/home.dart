import 'package:flutter/material.dart';
import 'package:iot_smart_home/view/devices_page.dart';
import 'package:iot_smart_home/module/home_page2.dart';
import 'package:iot_smart_home/view/routines_page.dart';
import 'package:iot_smart_home/module/setting_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final List<Widget> _selectedTab = [HomePage2(), RoutinesPage(), DevicesPage(), SettingPage()];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xff0f172a),
        selectedItemColor: const Color(0xFF2196F3),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Routines',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.devices_other),
            label: 'Devices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: _selectedTab[_selectedIndex],
    );
  }
}
