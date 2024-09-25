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
    flavor: Flavor.lexa,
    values: FlavorValues(
      baseUrl: ApiConstant.scoopCoreAPI,
      baseOrganizationId: organizationIdLEXA,
      baseCatalogId: catalogIdLEXA,
      clientAssets: "assets/client/lexa/",
      clientId: Platform.isIOS ? 213 : 212,
      watermark: "GLEXA",
      userAgent: Platform.isIOS ? "lexa_ios" : "lexa_android",
      appName: "LEXA",
      appConfigName: "LEXA",
      aboutUsID: "LEXA - layanan aplikasi perpustakaan online berisi buku dan konten terkini.",
      aboutUsEN: "LEXA - e-library application with the latest update of books and content.",
      playstore: "",
      appstore: "",
    ),
    name: "LEXA",
  );
  ApiClient(values: FlavorConfig.instance.values);
}
