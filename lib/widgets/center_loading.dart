import 'package:flutter/material.dart';


class CenterCircularLoading extends StatelessWidget {
  final bool showProgress;

  const CenterCircularLoading({
    Key? key,
    this.showProgress = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: Colors.blue,
          ),

        ],
      ),
    );
  }
}
