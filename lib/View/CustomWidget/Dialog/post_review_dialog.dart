import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revamp_eperpus_mobile/Utils/style.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/button.dart';
import 'package:revamp_eperpus_mobile/View/Product/Component/rating_bar.dart';
import 'package:revamp_eperpus_mobile/model/Product/library_product_model.dart';

class PostReviewDialog extends StatelessWidget {
  LibraryProductModel model;
  PostReviewDialog({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Nilai Buku ini",
                style: paragraph4.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF6E7178),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(model.coverImage!.href!),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    model.title!,
                    style: h5Title,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "by ${"model.vendor.title"}",
                    style: paragraph4.copyWith(),
                    maxLines: 2,
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              RatingbarWidget(
                currentRating: 5,
                opacityRating: 1.0,
                sizeIcon: 18,
              ),
              const SizedBox(width: 8),
              Text(
                "Sangat bagus",
                style: subhead3.copyWith(fontSize: 12),
              )
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                    color: Colors.black38,
                    spreadRadius: 3,
                    offset: Offset(2, 2))
              ],
            ),
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: "Jelaskan pengalaman membanca anda",
                hintStyle: paragraph4.apply(color: const Color(0xFF6E7178)),
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 6),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.025),
          SizedBox(
            width: size.width,
            height: 40,
            child: Button(
              title: "Post",
              onTap: () {},
              radius: 8,
              style: h5Title,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
