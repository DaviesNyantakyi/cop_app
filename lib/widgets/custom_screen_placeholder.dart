import 'package:flutter/material.dart';

class CustomScreenPlaceholder extends StatelessWidget {
  const CustomScreenPlaceholder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Text(
          'Share your testimony',
          style: Theme.of(context).textTheme.headline6,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
