import 'package:flutter/material.dart';
import 'package:basic_app/screens/home_screen.dart';
import 'package:basic_app/screens/projects_screen.dart';
import 'package:basic_app/screens/focus_screen.dart';
import 'package:basic_app/screens/stats_screen.dart';
import 'package:basic_app/screens/profile_screen.dart';
import 'package:basic_app/widgets/app_bottom_navigation_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ProjectsScreen(),
    const FocusScreen(),
    const StatsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
