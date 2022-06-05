import 'package:cop_belgium_app/screens/more_screen/more_screen.dart';
import 'package:cop_belgium_app/screens/podcast_screens/podcast_screen.dart';
import 'package:cop_belgium_app/screens/question_answer_screen/question_answer_screen.dart';
import 'package:cop_belgium_app/screens/video_player_screen/videos_screen.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:flutter/material.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const PodcastScreen(),
    const VideosScreen(),
    const QuestionAnswerScreen(),
    const MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: _buildBottomNavBar(
        context: context,
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

Widget _buildBottomNavBar({
  Function(int)? onTap,
  required int index,
  required BuildContext context,
}) {
  final caption = Theme.of(context).textTheme.caption?.fontSize ?? 14.0;
  final bodyText2 = Theme.of(context).textTheme.bodyText2;

  return BottomNavigationBar(
    backgroundColor: Colors.white,
    selectedItemColor: kBlue,
    unselectedItemColor: kBlack,
    selectedFontSize: caption, // if not set to 0 bottom nav exception bug
    unselectedFontSize: caption, // if not set to 0 bottom nav exception bug
    selectedLabelStyle: bodyText2,
    unselectedLabelStyle: bodyText2,
    currentIndex: index,
    type: BottomNavigationBarType.fixed,
    onTap: onTap,
    items: [
      _buildBottomNavItem(
        label: 'Podcasts',
        icon: Icons.podcasts_outlined,
      ),
      _buildBottomNavItem(
        label: 'Videos',
        icon: Icons.video_library_outlined,
      ),
      _buildBottomNavItem(
        label: 'Q&A',
        icon: Icons.question_answer_outlined,
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
  return BottomNavigationBarItem(
    label: label,
    tooltip: label,
    icon: Icon(
      icon,
      color: kGrey,
    ),
    activeIcon: Icon(
      icon,
      color: kBlue,
    ),
  );
}
