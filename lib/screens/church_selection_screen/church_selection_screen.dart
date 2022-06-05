import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cop_belgium_app/models/church_model.dart';
import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/widgets/church_tile.dart';
import 'package:cop_belgium_app/widgets/custom_error_widget.dart';
import 'package:cop_belgium_app/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';

Future<void> precacheChurchImages({required BuildContext context}) async {
  final churchesDoc =
      await FirebaseFirestore.instance.collection('churches').get();
  await Future.wait(churchesDoc.docs.map((doc) {
    return precacheImage(
      CachedNetworkImageProvider(doc.data()['imageURL']),
      context,
    );
  }));
}

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(kContentSpacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('churches')
                    .orderBy('churchName')
                    .snapshots(),
                builder: (context, snapshot) {
                  final data = snapshot.data;

                  if (snapshot.hasError) {
                    return CustomErrorWidget(
                      onPressed: () {
                        setState(() {});
                      },
                    );
                  }

                  if (snapshot.hasData && snapshot.data != null) {
                    // Get all the churches information and turn it into a ChurchModel.
                    List<ChurchModel>? churches = data?.docs.map((map) {
                      return ChurchModel.fromMap(map: map.data());
                    }).toList();
                    // Show message when the return list of churches is empty.
                    if (churches!.isEmpty) {
                      return Text(
                        'No result found',
                        style: Theme.of(context).textTheme.bodyText1,
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select your church',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        const SizedBox(height: kContentSpacing24),
                        ListView.separated(
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
                        ),
                      ],
                    );
                  }

                  return const Center(
                    child: CustomCircularProgressIndicator(),
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
