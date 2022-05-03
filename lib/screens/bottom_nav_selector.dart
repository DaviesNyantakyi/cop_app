import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:flutter/material.dart';

class BottomNavScreen extends StatefulWidget {
  static String bottomNavScreen = 'BottomNavScreen';
  const BottomNavScreen({Key? key}) : super(key: key);

  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 3;

  final List<Widget> _screens = [
    // PodcastScreen(),
    // EventsScreen(),
    // TestimoniesScreen(),
    // MoreScreen()

    Container(),
    Container(),
    Container(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: _buildBottomNavBar(
        index: _selectedIndex,
        onTap: (value) {
          if (mounted) {
            setState(() {
              _selectedIndex = value;
            });
          }
        },
      ),
    );
  }
}

Widget _buildBottomNavBar({Function(int)? onTap, required int index}) {
  return BottomNavigationBar(
    backgroundColor: Colors.white,
    selectedItemColor: kBlue,
    unselectedItemColor: kBlack,
    selectedFontSize: kFontCaption.fontSize ??
        14.0, // if not set to 0 bottom nav exception bug
    unselectedFontSize: kFontCaption.fontSize ??
        14.0, // if not set to 0 bottom nav exception bug
    selectedLabelStyle: kFontBody2,

    currentIndex: index,
    type: BottomNavigationBarType.fixed,
    onTap: onTap,
    items: [
      _buildBottomNavItem(
        label: 'Podcasts',
        icon: Icons.podcasts_outlined,
      ),
      _buildBottomNavItem(
        label: 'Events',
        icon: Icons.calendar_today_outlined,
      ),
      _buildBottomNavItem(
        label: 'Testimonies',
        icon: Icons.format_quote_outlined,
      ),
      _buildBottomNavItem(
        label: 'More',
        icon: Icons.menu_outlined,
      ),
    ],
  );
}

BottomNavigationBarItem _buildBottomNavItem({
  required String label,
  required IconData icon,
}) {
  final Color _bottomNavColor = Colors.blueGrey.shade300;

  return BottomNavigationBarItem(
    label: label,
    tooltip: label,
    icon: Icon(
      icon,
      color: _bottomNavColor,
    ),
    activeIcon: Icon(
      icon,
      color: kBlue,
    ),
  );
}
