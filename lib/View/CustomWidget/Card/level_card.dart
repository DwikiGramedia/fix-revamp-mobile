import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:revamp_eperpus_mobile/Utils/style.dart';

enum Level { bookworm, goodreader, newcomer }

class CardLevelWidget extends StatelessWidget {
  bool isLittle;
  Level level;

  CardLevelWidget({Key? key, required this.isLittle, required this.level})
      : super(key: key);

  String levelCurrent(Level level) {
    switch (level) {
      case Level.bookworm:
        // TODO: Handle this case.
        return "Bookworm";

      case Level.goodreader:
        // TODO: Handle this case.
        return "Good Reader";
      case Level.newcomer:
        // TODO: Handle this case.
        return "Newcomer";
    }
  }

  List<Color> colorLevel(Level level) {
    switch (level) {
      case Level.bookworm:
        // TODO: Handle this case.
        return [bookWormColorBottom, bookWormColorTop];

      case Level.goodreader:
        // TODO: Handle this case.
        return [goodReaderColorBottom, goodReaderColorTop];
      case Level.newcomer:
        // TODO: Handle this case.
        return [newComerColorBottom, newComerColorTop];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: LinearGradient(
          colors: colorLevel(level),
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      width: isLittle ? 80 : 120,
      height: isLittle ? 16 : 24,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.white,
              size: isLittle ? 10 : 16,
            ),
            const SizedBox(width: 6),
            Text(
              levelCurrent(level),
              style: h6Title.copyWith(
                color: Colors.white,
                fontSize: isLittle ? 9 : 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
