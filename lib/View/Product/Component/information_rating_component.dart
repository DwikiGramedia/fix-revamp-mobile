import 'package:flutter/material.dart';
import 'package:revamp_eperpus_mobile/Utils/style.dart';

import 'progress_bar.dart';
import 'rating_bar.dart';

class InformationRatingComponent extends StatelessWidget {
  double currentRating;
  double opacityRating;
  double sizeIcon;
  double allTotalRating;
  int totalRating;
  bool isAnimation;

  InformationRatingComponent(
      {Key? key,
      required this.totalRating,
      required this.allTotalRating,
      required this.sizeIcon,
      required this.opacityRating,
      required this.currentRating,
      required this.isAnimation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        RatingbarWidget(
          currentRating: currentRating,
          opacityRating: opacityRating,
          sizeIcon: sizeIcon,
        ),
        const SizedBox(width: 4),
        ProgressbarWidget(
          allTotalRating: allTotalRating,
          totalRating: totalRating.toDouble(),
          isAnimation: isAnimation,
        ),
        const SizedBox(width: 4),
        Text(
          "$totalRating",
          style: subhead3.copyWith(fontSize: 10, color: Colors.black),
        )
      ],
    );
  }
}
