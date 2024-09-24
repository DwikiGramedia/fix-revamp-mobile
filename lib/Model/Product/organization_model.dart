import 'package:revamp_eperpus_mobile/Helpers/json_util.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/borrow_item_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/catalog_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/cover_image_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/details_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/vendor_model.dart';

class Organization {
  int? accountingId;
  String? appName;
  List<Catalog>? catalog;
  Catalogs? catalogs;
  String? contactEmail;
  String? created;
  String? href;
  int? id;
  bool? isActive;
  bool? isParentOrganization;
  String? legalName;
  String? logoUrl;
  String? mailingAddress;
  String? mailingCity;
  String? mailingPostalCode;
  dynamic? mailingProvince;
  int? maximumUserAllowed;
  String? name;
  dynamic parentalLevel;
  dynamic phoneAlternate;
  dynamic phonePrimary;
  String? picClient;
  String? picMarketing;
  String? status;
  int? totalUser;
  String? type;
  String? usernamePrefix;

  Organization({
    this.accountingId,
    this.appName,
    this.catalog,
    this.catalogs,
    this.contactEmail,
    this.created,
    this.href,
    this.id,
    this.isActive,
    this.isParentOrganization,
    this.legalName,
    this.logoUrl,
    this.mailingAddress,
    this.mailingCity,
    this.mailingPostalCode,
    this.mailingProvince,
    this.maximumUserAllowed,
    this.name,
    this.parentalLevel,
    this.phoneAlternate,
    this.phonePrimary,
    this.picClient,
    this.picMarketing,
    this.status,
    this.totalUser,
    this.type,
    this.usernamePrefix,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
        accountingId: getJsonValueAsInt(json, 'accounting_id'),
        appName: getJsonValueAsString(json, 'app_name'),
        catalog: getJsonListValue(json, 'catalog')
            .map<Catalog>((value) => Catalog.fromJson(value))
            .toList(),
        catalogs: Catalogs.fromJson(getJsonValueAsJson(json, 'catalogs')),
        contactEmail: getJsonValueAsString(json, 'contact_email'),
        created: getJsonValueAsString(json, 'created'),
        href: getJsonValueAsString(json, 'href'),
        id: getJsonValueAsInt(json, 'id'),
        isActive: getJsonValueAsBool(json, 'is_active'),
        isParentOrganization: getJsonValueAsBool(json, 'is_parent_organization'),
        legalName:getJsonValueAsString(json, 'legal_name'),
        logoUrl:getJsonValueAsString(json, 'logo_url'),
        mailingAddress:getJsonValueAsString(json, 'mailing_address'),
        mailingCity:getJsonValueAsString(json, 'mailing_city'),
        mailingPostalCode: getJsonValueAsString(json, 'mailing_postal_code'),
        mailingProvince:getJsonValue(json, 'mailing_province'),
        maximumUserAllowed: getJsonValueAsInt(json, 'maximum_user_allowed'),
        name:getJsonValueAsString(json, 'name'),
        parentalLevel: getJsonValue(json, 'parental_level'),
        phoneAlternate:getJsonValue(json, 'phone_alternate'),
        phonePrimary:getJsonValue(json, 'phone_primary'),
        picClient:getJsonValueAsString(json, 'pic_client'),
        picMarketing:getJsonValueAsString(json, 'pic_marketing'),
        status: getJsonValueAsString(json, 'status'),
        totalUser: getJsonValueAsInt(json, 'total_user'),
        type: getJsonValueAsString(json, 'type'),
        usernamePrefix: getJsonValueAsString(json, 'username_prefix'),
    );
  }
}
