import 'dart:io';

import 'package:flutter/material.dart';
import 'package:revamp_eperpus_mobile/Utils/style.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/button_with_icon.dart';

Future<dynamic> showTaskCompletedBottomSheet(BuildContext context,
    {required VoidCallback onButtonPressed}) async {
  showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
    ),
    isScrollControlled: true,
    context: context,
    builder: (context) => TaskCompletedDialog(
      onButtonPressed: onButtonPressed,
    ),
  );
}

class TaskCompletedDialog extends StatelessWidget {
  final VoidCallback? onButtonPressed;

  const TaskCompletedDialog({
    Key? key,
    this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
    // TODO: implement for IOS
        ? Container()
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/icon_assets/logoperpusblue.png',
                ),
                Image.asset(
                  'assets/images/taskComplete.png',
                  width: 260,
                  height: 212,
                ),
                const SizedBox(height: 24),
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Selamat, ',
                        style: h4Title,
                      ),
                      TextSpan(
                        text: ' Febryan Stefanus!!',
                        style: h4Title.apply(color: primaryColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Kamu berhasil menyelesaikan tantangan untuk membaca buku pertamamu.',
                  style: paragraph4.apply(color: const Color(0xFF6E7178)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ButtonWithIcon(
                  color: primaryColor,
                  title: "Bagikan",
                  onTap: () {},
                  minimumSize: Size(MediaQuery.of(context).size.width, 47),
                  radius: 12,
                  style: h6Title.copyWith(fontSize: 18, color: Colors.white),
                  iconImage: 'assets/images/uploadIcon.png',
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
  }
}
