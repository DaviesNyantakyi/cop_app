import 'package:cop_belgium_app/utilities/constant.dart';
import 'package:cop_belgium_app/utilities/responsive.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SermonScreenSkeleton extends StatelessWidget {
  const SermonScreenSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, screenInfo) {
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 7,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount(screenInfo),
          mainAxisExtent: 250,
          crossAxisSpacing: gradSpacing(screenInfo),
        ),
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 210,
                width: 200,
                decoration: const BoxDecoration(
                  color: kGreyLight,
                  borderRadius: BorderRadius.all(
                    Radius.circular(kRadius),
                  ),
                ),
              ),
              const SizedBox(height: kContentSpacing8),
              Text(
                '...',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );
        },
      );
    });
  }
}
