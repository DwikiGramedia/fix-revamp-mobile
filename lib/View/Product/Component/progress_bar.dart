import 'package:flutter/material.dart';

class ProgressbarWidget extends StatelessWidget {
  double totalRating;
  double allTotalRating;
  bool isAnimation;
  ProgressbarWidget(
      {Key? key,
      required this.allTotalRating,
      required this.totalRating,
      required this.isAnimation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          width: size.width * 0.3,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        AnimatedContainer(
          height: 10,
          width: isAnimation
              ? 0
              : size.width * 0.3 * (totalRating / allTotalRating),
          decoration: BoxDecoration(
            color: Colors.green[300],
            borderRadius: BorderRadius.circular(8),
          ),
          duration: const Duration(seconds: 2),
        ),
      ],
    );
  }
}
