import 'package:flutter/material.dart';

class RatingbarWidget extends StatelessWidget {
  double currentRating;
  double opacityRating;
  double sizeIcon;
  RatingbarWidget(
      {Key? key,
      required this.currentRating,
      required this.opacityRating,
      required this.sizeIcon})
      : super(key: key);

  Widget ratingBar(double rating) {
    if (rating < 1) {
      return Row(
        children: [
          Icon(
            Icons.star,
            color: Colors.grey,
            size: sizeIcon,
          ),
          Icon(
            Icons.star,
            color: Colors.grey,
            size: sizeIcon,
          ),
          Icon(
            Icons.star,
            color: Colors.grey,
            size: sizeIcon,
          ),
          Icon(
            Icons.star,
            color: Colors.grey,
            size: sizeIcon,
          ),
          Icon(
            Icons.star,
            color: Colors.grey,
            size: sizeIcon,
          )
        ],
      );
    } else if (rating < 2) {
      return Row(
        children: [
          Icon(
            Icons.star,
            color: Colors.yellow,
            size: sizeIcon,
          ),
          Icon(
            Icons.star,
            color: Colors.grey,
            size: sizeIcon,
          ),
          Icon(
            Icons.star,
            color: Colors.grey,
            size: sizeIcon,
          ),
          Icon(
            Icons.star,
            color: Colors.grey,
            size: sizeIcon,
          ),
          Icon(
            Icons.star,
            color: Colors.grey,
            size: sizeIcon,
          )
        ],
      );
    } else if (rating < 3) {
      return Row(
        children: [
          Icon(
            Icons.star,
            color: Colors.yellow,
            size: sizeIcon,
          ),
          Icon(
            Icons.star,
            color: Colors.yellow,
            size: sizeIcon,
          ),
          Icon(
            Icons.star,
            color: Colors.grey,
            size: sizeIcon,
          ),
          Icon(
            Icons.star,
            color: Colors.grey,
            size: sizeIcon,
          ),
          Icon(
            Icons.star,
            color: Colors.grey,
            size: sizeIcon,
          )
        ],
      );
    } else if (rating < 4) {
      return Row(
        children: [
          Icon(
            Icons.star,
            color: Colors.yellow,
            size: sizeIcon,
          ),
          Icon(
            Icons.star,
            color: Colors.yellow,
            size: sizeIcon,
          ),
          Icon(
            Icons.star,
            color: Colors.yellow,
            size: sizeIcon,
          ),
          Icon(
            Icons.star,
            color: Colors.grey,
            size: sizeIcon,
          ),
          Icon(
            Icons.star,
            color: Colors.grey,
            size: sizeIcon,
          )
        ],
      );
    } else if (rating < 5) {
      return Row(
        children: [
          Icon(
            Icons.star,
            color: Colors.yellow,
            size: sizeIcon,
          ),
          Icon(
            Icons.star,
            color: Colors.yellow,
            size: sizeIcon,
          ),
          Icon(
            Icons.star,
            color: Colors.yellow,
            size: sizeIcon,
          ),
          Icon(
            Icons.star,
            color: Colors.yellow,
            size: sizeIcon,
          ),
          Icon(
            Icons.star,
            color: Colors.grey,
            size: sizeIcon,
          )
        ],
      );
    } else if (rating == 5) {
      return Row(
        children: [
          Icon(
            Icons.star,
            color: Colors.yellow,
            size: sizeIcon,
          ),
          Icon(
            Icons.star,
            color: Colors.yellow,
            size: sizeIcon,
          ),
          Icon(
            Icons.star,
            color: Colors.yellow,
            size: sizeIcon,
          ),
          Icon(
            Icons.star,
            color: Colors.yellow,
            size: sizeIcon,
          ),
          Icon(
            Icons.star,
            color: Colors.yellow,
            size: sizeIcon,
          )
        ],
      );
    } else {
      return const Text("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(seconds: 2),
      opacity: 1,
      child: ratingBar(currentRating),
    );
  }
}
