// Generated, built and configurated privately for Gramedia Asri Media projects
// Any use of this content without permission will be a legal violation
// ============================================================================
// @author Samuel O R Napitupulu
// @email samuel.napitupulu@gramedia.id
// @create date 2022-04-03 07:43:15
// @modify date 2022-04-03 07:43:15
// @desc [description]
// ============================================================================
// Copyrigthed Gramedia Asri Media 2022-04-03 07:43:15

import 'package:flutter/material.dart';
import 'package:revamp_eperpus_mobile/Helpers/api_client.dart';

class ApiConstant {
  static String scoopCoreAPI  = 'https://scoopadm.apps-foundry.com/scoopcor/api/v1/';
  static String stagingAPI    = 'https://dev.apps-foundry.com/scoopcor/api/v1/';
  static String preprodAPI    = 'https://preprod-scoopadm.apps-foundry.com/scoopcor/api/v1/';
  static String revampStagingAPI = "https://dev-api.eperpus.com/";
  static String revampProdAPI = "https://api-smartlib.gramedia.com/";

  static String getOrganizationSharedCatalogProducts(
    String organizationId,
    String catalogId,
    String queryString,
  ) {
    return 'organizations/$organizationId/shared-catalogs/$catalogId?q=$queryString&available=true';
  }

  static String booksReview = 'reviews';
  static String booksReviewList(int bookId) {
    return 'items/reviews/$bookId/list';
  }

  static String digitalCard(int organizationId, int userId) {
    return 'organizations/$organizationId/users/$userId';
  }

  static const URL_USERS = 'users';
}

const int organizationIdEperpus = 1100735;
const int catalogIdEperpus = 0;

const int organizationIdBCA = 1100769;
const int catalogIdIdBCA = 11;

const int organizationIdDPRElibrary = 1437678;
const int catalogIdDPRElibrary = 67;

const int organizationIdAllianz = 2215504;
const int catalogIdAllianz = 509;

const int organizationIdBRI = 1483541;
const int catalogIdBRI = 125;

const int organizationIdGLibrary = 2991421;
const int catalogIdGLibrary = 1174;

const int organizationIdSetKab = 1716062;
const int catalogIdSetKab = 246;

const int organizationIdPertamina = 2985863;
const int catalogIdPertamina = 1167;

const int organizationIdBTN = 2998304;
const int catalogIdBTN = 1186;

const int organizationIdTakumi = 2968428;
const int catalogIdTakumi = 1158;

const int organizationIdCIMB = 2698728;
const int catalogIdCIMB = 1158;

const int organizationIdPYC = 2987691;
const int catalogIdPYC = 1158;

const int organizationIdPerpuskite = 2676832;
const int catalogIdPerpuskite = 1001;

const int organizationIdKGsmart = 723;
const int catalogIdKGsmart = 2;

const int organizationIdGramediaEdukasi = 1856861;
const int catalogIdGramediaEdukasi = 625;

const int organizationIdPoltekesAceh = 2094979;
const int catalogIdPoltekesAceh = 397;

const int organizationIdKemenkoPMK = 2314214;
const int catalogIdKemenkoPMK = 646;

const int organizationIdTaspen = 2055317;
const int catalogIdTaspen = 367;

const int organizationIdPetraDigilib = 2701403;
const int catalogIdPetraDigilib = 906;

const int organizationIdEbookBatu = 1689010;
const int catalogIdEbookBatu = 226;

const int organizationIdTKPENABUR = 2258566;
const int catalogIdTKPENABUR = 839;
const int organizationIdSDPENABUR = 2511876;
const int catalogIdSDPENABUR = 602;
const int organizationIdSMPKPENABUR = 1129637;
const int catalogIdSMPKPENABUR = 5;
const int organizationIdSLTAKPENABUR = 1129636;
const int catalogIdSLTAKPENABUR = 4;

const int organizationIdBPJSDila = 1592288;
const int catalogIdBPJSDila = 174;
const int organizationIdBSI = 1874057;
const int catalogIdBSI = 277;
const int organizationIdLEXA = 1781924;
const int catalogIdLEXA = 266;
const int organizationIdSTIFSyentra = 2587786;
const int catalogIdSTIFSyentra = 846;

const int organizationIdMedali = 2484797;
const int catalogIdMedali = 758;
const int organizationIdAlfamart = 1610197;
const int catalogIdAlfamart = 190;
const int organizationIdAlfamidi = 1610199;
const int catalogIdAlfamidi = 191;
const int organizationIdMulawarman = 2477685;
const int catalogIdMulawarman = 751;
const int organizationIdLoyola = 2028269;
const int catalogIdLoyola = 350;
const int organizationIdPPProperti = 1100794;
const int catalogIdPPProperti = 13;
const int organizationIdSantaUrsulaJakarta = 2082623;
const int catalogIdSantaUrsulaJakarta = 388;
const int organizationIdUnikaSTPLS = 2624341;
const int catalogIdUnikaSTPLS = 866;

const int organizationUrsulaBSD = 2202720;
const int catalogIdUrsulaBSD = 485;


const int organizationIdAtmalib = 2710559;
const int catalogIdAtmalib = 907;
const int organizationIdPegadaian = 1517537;
const int catalogIdPegadaian = 142;
const int organizationIdSimadumaca = 2651475;
const int catalogIdSimadumaca = 874;
const int organizationIdSMAK1Penabur = 1100826;
const int catalogIdSMAK1Penabur = 315;
const int organizationIdTulib = 1868241;
const int catalogIdTulib = 274;
const int organizationIdUNJ = 2314173;
const int catalogIdUNJ = 645;
const int organizationIdUTLibro = 1375491;
const int catalogIdUTLibro = 51;

const int organizationIdKemendikbud = 1689014;
const int catalogIdKemendikbud = 1158;

const int organizationSMP193Jakarta = 3177686;

const int organizationIdKemenkopUKM = 3136315;
const int catalogIdKemenkopUKM = 1264;

const int organizationIdMalangCilin = 1678985;
const int catalogIdMalangCilin = 1264;

const int organizationIdImigrasi = 2303771;
const int catalogIdImigrasi = 628;

bool isPenaburJakarta(String asset){
  switch (asset){
    case "assets/client/sltka_penabur/":
    return true;
    case "assets/client/sdpenabur/":
    return true;
    case "assets/client/tkpenabur/":
    return true;
    case "assets/client/smpkpenabur/":
    return true;
    default:
    return false;
  }
}


String customURLAsset(double size, Orientation orientation) {
  if (orientation == Orientation.landscape) {
    return "${ApiClient.instance.clientAssets}splashscreenLandscape.png";
  } else {
    return "${ApiClient.instance.clientAssets}splashscreenPotrait.png";
  }
}
