import 'package:flutter/material.dart';
import 'package:revamp_eperpus_mobile/Utils/style.dart';

class CardisAvailableWidget extends StatelessWidget {
  int currentAvailable;
  CardisAvailableWidget({Key? key, required this.currentAvailable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Color> colorLevel(int products) {
      if (products > 0) {
        return [newExpColorBottom, newExpColorTop];
      } else {
        return [Theme.of(context).primaryColor];
      }
    }

    Color fontColor(int products) {
      if (products > 0) {
        return Colors.white;
      } else {
        return Theme.of(context).highlightColor;
      }
    }

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          gradient: LinearGradient(
              colors: colorLevel(currentAvailable),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight)),
      width: 80,
      height: 16,
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 6,
          ),
          Text(
            "${currentAvailable > 0 ? "Available" : "Out of stock"}",
            style: h6Title.copyWith(
                color: fontColor(currentAvailable), fontSize: 9),
          ),
        ],
      )),
    );
  }
}
