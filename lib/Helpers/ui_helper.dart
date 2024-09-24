// Generated, built and configurated privately for Gramedia Asri Media projects
// Any use of this content without permission will be a legal violation
// ============================================================================
// @author Samuel O R Napitupulu
// @email samuel.napitupulu@gramedia.id
// @create date 2022-03-30 18:06:00
// @modify date 2022-03-30 18:06:00
// @desc [description]
// ============================================================================
// Copyrigthed Gramedia Asri Media 2022-03-30 18:06:00

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UIHelper {
  static List<Widget> buildRatingStarView(starRated, double viewHeight) {
    List<Widget> list = [];
    for (int i = 1; i <= 5; i++) {
      list.add(i <= starRated
          ? Icon(
              Icons.star_rounded,
              size: viewHeight,
            )
          : Icon(
              Icons.star_outline_rounded,
              size: viewHeight,
            ));
    }
    return list;
  }

  static List<Widget> buildPageIndicator(
      int pageLength, int selectedPage, BuildContext context,
      {double indicatorSize = 10}) {
    List<Widget> list = [];
    for (int i = 0; i < pageLength; i++) {
      list.add(i == selectedPage
          ? _getPageViewIndicator(true, indicatorSize, context)
          : _getPageViewIndicator(false, indicatorSize, context));
    }
    return list;
  }

  static Widget _getPageViewIndicator(
      bool isActive, double indicatorSize, BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: indicatorSize,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        height: isActive ? indicatorSize : indicatorSize * 0.8,
        width: isActive ? indicatorSize : indicatorSize * 0.8,
        decoration: BoxDecoration(
          boxShadow: [
            isActive
                ? BoxShadow(
                    color: Colors.blue.withOpacity(0.72),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                    offset: const Offset(0.0, 0.0),
                  )
                : const BoxShadow(color: Colors.transparent)
          ],
          shape: BoxShape.circle,
          color: isActive ? Colors.blue[800] : Colors.black38,
        ),
      ),
    );
  }

  static Future<void> showLoadingDialog(
      BuildContext dialogContext, String dialogMessage) async {
    return showDialog<void>(
      context: dialogContext,
      barrierDismissible: false, // user must tap button!
      builder: (dialogContext) {
        return AlertDialog(
          elevation: 3.0,
          shape: Border.all(
            color: Colors.white,
          ),
          buttonPadding: const EdgeInsets.all(0),
          title: Text(
            AppLocalizations.of(dialogContext)!.pleaseWait,
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            width: 200,
            height: 150,
            child: Column(
              children: [
                const SizedBox(height: 30),
                const SpinKitFoldingCube(
                  color: Colors.blue,
                ),
                const SizedBox(height: 30),
                Text(
                  dialogMessage,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
