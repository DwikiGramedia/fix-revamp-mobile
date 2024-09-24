import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:revamp_eperpus_mobile/Utils/style.dart';

class AboutUsTile extends StatelessWidget {
  Function() onTap;
  String title;

  AboutUsTile({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: subhead3,
        ),
        subtitle: const Divider(),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
