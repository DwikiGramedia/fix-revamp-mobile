import 'package:flutter/material.dart';

enum Flavor {
  dev,
  prod,
  blims,
  eperpus,
  dprelib,
  allianz,
  bri,
  setkab,
  glibrary,
  pertamina,
  smartlib,
  btn,
  takumi,
  sltak_penabur,
  pyc,
  cimb,
  kgsmart,
  perpuskite,
  poltekkesaceh,
  kemenkopmk,
  kemenkoumkm,
  kemendikbud,
  taspen,
  ebookbatu,
  petradigilib,
  tkpenabur,
  sdpenabur,
  smpkpenabur,
  sltakpenabur,
  bpjsdila,
  bsi,
  lexa,
  stifsyentra,
  medali,
  alfamart,
  alfamidi,
  mulawarman,
  loyola,
  ppproperti,
  santaursulajakarta,
  unikastpls,
  unj,
  ursula,
  simadumaca,
  pegadaian,
  atmalib,
  smak1penabur,
  tulib,
  utlibro,
  telkomsel_cellular,
  kominfo,
  pusdababel,
  asmo,
  bpkpenaburcirebon,
  atmajaya,
  gudanggaram,
  kemenkopukm,
  elibcimahi,
  polkespapin,
  avialib,
  smartlibdev,
  dispusipmalang,
  imigrasi,
}

class FlavorValues {
  FlavorValues({
    @required this.baseUrl,
    @required this.baseOrganizationId,
    @required this.baseCatalogId,
    @required this.clientId,
    @required this.clientAssets,
    @required this.watermark,
    @required this.userAgent,
    @required this.appName,
    @required this.appConfigName,
    @required this.aboutUsID,
    @required this.aboutUsEN,
    @required this.playstore,
    @required this.appstore,
    this.isCustomSplashscren = false,
    this.isRegisterShown = false,
    this.clientLogo = "",
    this.isShowLoginEmail = true,
    this.isLogoStretch = false,
    this.openRegisPrefix = "",

  });
  final String? baseUrl;
  final int? baseOrganizationId;
  final int? baseCatalogId;
  final int? clientId;
  final String? clientAssets;
  final String? watermark;
  final String? userAgent;
  final String? appName;
  final String? appConfigName;
  final String? aboutUsID;
  final String? aboutUsEN;
  final String? playstore;
  final String? appstore;
  final bool? isCustomSplashscren;
  final bool? isShowLoginEmail;
  final bool? isRegisterShown;
  final bool? isLogoStretch;
  String? clientLogo;
  String openRegisPrefix;
}

class FlavorConfig {
  final Flavor flavor;
  final FlavorValues values;
  final String name;
  static FlavorConfig? _instance;

  factory FlavorConfig({
    required Flavor flavor,
    required FlavorValues values,
    String? name,
  }) {
    _instance ??= FlavorConfig._internal(flavor, values, flavor.toString());
    return _instance!;
  }

  FlavorConfig._internal(this.flavor, this.values, this.name);
  static FlavorConfig get instance => _instance!;

  static bool isProduction() => _instance!.flavor == Flavor.prod;
  static bool isDevelopment() => _instance!.flavor == Flavor.dev;
}
