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
// testingdikbud5@yopmail.com
Future<void> initServices() async {
  await Firebase.initializeApp();
  FlavorConfig(
    flavor: Flavor.kemendikbud,
    values: FlavorValues(
      baseUrl: ApiConstant.scoopCoreAPI,
      baseOrganizationId: organizationIdKemendikbud,
      baseCatalogId: catalogIdKemendikbud,
      clientAssets: "assets/client/kemendikbud/",
      clientId: Platform.isIOS ? 204 : 203,
      watermark: "EPERPUSDIKBUD",
      userAgent: Platform.isIOS ? "eperpusdikbud ios" : "eperpusdikbud android",
      appName: "EPerpusdikbud",
      appConfigName: "EPerpusdikbud",
      aboutUsID:
      "EPerpusdikbud, aplikasi perpustakaan digital milik Kemendikbud RI. Perpustakaan di ujung jarimu. Dimanapun. Kapanpun.",
      aboutUsEN:
      "EPerpusdikbud, digital library application by Kemendikbud RI. A library at your fingertips. Anywhere. Anytime.",
      playstore:
      "https://play.google.com/store/apps/details?id=com.appsfoundry.eperpuswl.id.kemendikbud.eperpusdikbud",
      appstore: "",
      isRegisterShown: true,
      openRegisPrefix: "dikbud",
    ),
    name: 'EPerpusdikbud',
  );
  ApiClient(values: FlavorConfig.instance.values);
}
