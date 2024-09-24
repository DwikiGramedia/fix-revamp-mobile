import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import "package:firebase_app_installations/firebase_app_installations.dart";
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:revamp_eperpus_mobile/Cubit/user_cubit.dart';
import 'package:revamp_eperpus_mobile/Service/database_helper.dart';
import 'package:revamp_eperpus_mobile/Service/user_service.dart';
import 'package:revamp_eperpus_mobile/Service/watermark_service.dart';
import 'package:revamp_eperpus_mobile/Utils/style.dart';
import 'package:revamp_eperpus_mobile/Utils/utils.dart';
import 'package:revamp_eperpus_mobile/View/Onboarding/onboarding.dart';
import 'package:revamp_eperpus_mobile/View/SignIn/signin_view.dart';
import 'package:revamp_eperpus_mobile/Helpers/api_client.dart';
import 'package:revamp_eperpus_mobile/Helpers/api_constant.dart';
import 'package:revamp_eperpus_mobile/Helpers/app_theme_pref.dart';
import 'package:revamp_eperpus_mobile/Helpers/cache.dart';
import 'package:revamp_eperpus_mobile/Helpers/util_constant.dart';
import 'package:revamp_eperpus_mobile/home_view.dart';
import 'package:revamp_eperpus_mobile/model/User/user_model.dart';
import 'package:revamp_eperpus_mobile/model/Watermark/WatermarkResponse.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashView extends StatefulWidget {
  static const routeName = '/splash';

  const SplashView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SplashViewState();
}

class SplashViewState extends State<SplashView> {
  SharedPreferences? preferences;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  // final remoteConfig = FirebaseRemoteConfigService();

  Future<void> setVersionAndToken() async {
    preferences = await SharedPreferences.getInstance();
    final String? token = preferences?.getString("JWT");
    ApiClient.setAuth(token!);
    var date = DateTime.now();
    DatabaseHelper helper = DatabaseHelper();
    List<SavedBook> books = await helper.getBooks();
    for (var element in books) {
      if (element.date == date.toString()) {
        helper.deleteBook(element.productId);
      }
    }
  }

  int? userId;
  String? userEmail;

  Future<void> getUserData() async {
    try {
      GetDataUserResponse? user = await UserService().getDataUser(
        context: context,
      );
      print("User Id: ${user.id}");
      userId = user.id;
      userEmail = user.email;
    } catch (e) {
      debugPrint("Error getUserData: $e");
    }
  }

  String? sessionName = '';

  Future<void> setSessionNameCache() async {
    // await MessagingService().requestNotification();
    DateTime dateNow = DateTime.now();
    String id = await FirebaseInstallations.instance.getId();
    sessionName = await getSessionName();
    if (sessionName!.isEmpty) {
      setSessionName("$id$dateNow");
      sessionName = "$id$dateNow";
    }
  }

  Future<void> getWatermarkData() async {
    await getUserData();
    var now = DateTime.now();
    var formatter = DateFormat('ddMMyy');
    String formattedDate = formatter.format(now);
    String watermarkCode = "";
    try {
      WatermarkResponse watermark = await WatermarkService().getWatermark();
      debugPrint("WATERMARK from ENDPOINT: ${watermark.toJson().toString()}");
      watermarkCode = "$userEmail/$formattedDate/${watermark.code}";

      debugPrint("WATERMARK: $watermarkCode");
      await setWatermark(watermarkCode);
    } catch (e, s) {
      debugPrint("WATERMARK EXCEPTION: $e");
      debugPrint("WATERMARK STACKTRACE: $s");

      watermarkCode =
          "$userEmail/$formattedDate/${ApiClient.instance.watermark}";
      await setWatermark(watermarkCode);
    }
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.black,
      ),
    );
    // print("Remote Config Fetch: ${remoteConfig.getString(FirebaseRemoteConfigKeys.welcomeMessage)}");
    setSessionNameCache();
    initNavigation();
    // getWatermarkData();
    // setVersionAndToken();
    super.initState();
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': '',
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  Future<void> initNavigation() async {
    preferences = await SharedPreferences.getInstance();
    bool? isFirstVisited = preferences?.getBool('firstTimeVisitApp');
    String? isLoggedIn = preferences?.getString("JWT");

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    var buildName = packageInfo.version;
    var buildNumber = packageInfo.buildNumber;

    preferences?.setString(
        "userAgent", "${ApiClient.instance.userAgent}/$buildName");
    preferences?.setString("buildName", buildName);
    preferences?.setString("buildNumber", buildNumber);

    var deviceData = <String, dynamic>{};
    // String? token = preferences?.getString('token');
    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        print("EPERPUS DEVICE INFO: $deviceData");
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
    if (!mounted) return;
    setState(() {
      _deviceData = deviceData;
    });

    Future.delayed(const Duration(milliseconds: 2000)).then(
      (value) async {
        if (isFirstVisited == null || isFirstVisited == true) {
          setAppTheme(lightAppTheme);
          Navigator.pushNamedAndRemoveUntil(
            context,
            OnBoardingView.routeName,
            (route) => false,
          );
        } else {
          if (isLoggedIn == null) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              SignInUIForm.routeName,
              (route) => false,
            );
          } else {
            context.read<UserCubit>().getDataUser(context);
          }
        }
      },
    );
  }

  bool isFirstInit = true;
  @override
  Widget build(BuildContext context) {
    if (isFirstInit) {
      setOrientationMode(context);
      setState(() {
        isFirstInit = false;
      });
    }

    setSortText(AppLocalizations.of(context)!.filterDate);
    final date =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now());

    final Size size = MediaQuery.of(context).size;

    if (Platform.isAndroid) {
      final Map<String, dynamic> flutterPayload = {
        "pageOrientation": "portrait",
        "clientID": ApiClient.instance.clientId,
        "clientVersion": "3.0.3",
        "datetime": date,
        "deviceID": "${_deviceData['id']}",
        "deviceModel": "${_deviceData['model']}",
        "osVersion": "${_deviceData['version.codename']}",
        "sessionName": sessionName,
      };
      initFlutterPayload(flutterPayload);
    }

    Widget customSplashscreen() {
      return OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            return Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    customURLAsset(
                      size.width,
                      orientation,
                    ),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            );
          } else {
            return Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(customURLAsset(size.width, orientation)),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }
        },
      );
    }

    Widget blocListenerWidget() {
      return BlocListener<UserCubit, UserState>(
        listener: (context, state) async {
          if (state is GetDataUserSuccess) {
            context
                .read<UserCubit>()
                .checkUserToken(_deviceData, state.user, DateTime.now());
          } else if (state is GetUserForceLogout) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              SignInUIForm.routeName,
              (route) => false,
            );
          } else if ((state is UserFailed) || (state is UserSuccessAccess)) {
            await getWatermarkData().whenComplete(() {
              Navigator.pushNamedAndRemoveUntil(
                context,
                HomePage.routeName,
                (route) => false,
              );
            });
          }
        },
        child: ApiClient.instance.isCustomSplashscren
            ? customSplashscreen()
            : Container(
                width: size.width,
                height: size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.5),
                      Colors.white,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Spacer(),
                    const SizedBox(height: 32),
                    Image.asset(
                      splashScreenImage(
                        organization: ApiClient.instance.baseOrganizationId,
                      ),
                    ),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Powered by Gramedia',
                          style: paragraph4.copyWith(
                            color: darkBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Image(
                          image:
                              AssetImage("assets/icon_assets/logogramedia.png"),
                          color: darkBlue,
                        )
                      ],
                    ),
                  ],
                ),
              ),
      );
    }

    Widget splashScreen() {
      if (Platform.isAndroid) {
        return SafeArea(
          child: blocListenerWidget(),
        );
      } else {
        return blocListenerWidget();
      }
    }

    return Scaffold(
      appBar: Platform.isIOS
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              toolbarHeight: 0,
              elevation: 0,
            ),
      body: splashScreen(),
    );
  }
}
