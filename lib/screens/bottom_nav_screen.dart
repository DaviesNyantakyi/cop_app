import 'package:cop_belgium_app/providers/audio_notifier.dart';
import 'package:cop_belgium_app/screens/more_screen/more_screen.dart';
import 'package:cop_belgium_app/screens/question_answer_screen/question_answer_screen.dart';
import 'package:cop_belgium_app/screens/sermon_screens/sermon_screen.dart';
import 'package:cop_belgium_app/screens/teaching_clips_screens/teaching_clips_screen.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen>
    with WidgetsBindingObserver {
  int selectedIndex = 0;

  final List<Widget> screens = [
    const SermonsScreen(),
    const TeachingClipScreen(),
    const QuestionAnswerScreen(),
    const MoreScreen(),
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint('AppLifecycleState Resumed');
        break;
      case AppLifecycleState.inactive:
        debugPrint('AppLifecycleState Inactive');
        break;
      case AppLifecycleState.paused:
        debugPrint('AppLifecycleState Paused');
        break;
      case AppLifecycleState.detached:
        // Stop the audio when the app is closed
        await Provider.of<AudioPlayerNotifier>(context, listen: false).close();
        debugPrint('AppLifecycleState Detached');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: screens[selectedIndex],
      ),
      bottomNavigationBar: _buildBottomNavBar(
        context: context,
        index: selectedIndex,
        onTap: (value) {
          if (mounted) {
            setState(() {
              selectedIndex = value;
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
    selectedFontSize: caption, // Exception is thrown if not set to 0
    unselectedFontSize: caption, // Exception is thrown if not set to 0
    selectedLabelStyle: bodyText2,
    unselectedLabelStyle: bodyText2,
    currentIndex: index,
    type: BottomNavigationBarType.fixed,
    onTap: onTap,
    items: [
      _buildBottomNavItem(
        label: 'Sermons',
        icon: Icons.headphones,
      ),
      _buildBottomNavItem(
        label: 'Clips',
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
