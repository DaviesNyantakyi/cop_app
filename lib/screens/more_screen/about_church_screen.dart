import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/load_markdown.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/cop_logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../church_selection_screen/church_selection_screen.dart';

class AboutChruchScreen extends StatelessWidget {
  const AboutChruchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(context: context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: kContentSpacing16),
          child: Column(
            children: [
              _buildLogo(),
              const SizedBox(height: kContentSpacing32),
              ListTile(
                title: Text(
                  'Abous us',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                onTap: () async {
                  loadMarkdownFile(
                    context: context,
                    mdFile: "assets/about_church/about_us.md",
                  );
                },
              ),
              ListTile(
                title: Text(
                  'Values',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                onTap: () async {
                  loadMarkdownFile(
                    context: context,
                    mdFile: "assets/about_church/core_values.md",
                  );
                },
              ),
              ListTile(
                title: Text(
                  'Mission & Vission',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                onTap: () async {
                  loadMarkdownFile(
                    context: context,
                    mdFile: "assets/about_church/mission_and_vission.md",
                  );
                },
              ),
              ListTile(
                title: Text(
                  'Tenets',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                onTap: () async {
                  loadMarkdownFile(
                    context: context,
                    mdFile: "assets/about_church/tenets.md",
                  );
                },
              ),
              ListTile(
                title: Text(
                  'Churches',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                onTap: () async {
                  await Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const _ChurchesScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return const CopLogo(width: 100, height: 100);
  }

  dynamic _buildAppbar({required BuildContext context}) {
    return AppBar(
      leading: const CustomBackButton(),
      title: Text(
        'About Church',
        style: Theme.of(context)
            .textTheme
            .headline6
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ChurchesScreen extends StatelessWidget {
  const _ChurchesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChurchSelectionScreen(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Text(
          'Churches',
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      onTap: (church) {},
    );
  }
}
