import 'package:flutter/material.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/Card/is_available_card.dart';

import 'package:revamp_eperpus_mobile/Utils/style.dart';

class CardBookAvailableWidget extends StatelessWidget {
  String image;
  String title;
  String name;
  int currentlyAvailable;
  Function() onTapClose;
  Function() onTapContent;
  double? width = double.infinity;
  CardBookAvailableWidget({
    Key? key,
    required this.currentlyAvailable,
    required this.title,
    required this.image,
    required this.name,
    required this.onTapClose,
    required this.onTapContent,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 144,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black26, offset: Offset(4, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTapContent,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 12, top: 12, bottom: 12),
                  width: 72,
                  height: 104,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: size.width * 0.5,
                            child: Text(
                              title,
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.3,
                            child: Text(
                              name,
                              style: Theme.of(context).textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          )
                        ],
                      ),
                      CardisAvailableWidget(
                          currentAvailable: currentlyAvailable)
                    ],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onTapClose,
            child: const Icon(
              Icons.close,
              color: Colors.red,
              size: 24,
            ),
          )
        ],
      ),
    );
  }
}
