import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revamp_eperpus_mobile/Helpers/api_client.dart';
import 'package:revamp_eperpus_mobile/Utils/config.dart';
import 'package:revamp_eperpus_mobile/Utils/flutter_webview.dart';
import 'package:revamp_eperpus_mobile/Utils/style.dart';
import 'package:revamp_eperpus_mobile/Utils/utils.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/button.dart';
import 'package:revamp_eperpus_mobile/View/Profile/Component/about_us_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutUsView extends StatefulWidget {
  static const routeName = '/aboutus';

  AboutUsView({Key? key, this.isDark}) : super(key: key);

  int? isDark;

  @override
  State<StatefulWidget> createState() {
    return AboutUsViewState();
  }
}

class AboutUsViewState extends State<AboutUsView> {

  SharedPreferences? sharedPreferences;
  var buildName = "";
  var buildNumber = "";
  var rateUsVisible = true;

  Future<void> initStateData() async {
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      buildName = sharedPreferences!.getString('buildName')!;
      buildNumber = sharedPreferences!.getString('buildNumber')!;

      if (Platform.isIOS && FlavorConfig.instance.values.appstore!.isEmpty) {
        rateUsVisible = false;
      } else if (Platform.isAndroid && FlavorConfig.instance.values.playstore!.isEmpty) {
        rateUsVisible = false;
      }

    });
  }

  @override
  void initState() {
    initStateData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final bool isDark = widget.isDark == 1;
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Platform.isIOS
            ? Theme.of(context).cardColor
            : const Color(0xFF091A33),
        backgroundColor: Platform.isIOS
            ? Theme.of(context).scaffoldBackgroundColor
            : Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          localization.aboutUs,
          style: h4Title.apply(color: isDark ? Colors.white : Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left),
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            children: [
              AboutUsTile(
                  title: localization.termCondition,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FlutterWebView(
                          title: localization.termCondition,
                          url: localization.termOfServiceUrl,
                        ),
                      ),
                    );
                  }),
              AboutUsTile(
                  title: localization.privacyPolicy,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FlutterWebView(
                          title: localization.privacyPolicy,
                          url: localization.privacyPolicyUrl,
                        ),
                      ),
                    );
                  }),
              // AboutUsTile(title: "Help & Support", onTap: () {}),
              // SizedBox(
              //   height: size.height * 0.15,
              // ),
              const SizedBox(height: 48),
              SizedBox(
                width: size.width * 0.4,
                height: 160,
                child: Image.asset(
                  logoImage(
                    organization: ApiClient.instance.baseOrganizationId,
                  ),
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: size.width,
                child: Text(
                  "Ver. $buildName ($buildNumber)",
                  style: h6Title,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: size.width,
                child: Text(
                  // localization.aboutUsDescription,
                  localization.localeTag.contains("ID") ? FlavorConfig.instance.values.aboutUsID! :
                    FlavorConfig.instance.values.aboutUsEN!,
                  style: paragraph3,
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.center,
                ),
              ),
              Visibility(
                visible: FlavorConfig.instance.values.clientLogo!.isNotEmpty,
                child: Column(
                  children: [
                    SizedBox(
                      width: size.width * 0.4,
                      child: Image.asset(
                        FlavorConfig.instance.values.clientLogo!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // SizedBox(
              //   width: size.width,
              //   child: Text(
              //     "Powered by",
              //     style: subhead3,
              //     textAlign: TextAlign.center,
              //   ),
              // ),
              // const SizedBox(height: 16),
              Visibility(
                // visible: Platform.isAndroid,
                visible: rateUsVisible,
                child: SizedBox(
                  width: size.width,
                  height: 48,
                  child: Button(
                    title: localization.reviewUs,
                    onTap: () {
                      if (Platform.isAndroid) {
                        // launchUrlString("https://play.google.com/store/apps/details?id=com.appsfoundry.eperpuswl.id.blims");
                        launchUrlString(FlavorConfig.instance.values.playstore!);
                      } else {
                        // launchUrlString("https://apps.apple.com/us/app/blims/id1254398058");
                        launchUrlString(FlavorConfig.instance.values.appstore!);
                      }
                    },
                    radius: 12,
                    style: h4Title,
                    color: primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
