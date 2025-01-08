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
  runApp(MyApp());
}

Future<void> initServices() async {
  await Firebase.initializeApp();
  FlavorConfig(
    flavor: Flavor.gudanggaram,
    values: FlavorValues(
      baseUrl: ApiConstant.scoopCoreAPI,
      baseOrganizationId: organizationIdImigrasi,
      baseCatalogId: catalogIdImigrasi,
      clientAssets: "assets/client/imigrasi/",
      clientId: Platform.isIOS ? 265 : 264,
      watermark: "GDIRJENIMIGRASI",
      userAgent: Platform.isIOS ? "epusimigrasi ios" : "epusimigrasi android",
      appName: "EPusImigrasi",
      appConfigName: "EPusImigrasi",
      aboutUsID: "EPusImigrasi, aplikasi perpustakaan digital milik Ditjen Imigrasi",
      aboutUsEN: "EPusImigrasi, aplikasi perpustakaan digital milik Ditjen Imigrasi",
      playstore: "https://play.google.com/store/apps/details?id=com.appsfoundry.eperpuswl.id.epusimigrasi",
      appstore: "",
    ),
    name: "EPusImigrasi",
  );
  ApiClient(values: FlavorConfig.instance.values);
}
