import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:revamp_eperpus_mobile/Service/database_helper.dart';
import 'package:revamp_eperpus_mobile/Service/product_service.dart';
import 'package:revamp_eperpus_mobile/Utils/constant.dart';
import 'package:revamp_eperpus_mobile/Helpers/api_client.dart';
import 'package:revamp_eperpus_mobile/Helpers/api_constant.dart';
import 'package:revamp_eperpus_mobile/Helpers/cache.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Utils {
  static Future<File> getFileFromAsset(String asset) async {
    ByteData data = await rootBundle.load(asset);
    String dir = (await getTemporaryDirectory()).path;
    String path = '$dir/${basename(asset)}';
    if (!File(path).existsSync()) {
      final buffer = data.buffer;
      return File(path).writeAsBytes(
          buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    } else {
      return File(path);
    }
  }
}

Future<void> initColibrioReader() async {
  const platform = MethodChannel(METHOD_READER_CHANNEL);
  try {
    await platform.invokeMethod('initColibrioKey');
    if (kDebugMode) {
      await debugLog('Init Colibrio Reader');
    }
  } on PlatformException catch (e) {
    debugPrint("initColibrioReader " + e.toString());
  }
}

Future<void> initFlutterPayload(Map<String, dynamic> flutterPayload) async {
  const platform = MethodChannel(METHOD_READER_CHANNEL);
  try {
    await platform.invokeMethod('getFlutterPayload', {
      'clientID': flutterPayload["clientID"].toString(),
      'clientVersion': flutterPayload["clientVersion"].toString(),
      'datetime': flutterPayload["datetime"].toString(),
      'deviceID': flutterPayload["deviceID"].toString(),
      'deviceModel': flutterPayload["deviceModel"].toString(),
      'osVersion': flutterPayload["osVersion"].toString(),
      'sessionName': flutterPayload["sessionName"].toString(),
    });
    await debugLog('initFlutterPayload');
  } on PlatformException catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> openColibrioReaderPDF({
  required BuildContext context,
  required String filePath,
  required String zipPassword,
  required String pdfPassword,
  required String watermark,
  required String token,
  required String itemId,
  required String userId,
  required String bookTitle,
}) async {
  const platform = MethodChannel(METHOD_READER_CHANNEL);
  try {
    showLoaderDialog(context);
    await platform.invokeMethod(METHOD_READER_PDF, {
      'filePath': filePath,
      'zipPassword': zipPassword,
      'pdfPassword': pdfPassword,
      'watermark': watermark,
      'token': token,
      'itemId': itemId,
      'userid': userId,
      'bookTitle': bookTitle,
      'organizationId': ApiClient.instance.baseOrganizationId.toString(),
      'offlineWarning': AppLocalizations.of(context)!.offlineWarning,
    });
    Navigator.pop(context);
  } catch (e) {
    Navigator.pop(context);
    debugPrint(e.toString());
  }
}

Future<void> openColibrioReaderEpub({
  required BuildContext context,
  required String filePath,
  required String zipPassword,
  required String bookId,
  required String saltEpub,
  required String saltLastEpub,
  required String editionCode,
  required String watermark,
  required String token,
  required String itemId,
  required String userId,
  required String bookTitle,
}) async {
  const platform = MethodChannel(METHOD_READER_CHANNEL);
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  try {
    showLoaderDialog(context);
    await platform.invokeMethod(METHOD_READER_EPUB, {
      'filePath': filePath,
      'zipPassword': zipPassword,
      'bookId': bookId,
      'saltEpub': saltEpub,
      'saltLastEpub': saltLastEpub,
      'editionCode': editionCode,
      'watermark': watermark,
      'token': token,
      'itemId': itemId,
      'userid': userId,
      'bookTitle': bookTitle,
      'organizationId': sharedPreferences.getInt("organizationId").toString(),
      'offlineWarning': AppLocalizations.of(context)!.offlineWarning,
    });
    Navigator.pop(context);
  } catch (e) {
    Navigator.pop(context);
    debugPrint(e.toString());
  }
}

Future<String?> findLocalPath(int itemId) async {
  if (Platform.isAndroid) {
    final storage = await getApplicationDocumentsDirectory();
    final String path = '${storage.path}${Platform.pathSeparator}$itemId';
    return path;
  } else {
    var directory = await getApplicationDocumentsDirectory();
    return directory.path + Platform.pathSeparator + '$itemId';
  }
}

Future<String> unlockDownloadedZip(
  BuildContext context,
  String title,
  int id,
  int brandId, {
  String? editionCode,
}) async {
  String? watermark = await getWatermark();
  SavedBook? savedBook = await DatabaseHelper().getBook(id);
  var localPath = (await findLocalPath(id))!;
  final saveDir = Directory(localPath);
  final String fileType = savedBook!.fileType;

  var sharedPreferences = await SharedPreferences.getInstance();
  var userId = sharedPreferences.getInt("user_id");
  var token = sharedPreferences.getString("JWT");

  final String fileName = '$id.zip';
  final String filePath = '${saveDir.path}/$fileName';

  final int itemId = id;
  final String key = savedBook.key;

  final String zipKey =
      itemId.toString() + r1 + zipSalt + r2 + brandId.toString() + r3 + key;

  List<int> zipBytes = utf8.encode(zipKey);
  String zipDigest = sha256.convert(zipBytes).toString();

  try {
    if (fileType == 'pdf') {
      final String pdfKey =
          itemId.toString() + r1 + pdfSalt + r2 + brandId.toString() + r3 + key;

      List<int> pdfBytes = utf8.encode(pdfKey);
      String pdfDigest = sha256.convert(pdfBytes).toString();

      await openColibrioReaderPDF(
        context: context,
        filePath: filePath,
        zipPassword: zipDigest,
        pdfPassword: pdfDigest,
        watermark: watermark!,
        token: token!,
        itemId: id.toString(),
        userId: userId.toString(),
        bookTitle: title,
      );
    } else {
      await openColibrioReaderEpub(
        context: context,
        filePath: filePath,
        zipPassword: zipDigest,
        bookId: itemId.toString(),
        saltEpub: saltEpub,
        saltLastEpub: saltLastEpub,
        editionCode: editionCode!,
        watermark: watermark!,
        token: token!,
        itemId: id.toString(),
        userId: userId.toString(),
        bookTitle: title,
      );
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return '';
}

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        const CircularProgressIndicator(),
        Container(
          margin: const EdgeInsets.only(left: 7),
          child: const Text("Loading..."),
        ),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

String splashScreenImage({required int organization}) {
  switch (organization) {
    case organizationIdSDPENABUR:
      return "${ApiClient.instance.clientAssets}splashscreen.png";
    case organizationIdTKPENABUR:
      return "${ApiClient.instance.clientAssets}splashscreen.png";
    default:
      return "${ApiClient.instance.clientAssets}app_logo.png";
  }
}

String logoImage({required int organization}) {
  return "${ApiClient.instance.clientAssets}app_logo.png";
}

String profilePage({required int organization}) {
  return "${ApiClient.instance.clientAssets}banner.png";
  // switch (organization) {
  //   case organizationIdBCA:
  //     return "assets/client/Blims/banner.png";
  //   case organizationIdSmartlib:
  //     return "assets/client/smartlib/banner.png";
  //   case organizationIdPerpuskite:
  //     return "assets/client/Perpuskite/banner.png";
  //   case organizationIdPerpuskiteStg:
  //     return "assets/client/Perpuskite/banner.png";
  //   case organizationIdPoltekesAceh:
  //     return "assets/client/PoltekesAceh/banner.png";
  //   case organizationIdSetKab:
  //     return "assets/client/SetKab/banner.png";
  //   case organizationIdAstralife:
  //     return "assets/client/Astralife/banner.png";
  //   case organizationIdKemenkoPMK:
  //     return "assets/client/KemenkoPMK/banner.png";
  //   default:
  //
  // }
}

Color primaryColorApp({required int organization}) {
  return Colors.white;
  // switch (organization) {
  //   case organizationIdBCA:
  //     return primaryColor;
  //   case organizationIdSmartlib:
  //     return Colors.green;
  //   case organizationIdPerpuskite:
  //     return primaryColor;
  //   case organizationIdPerpuskiteStg:
  //     return primaryColor;
  //   case organizationIdKGsmart:
  //     return primaryColorKGSmart;
  //   default:
  //     return Colors.white;
  // }
}

Future<void> launchUrlString(String _url) async {
  final Uri uri = Uri.parse(_url);
  if (!await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Could not launch $uri';
  }
}

Future<void> _showProgressNotification() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  const int maxProgress = 5;
  for (int i = 0; i <= maxProgress; i++) {
    await Future<void>.delayed(const Duration(seconds: 1), () async {
      final AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'channel ID',
        'channel Name',
        channelDescription: 'progress channel description',
        channelShowBadge: false,
        importance: Importance.max,
        priority: Priority.high,
        onlyAlertOnce: true,
        showProgress: true,
        maxProgress: maxProgress,
        progress: i,
        icon: logoImage(
          organization: ApiClient.instance.baseOrganizationId,
        ),
      );
      final NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0,
        'progress notification title',
        'progress notification body',
        platformChannelSpecifics,
        payload: 'item x',
      );
    });
  }
}

bool getDeviceType(BuildContext context) {
  final shortestSide = MediaQuery.of(context).size.shortestSide;
  print("getDeviceType: $shortestSide");
  final bool useMobileLayout = shortestSide < 550;
  return useMobileLayout;
}

void setOrientationMode(BuildContext context) {
  if (getDeviceType(context)) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  } else {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}

Future<int> downloadDio({
  required String url,
  required String filepath,
  required String fileName,
  required String title,
  required String auth,
  required int bookId,
}) async {
  var file = File("$filepath/$fileName");

  var dio = Dio();
  dio.interceptors.add(LogInterceptor());
  try {
    final header = {
      "Authorization": auth,
    };
    var response = await dio.get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        receiveTimeout: const Duration(seconds: 30),
        headers: header,
      ),
    );
    debugPrint("download path: $filepath");
    var raf = file.openSync(mode: FileMode.write);
    print("RAF: $raf");
    // response.data is List<int> type
    raf.writeFromSync(response.data);
    await raf.close();
    return 100;
  } catch (e) {
    debugPrint(e.toString());
  }
  return 0;
}
