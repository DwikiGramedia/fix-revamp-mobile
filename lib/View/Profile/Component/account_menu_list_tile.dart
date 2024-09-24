import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:revamp_eperpus_mobile/Utils/style.dart';
import 'package:showcaseview/showcaseview.dart';

class AccountMenuListTile extends StatelessWidget {
  String title;
  IconData? leading;
  Function()? onTap;
  Widget? trailing;
  GlobalKey? showCaseKey = GlobalKey();
  String? showCaseTitle;
  String? showCaseDescription;
  AccountMenuListTile({
    Key? key,
    required this.title,
    required this.leading,
    required this.onTap,
    required this.trailing,
    this.showCaseKey,
    this.showCaseTitle,
    this.showCaseDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Showcase(
      targetPadding: const EdgeInsets.all(5),
      key: showCaseKey!,
      title: showCaseTitle,
      description: showCaseDescription,
      tooltipBackgroundColor: Theme.of(context).primaryColor,
      textColor: Colors.white,
      targetShapeBorder: const CircleBorder(),
      child: SizedBox(
        height: 48,
        child: ListTile(
          onTap: onTap,
          leading: Icon(leading),
          title: Text(title, style: subhead3),
          subtitle: const Divider(),
          trailing: trailing,
        ),
      ),
    );
  }
}
