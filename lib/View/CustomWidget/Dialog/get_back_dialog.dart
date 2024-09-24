import 'dart:io';

import 'package:flutter/material.dart';
import 'package:revamp_eperpus_mobile/Utils/style.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/button.dart';

Future<dynamic> showGetBackBottomSheet(BuildContext context,
    {required VoidCallback onButtonPressed}) async {
  showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
    ),
    isScrollControlled: true,
    context: context,
    builder: (context) => GetBackDialog(
      onButtonPressed: onButtonPressed,
    ),
  );
}

class GetBackDialog extends StatelessWidget {
  final VoidCallback? onButtonPressed;

  const GetBackDialog({
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
                Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(8),
                  shadowColor: const Color(0xFF000000),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(11, 6, 9, 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/feelingDown.png',
                          width: 93,
                          height: 67,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ayo kembali!',
                                style: h6Title,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Kamu tidak aktif akhir-akhir ini, itu akan mempengaruhi XP kamu loh',
                                style: paragraph4,
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Level membaca merupakan fitur baru untuk meningkatkan antusias para pembaca buku. Dengan membaca buku, menulis ulasan, dan menyelesaikan tantangan kamu akan mendapatkan XP untuk menaikan level membaca.',
                  style: paragraph4,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 24),
                Text(
                  'Info lebih lanjut',
                  style: h6Title,
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
                  title: "Dapatkan XP",
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
