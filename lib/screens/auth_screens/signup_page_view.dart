import 'package:cop_belgium_app/providers/signup_notifier.dart';
import 'package:cop_belgium_app/screens/auth_screens/gender_view.dart';
import 'package:cop_belgium_app/screens/auth_screens/info_view.dart';
import 'package:cop_belgium_app/screens/auth_screens/profile_image_picker_view.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/screens/church_selection_view/church_selection_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPageView extends StatefulWidget {
  static String signUpScreen = 'signUpScreen';
  const SignUpPageView({Key? key}) : super(key: key);

  @override
  State<SignUpPageView> createState() => _SignUpPageViewState();
}

class _SignUpPageViewState extends State<SignUpPageView> {
  PageController pageController = PageController(initialPage: 0);

  late final SignUpNotifier signUpProvider;

  @override
  void initState() {
    signUpProvider = Provider.of<SignUpNotifier>(context, listen: false);
    Provider.of<SignUpNotifier>(context, listen: false).close();
    super.initState();
  }

  @override
  void dispose() {
    signUpProvider.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<PageController>.value(
              value: pageController,
            ),
          ],
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            children: const [
              AddInfoView(),
              GenderView(),
              ProfileImagePickerView(),
              _ChurchSelectionView()
            ],
          ),
        ),
      ),
    );
  }
}

class _ChurchSelectionView extends StatefulWidget {
  const _ChurchSelectionView({Key? key}) : super(key: key);

  @override
  State<_ChurchSelectionView> createState() => _ChurchSelectionViewState();
}

class _ChurchSelectionViewState extends State<_ChurchSelectionView> {
  Future<void> _previousPage() async {
    await Provider.of<PageController>(context, listen: false).previousPage(
      duration: kPagViewDuration,
      curve: kPagViewCurve,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _previousPage();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: CustomBackButton(onPressed: _previousPage),
          title: const Text('Church', style: kFontH6),
        ),
        body: ChurchSelectionView(
          onTap: (church) {
            if (church != null) {}
          },
        ),
      ),
    );
  }
}
