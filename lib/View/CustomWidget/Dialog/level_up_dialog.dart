import 'dart:io';

import 'package:flutter/material.dart';
import 'package:revamp_eperpus_mobile/Utils/style.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/button_with_icon.dart';

Future<dynamic> showLevelUpBottomSheet(BuildContext context,
    {required VoidCallback onButtonPressed}) async {
  showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
    ),
    isScrollControlled: true,
    context: context,
    builder: (context) => LevelUpDialog(
      onButtonPressed: onButtonPressed,
    ),
  );
}

class LevelUpDialog extends StatelessWidget {
  final VoidCallback? onButtonPressed;

  const LevelUpDialog({
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
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(height: 20),
                    Image.asset(
                      'assets/icon_assets/logoperpusblue.png',
                      fit: BoxFit.contain,
                      width: 227,
                      height: 101,
                    ),
                    Image.asset(
                      'assets/images/finish.png',
                      width: 260,
                      height: 212,
                    ),
                    const SizedBox(height: 24),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Selamat, \nkamu adalah',
                            style: h4Title,
                          ),
                          TextSpan(
                            text: ' Good Reader',
                            style: h4Title.apply(color: primaryColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Pertahankan! Kamu telah membaca total',
                            style: paragraph4,
                          ),
                          TextSpan(
                            text: ' 10 Buku',
                            style: paragraph4.copyWith(
                                fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text: ' dan menulis',
                            style: paragraph4,
                          ),
                          TextSpan(
                            text: ' 8 Ulasan',
                            style: paragraph4.copyWith(
                                fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text: ' Lanjutkan perjalanan membaca kamu dan '
                                'mencapai level membaca teratas!',
                            style: paragraph4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 75),
                    ButtonWithIcon(
                      color: primaryColor,
                      title: "Bagikan",
                      onTap: () {},
                      minimumSize: Size(MediaQuery.of(context).size.width, 47),
                      radius: 12,
                      style:
                          h6Title.copyWith(fontSize: 18, color: Colors.white),
                      iconImage: 'assets/images/uploadIcon.png',
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
                Container(
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.only(top: 54),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close),
                  ),
                )
              ],
            ),
          );
  }
}
