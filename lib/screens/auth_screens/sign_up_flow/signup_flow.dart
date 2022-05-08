import 'package:cop_belgium_app/providers/signup_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPageFlow extends StatefulWidget {
  final List<Widget> children;
  final PageController? controller;
  static String signUpScreen = 'signUpScreen';
  const SignUpPageFlow({
    Key? key,
    required this.children,
    required this.controller,
  }) : super(key: key);

  @override
  State<SignUpPageFlow> createState() => _SignUpPageFlowState();
}

class _SignUpPageFlowState extends State<SignUpPageFlow> {
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
        child: PageView(
          controller: widget.controller,
          physics: const NeverScrollableScrollPhysics(),
          children: widget.children,
        ),
      ),
    );
  }
}
