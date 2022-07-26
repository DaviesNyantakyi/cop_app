import 'package:flutter/material.dart';

import '../../services/podcast_service.dart';
import '../../utilities/constant.dart';
import '../../widgets/back_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final getTrending = PodcastService().fetchTrending(reload: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(kContentSpacing16),
          child: Column(
            children: const [],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    return AppBar(
      leading: const CustomBackButton(),
      title: Text('Profile', style: Theme.of(context).textTheme.headline6),
    );
  }
}
