// Generated, built and configurated privately for Gramedia Asri Media projects
// Any use of this content without permission will be a legal violation
// ============================================================================
// @author Samuel O R Napitupulu
// @email samuel.napitupulu@gramedia.id
// @create date 2022-03-27 02:55:42
// @modify date 2022-03-30 02:38:27
// @desc [description]
// ============================================================================
// Copyrigthed Gramedia Asri Media 2022-03-27 02:55:42

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:revamp_eperpus_mobile/Service/MessagingService.dart';

import 'package:revamp_eperpus_mobile/Utils/config.dart';
import 'package:revamp_eperpus_mobile/app.dart';
import 'package:revamp_eperpus_mobile/Helpers/api_client.dart';
import 'package:revamp_eperpus_mobile/Helpers/api_constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(const MyApp());
}

Future<void> initServices() async {
  await Firebase.initializeApp();
  FlavorConfig(
    flavor: Flavor.allianz,
    values: FlavorValues(
        baseUrl: ApiConstant.scoopCoreAPI,
        baseOrganizationId: organizationIdAllianz,
        baseCatalogId: catalogIdAllianz,
        clientAssets: "assets/client/allianz/",
        clientId: Platform.isIOS ? 255 : 254,
        watermark: "GDBOOKLAB",
        userAgent: Platform.isIOS ? "book_lab_ios" : "book_lab_android",
        appName: "Book Lab",
        appConfigName: "Book Lab",
        aboutUsID:
            "Book Lab adalah fasilitas pembelajaran melalui buku, majalah, dan koran digital, dipersembahkan untuk karyawan Allianz Indonesia",
        aboutUsEN:
            "Book Lab is learning facility through books, magazines, and digital newspapers dedicated for Allianz Indonesia’s employees.",
        playstore:
            "https://play.google.com/store/apps/details?id=com.appsfoundry.eperpuswl.id.allianz",
        appstore: ""),
    name: "Book Lab",
  );
  ApiClient(values: FlavorConfig.instance.values);
}
