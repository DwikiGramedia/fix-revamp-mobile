import 'dart:io';

import 'package:flutter/material.dart';
import 'package:revamp_eperpus_mobile/Utils/style.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/button.dart';

Future<dynamic> showOnGoingTaskBottomSheet(BuildContext context,
    {required VoidCallback onButtonPressed}) async {
  showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
    ),
    isScrollControlled: true,
    context: context,
    builder: (context) => OnGoingTaskDialog(
      onButtonPressed: onButtonPressed,
    ),
  );
}

class OnGoingTaskDialog extends StatelessWidget {
  final VoidCallback? onButtonPressed;

  const OnGoingTaskDialog({
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 32),
                Center(
                  child: Image.asset(
                    'assets/images/reviewedDocs.png',
                    width: 168,
                    height: 88,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tulis 10 ulasan tahun ini',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Tulis 9 ulasan lagi',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6E7178),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Info lebih lanjut',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: '${String.fromCharCode(0x2022)}  '
                            'Menyelesai buku akan mendapatkan',
                        style: paragraph4,
                      ),
                      TextSpan(
                        text: ' 10 XP!',
                        style: paragraph4.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: '${String.fromCharCode(0x2022)}  '
                            'Memberi ulasan pada buku akan mendapatkan',
                        style: paragraph4,
                      ),
                      TextSpan(
                        text: ' 5 XP!',
                        style: paragraph4.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${String.fromCharCode(0x2022)}  '
                  'Menyelesaikan tantangan akan mendapatkan XP tertentu.',
                  style: paragraph4,
                ),
                const SizedBox(height: 32),
                Button(
                  color: primaryColor,
                  title: "Tulis ulasan",
                  onTap: () {},
                  minimumSize: Size(MediaQuery.of(context).size.width, 47),
                  radius: 12,
                  style: h6Title.copyWith(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
  }
}
