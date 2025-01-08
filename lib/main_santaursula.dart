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
    flavor: Flavor.santaursulajakarta,
    values: FlavorValues(
      baseUrl: ApiConstant.scoopCoreAPI,
      baseOrganizationId: organizationIdSantaUrsulaJakarta,
      baseCatalogId: catalogIdSantaUrsulaJakarta,
      clientAssets: "assets/client/santaursulajakarta/",
      clientId: Platform.isIOS ? 239 : 238,
      watermark: "GSTURSULAJKT",
      userAgent: Platform.isIOS ? "stursula elib ios" : "stursula elib android",
      appName: "StUrsula eLib",
      appConfigName: "StUrsula eLib",
      aboutUsID: "Media pencarian dan peminjaman koleksi bahan pustaka digital Perpustakaan TB-TK-SD-SMP-SMA Santa Ursula Jakarta.",
      aboutUsEN: "A media for browsing and borrowing digital library collections from Santa Ursula Jakarta Kindergarten-Elementary-Junior High-Senior High",
      playstore: "",
      appstore: "",
    ),
    name: "StUrsula eLib",
  );
  ApiClient(values: FlavorConfig.instance.values);
}
