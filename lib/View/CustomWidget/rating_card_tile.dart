import 'package:flutter/material.dart';
import 'package:revamp_eperpus_mobile/Utils/style.dart';
import 'package:revamp_eperpus_mobile/View/Product/Component/rating_bar.dart';
import 'package:revamp_eperpus_mobile/model/Product/ReviewModel/review_model.dart';

class RatingCardTile extends StatelessWidget {
  final Review? item;
  const RatingCardTile({Key? key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name = item!.firstName!;
    String date = item!.reviewDate!;
    String review = item!.reviewText!;
    double rating = double.parse(item!.rating.toString());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 8),
              width: 60,
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: paragraph5.apply(color: lightBlue),
              ),
            ),
            // CardLevelWidget(
            //   isLittle: true,
            //   level: Level.bookworm,
            // ),
            Expanded(
              child: Text(
                date,
                textAlign: TextAlign.right,
                style: paragraph5.apply(color: lightBlue),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: RatingbarWidget(
            currentRating: rating,
            opacityRating: 1.0,
            sizeIcon: 12,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                review,
                style: paragraph3.copyWith(color: Colors.grey),
              ),
            ),
            // IconButton(
            //   onPressed: () {},
            //   icon: const Icon(
            //     Icons.flag,
            //     color: Colors.red,
            //   ),
            // ),
          ],
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
