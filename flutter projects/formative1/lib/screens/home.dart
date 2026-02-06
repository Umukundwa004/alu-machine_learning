import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'assignments.dart';
import 'announcements.dart';
import 'risk_status.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const AssignmentsScreen(),
    const AnnouncementsScreen(),
    const RiskStatusScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2C5A),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1A2C5A),
        selectedItemColor: const Color(0xFFFFB800),
        unselectedItemColor: Colors.white54,
        selectedLabelStyle: const TextStyle(fontSize: 10),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today, size: 22),
            label: 'Summaries',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz_outlined, size: 22),
            label: 'Quizes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement_outlined, size: 22),
            label: 'Announcements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 22),
            label: 'Planners',
          ),
        ],
      ),
    );
  }
}
