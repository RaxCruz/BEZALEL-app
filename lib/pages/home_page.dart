import 'package:flutter/material.dart';
import '../widgets/side_navigation.dart';
import '../pages/dashboard_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _currentPage = const DashboardPage();

  void changePage(Widget page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          SideNavigation(onPageChanged: changePage),
          Expanded(
            child: _currentPage,
          ),
        ],
      ),
    );
  }
} 