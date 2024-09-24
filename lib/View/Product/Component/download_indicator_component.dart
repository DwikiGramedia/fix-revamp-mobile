import 'package:flutter/material.dart';
import 'package:revamp_eperpus_mobile/Utils/style.dart';

class DownloadIndicatorComponent extends StatelessWidget {
  int length;
  int receive;
  DownloadIndicatorComponent(
      {Key? key, required this.length, required this.receive})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var progressSize = ((receive < 0 ? 100 : receive) / 100) * 100;
    return SizedBox(
      width: size.width * 0.8,
      height: 48,
      child: Center(
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              width: size.width * 0.8,
              color: Colors.grey,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: size.width * 0.8 * ((receive < 0 ? 100 : receive) / 100),
              color: primaryColor,
            ),
            Container(
                width: size.width * 0.8,
                height: 48,
                color: Colors.transparent,
                child:
                    Center(child: Text("${progressSize.toStringAsFixed(0)}%")))
          ],
        ),
      ),
    );
  }
}
