// Generated, built and configurated privately for Gramedia Asri Media projects
// Any use of this content without permission will be a legal violation
// ============================================================================
// @author Samuel O R Napitupulu
// @email samuel.napitupulu@gramedia.id
// @create date 2022-03-27 02:55:36
// @modify date 2022-03-30 02:38:16
// @desc [description]
// ============================================================================
// Copyrigthed Gramedia Asri Media 2022-03-27 02:55:36

import 'dart:convert';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revamp_eperpus_mobile/Utils/config.dart';
import 'package:revamp_eperpus_mobile/Utils/style.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/Dialog/change_language_dialog.dart';
import 'package:revamp_eperpus_mobile/View/TermsPolicy/privacy_and_policy.dart';
import 'package:shared_preferences/shared_preferences.dart';

const pageIndex = 0;

class OnBoardingView extends StatefulWidget {
  static const routeName = '/onBoard';

  const OnBoardingView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  int selectedPage = 0;
  String codeLocal = "id";
  String authStatus = 'Unknown';

  final PageController _pageViewController = PageController(
    initialPage: 0,
    keepPage: false,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initPlugin());
  }

  Future<void> initPlugin() async {
    String currentStatus;
    try {
      final TrackingStatus trackingAuthStatus =
          await AppTrackingTransparency.trackingAuthorizationStatus;
      currentStatus = '$trackingAuthStatus';
      if (trackingAuthStatus == TrackingStatus.notDetermined) {
        final TrackingStatus authStatusReq =
            await AppTrackingTransparency.requestTrackingAuthorization();
        currentStatus = '$authStatusReq';
      }
      setState(() => authStatus = currentStatus);
    } on PlatformException {
      setState(() => authStatus = 'PlatformException was thrown');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? clientName = FlavorConfig.instance.values.appName == "PerpusKOMINFO" ? "RuangBukuKom" : FlavorConfig.instance.values.appName;
    var onBoardingJson = '['
        '{"title": "${"${AppLocalizations.of(context)!.titleonboardfirst} $clientName"}","image": "assets/images/onboarding1.jpg", "subtitle": "$clientName ${AppLocalizations.of(context)!.descriptionboardfirst}"},'
        '{"title": "${AppLocalizations.of(context)!.titleonboardsecond}","image": "assets/images/onboarding2.jpg", "subtitle": "${AppLocalizations.of(context)!.descriptionboardsecond}"},'
        '{"title": "${AppLocalizations.of(context)!.titleonboardthird}","image": "assets/images/onboarding3.jpg", "subtitle": "${AppLocalizations.of(context)!.descriptionboardthird}"},'
        '{"title": "${AppLocalizations.of(context)!.titleonboardfourth}","image": "assets/images/onboarding4.jpg", "subtitle": "${AppLocalizations.of(context)!.descriptionboardfourth}"}'
        ']';

    var onBoardingPages =
        OnBoardingData.fromJsonArray(jsonDecode(onBoardingJson));

    void onFinishOnBoardingClicked(context) async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setBool("firstTimeVisitApp", false);
      String data = sharedPreferences.getString("codeLanguage") ?? "id";
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => PrivacyAndPolicyView(
                    locale: data,
                  )),
          (route) => false);
    }

    List<Widget> buildPageIndicator() {
      List<Widget> list = [];
      for (int i = 0; i < onBoardingPages.length; i++) {
        list.add(
            i == selectedPage ? buildIndicator(true) : buildIndicator(false));
      }
      return list;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Platform.isIOS ? Colors.white : Colors.transparent,
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return ChangeLanguageDialog();
                  },
                );
              },
              child: Material(
                elevation: 3,
                shadowColor: Colors.grey,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(4.0),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    AppLocalizations.of(context)!.language,
                    style: h6Title.copyWith(color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageViewController,
                    onPageChanged: (index) {
                      setState(() {
                        selectedPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              height: 260,
                              child: Image.asset(
                                onBoardingPages[index].image,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Text(
                                onBoardingPages[index].title,
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Text(
                                onBoardingPages[index].subtitle,
                                textAlign: TextAlign.center,
                                softWrap: true,
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      );
                    },
                    itemCount: onBoardingPages.length,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: buildPageIndicator(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            color: Colors.white,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: (selectedPage < (onBoardingPages.length - 1))
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            _pageViewController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue[800],
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 15,
                            ),
                          ),
                          icon: const Icon(Icons.arrow_back),
                          label: Text(
                            AppLocalizations.of(context)!.next,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => onFinishOnBoardingClicked(context),
                          style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            primary: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 15,
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.skip,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'Nunito',
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => onFinishOnBoardingClicked(context),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue[800],
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 15,
                            ),
                          ),
                          icon: const Icon(Icons.arrow_back),
                          label: Text(
                            AppLocalizations.of(context)!.getStarted,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 16)
        ],
      ),
    );
  }
}

Widget buildIndicator(bool isActive) {
  return SizedBox(
    height: 10,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      height: isActive ? 10 : 8.0,
      width: isActive ? 10 : 8.0,
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

class OnBoardingData {
  String image = '';
  String title = '';
  String subtitle = '';

  OnBoardingData.fromJson(Map<String, dynamic> json)
      : image = json['image'] as String,
        title = json['title'] as String,
        subtitle = json['subtitle'] as String;

  static List<OnBoardingData> fromJsonArray(List<dynamic> data) {
    return data.map((datum) => OnBoardingData.fromJson(datum)).toList();
  }
}
