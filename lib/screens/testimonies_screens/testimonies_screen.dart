import 'package:cop_belgium_app/screens/podcast_screens/podcast_player_screen.dart';
import 'package:cop_belgium_app/screens/podcast_screens/podcast_screen.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/back_button.dart';
import 'package:cop_belgium_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

class TestimoniesScreen extends StatefulWidget {
  const TestimoniesScreen({Key? key}) : super(key: key);

  @override
  State<TestimoniesScreen> createState() => _TestimoniesScreenState();
}

class _TestimoniesScreenState extends State<TestimoniesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: kContentSpacing16,
              vertical: kContentSpacing24,
            ),
            child: ListView.separated(
              itemCount: 20,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => const TestimonyCard(),
              separatorBuilder: (context, index) => const SizedBox(
                height: kContentSpacing8,
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    return AppBar(
      leading: CustomBackButton(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text(
        'Testimonies',
        style: kFontH6,
      ),
    );
  }
}

class TestimonyCard extends StatefulWidget {
  const TestimonyCard({Key? key}) : super(key: key);

  @override
  State<TestimonyCard> createState() => _TestimonyCardState();
}

class _TestimonyCardState extends State<TestimonyCard> {
  final popupMenuKey = GlobalKey<PopupMenuButtonState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.all(
          Radius.circular(kRadius),
        ),
      ),
      child: CustomElevatedButton(
        padding: const EdgeInsets.all(kContentSpacing8),
        child: Column(
          children: [
            _headerInfo(),
            const SizedBox(
              height: kContentSpacing12,
            ),
            const Text(
              paragrapgh,
              maxLines: 5,
              style: kFontBody,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        onPressed: () {},
      ),
    );
  }

  Widget _headerInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage(unsplashPhotoUrl),
              radius: 24,
            ),
            const SizedBox(width: kContentSpacing12),
            Padding(
              padding: const EdgeInsets.only(top: kContentSpacing4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rick Wright',
                    style: kFontBody2.copyWith(
                      fontWeight: kFontWeightMedium,
                    ),
                  ),
                  const Text(
                    '24 Dec 2019 - 14:45',
                    style: kFontCaption,
                  ),
                ],
              ),
            ),
          ],
        ),
        Flexible(
          child: CustomElevatedButton(
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero,
            onPressed: () {
              popupMenuKey.currentState?.showButtonMenu();
            },
            child: PopupMenuButton<double>(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(kRadius),
                ),
              ),
              key: popupMenuKey,
              // Callback that sets the selected popup menu item.
              onSelected: (item) {},
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: 0.5,
                  child: const Text('Edit', style: kFontBody),
                  onTap: () {},
                ),
                PopupMenuItem(
                  value: 0.5,
                  child: Text('Delete', style: kFontBody.copyWith(color: kRed)),
                  onTap: () {
                    setState(() {});
                  },
                ),
              ],
              child: const Icon(
                Icons.more_vert_rounded,
                color: kBlack,
              ),
            ),
          ),
        )
      ],
    );
  }
}
