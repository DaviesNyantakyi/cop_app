import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cop_belgium_app/models/church_model.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/church_tile.dart';
import 'package:cop_belgium_app/widgets/textfield.dart';
import 'package:flutter/material.dart';

class ChurchSelectionScreen extends StatefulWidget {
  final Function(ChurchModel?)? onTap;

  final PreferredSizeWidget? appBar;

  final Future<bool> Function()? onWillPop;
  const ChurchSelectionScreen({
    Key? key,
    this.onTap,
    this.appBar,
    this.onWillPop,
  }) : super(key: key);

  @override
  _ChurchSelectionScreenState createState() => _ChurchSelectionScreenState();
}

class _ChurchSelectionScreenState extends State<ChurchSelectionScreen> {
  ChurchModel? selectedChurch;

  TextEditingController searchContlr = TextEditingController();

  void searchChanges() {
    searchContlr.addListener(() {
      setState(() {});
    });
  }

  @override
  void initState() {
    searchChanges();
    super.initState();
  }

  @override
  void dispose() {
    searchContlr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(kContentSpacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: searchContlr,
                hintText: 'Search',
                maxLines: 1,
              ),
              const SizedBox(height: kContentSpacing32),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: searchContlr.text.isEmpty
                    ? FirebaseFirestore.instance
                        .collection('churches')
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('churches')
                        .where('searchIndex',
                            arrayContains: searchContlr.text.toLowerCase())
                        .snapshots(),
                builder: (context, snapshot) {
                  final data = snapshot.data;

                  // Show loading indicator when churches are being loaded.
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: kCircularProgressIndicator);
                  }

                  // Turn each church data into an ChurchModel.
                  List<ChurchModel>? churches = data?.docs.map((map) {
                    return ChurchModel.fromMap(map: map.data());
                  }).toList();

                  // Show message when the return list of churches is empty.
                  if (churches!.isEmpty) {
                    return const Text('No result found', style: kFontBody);
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ChurchTile(
                        church: churches[index],
                        onTap: () async {
                          selectedChurch = churches[index];

                          widget.onTap!(selectedChurch);
                        },
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      height: kContentSpacing8,
                    ),
                    itemCount: churches.length,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
