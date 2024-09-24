import 'package:equatable/equatable.dart';
import 'package:revamp_eperpus_mobile/Helpers/json_util.dart';

class UserModel {
  String? fullname;
  DateTime? date;
  int? gender;
  String? email;
  String? password;

  UserModel({this.fullname, this.date, this.gender, this.email, this.password});
}

class UserLoginResponse extends Equatable {
  String? countryCode;
  String? email;
  int? expires;
  String? firstName;
  String? href;
  int? id;
  bool? isVerified;
  String realm;
  String token;
  String? lastName;

  UserLoginResponse(
      {required this.email,
      required this.countryCode,
      required this.expires,
      required this.firstName,
      required this.href,
      required this.id,
      required this.isVerified,
      required this.lastName,
      required this.realm,
      required this.token});

  factory UserLoginResponse.fromJson(Map<String, dynamic> json) {
    return UserLoginResponse(
        email: json['email'],
        id: json['id'],
        countryCode: json['country_code'],
        expires: json['expires'],
        firstName: json['first_name'],
        href: json['href'],
        isVerified: json['is_verified'],
        lastName: json['last_name'],
        realm: json['realm'],
        token: json['token']);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        expires,
        email,
        id,
        isVerified,
        token,
        realm,
        href,
        countryCode,
        firstName,
        lastName
      ];
}

class UserOrganizations {
  String? appName;
  String? href;
  int? id;
  bool? isManager;
  bool? isParentOrganization;
  String? logoUrl;
  int? maximumUserAllowed;
  String? name;
  String? type;
  String? usernamePrefix;

  UserOrganizations({
    this.appName,
    this.href,
    this.id,
    this.isManager,
    this.isParentOrganization,
    this.logoUrl,
    this.maximumUserAllowed,
    this.name,
    this.type,
    this.usernamePrefix,
  });

  factory UserOrganizations.fromJson(Map<String, dynamic> json) {
    return UserOrganizations(
      appName: getJsonValueAsString(json, 'app_name'),
      href: getJsonValueAsString(json, 'href'),
      id: getJsonValueAsInt(json, 'id'),
      isManager: getJsonValueAsBool(json, 'is_manager'),
      isParentOrganization: getJsonValueAsBool(json, 'is_parent_organization'),
      logoUrl: getJsonValueAsString(json, 'logo_url'),
      maximumUserAllowed: getJsonValueAsInt(json, 'maximum_user_allowed'),
      name: getJsonValueAsString(json, 'name'),
      type: getJsonValueAsString(json, 'type'),
      usernamePrefix: getJsonValueAsString(json, 'username_prefix'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'href': href,
      'id': id,
      'isManager': isManager,
      'isParentOrganization': isParentOrganization,
      'logoUrl': logoUrl,
      'maximumUserAllowed': maximumUserAllowed,
      'name': name,
      'type': type,
      'usernamePrefix': usernamePrefix
    };
  }
}

class UserProfile {
  String? activeBuffet;
  bool? allowAgeRestrictedContent;
  String? email;
  String? firstName;
  String? lastName;
  int? id;
  bool? isActive;
  bool? isDisplayPoint;
  bool? isVerified;
  int? latestTitle;
  int? level;
  String? note;
  List<UserOrganizations>? userOrganizations;

  UserProfile({
    this.activeBuffet,
    this.allowAgeRestrictedContent,
    this.email,
    this.firstName,
    this.lastName,
    this.id,
    this.isActive,
    this.isDisplayPoint,
    this.isVerified,
    this.latestTitle,
    this.level,
    this.note,
    this.userOrganizations,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userOrganizations: getJsonListValue(json, 'organizations')
          .map<UserOrganizations>(
              (dynamic value) => UserOrganizations.fromJson(value))
          .toList(),
    );
  }
}

class GetDataUserResponse {
  //bool? activeBuffet;
  //bool allowAgeRestrictedContent;
  String email;
  String firstName;
  int id;
  bool isActive;
  bool isDisplayPoint;
  bool isverified;
  String lastName;
  int latestTitle;
  String? level;
  String? note;
  int originClientId;
  String phoneNumber;
  // String? profile;
  int totalPoint;
  int totalTitle;
  String username;
  //RolesDataModel rolesData;
  List<OrganizationModel>? organizations;
  GetDataUserResponse({
    required this.id,
    required this.level,
    required this.username,
    required this.lastName,
    required this.firstName,
    required this.email,
    //required this.activeBuffet,
    //required this.allowAgeRestrictedContent,
    required this.isActive,
    required this.isDisplayPoint,
    required this.isverified,
    required this.latestTitle,
    required this.note,
    required this.originClientId,
    required this.phoneNumber,
    // required this.profile,
    required this.totalPoint,
    required this.totalTitle,
    //required this.rolesData,
    required this.organizations,
  });
  factory GetDataUserResponse.fromJson(json) {
    return GetDataUserResponse(
      id: getJsonValueAsInt(json, "id"),
      level: getJsonValueAsString(json, "level"),
      username: getJsonValueAsString(json, "username"),
      lastName: getJsonValueAsString(json, "last_name"),
      firstName: getJsonValueAsString(json, "first_name"),
      email: getJsonValueAsString(json, "email"),
      //activeBuffet: json['active_buffet'] == null ? false : json['active_buffet'] as bool,
      // allowAgeRestrictedContent: json['allow_age_restrited_content'],
      isActive: getJsonValueAsBool(json, "is_active"),
      isDisplayPoint: getJsonValueAsBool(json, "is_display_point"),
      isverified: getJsonValueAsBool(json, 'is_verified'),
      latestTitle: getJsonValueAsInt(json, "latest_title"),
      note: getJsonValueAsString(json, "note"),
      originClientId: getJsonValueAsInt(json, "origin_client_id"),
      phoneNumber: getJsonValueAsString(json, "phone_number"),
      // profile: getJsonValueAsString(json, 'profile'),
      totalPoint: getJsonValueAsInt(json, 'total_point'),
      totalTitle: getJsonValueAsInt(json, 'total_title'),
      //rolesData: RolesDataModel.fromJson(json['roles']),
      organizations: getJsonListValue(json, 'organizations')
          .map<OrganizationModel>(
              (dynamic value) => OrganizationModel.fromJson(value))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> getUnlinkBody() {
    List<Map<String, dynamic>> _organizations = [];
    organizations!.forEach((element) {
      _organizations.add({"id": element.id, "name": element.name});
    });
    return {
      "email": email,
      "first_name": firstName,
      "id": id,
      "is_active": true,
      "last_active": "-",
      "last_name": lastName,
      "level": level,
      "note": null,
      "organizations": _organizations,
      "organizations_name": organizations!.first.name,
      "signup_date": DateTime.now().toString(),
      "username": username
    };
  }
}

class RolesDataModel {
  List<RoleDataModel> roles;
  RolesDataModel({required this.roles});

  factory RolesDataModel.fromJson(Map<String, dynamic> json) {
    return RolesDataModel(
        roles: json['roles']
            .map<RoleDataModel>((model) => RoleDataModel.fromJson(model)));
  }
}

class RoleDataModel {
  String? href;
  int id;
  String title;
  RoleDataModel({required this.title, required this.href, required this.id});

  factory RoleDataModel.fromJson(Map<String, dynamic> json) {
    return RoleDataModel(
        title: json['title'], href: json['href'], id: json['id']);
  }
}

class OrganizationsModel {
  List<OrganizationModel> organizations;
  OrganizationsModel({required this.organizations});
  factory OrganizationsModel.fromJson(Map<String, dynamic> json) {
    return OrganizationsModel(
        organizations: json['organizations'].map<OrganizationModel>(
            (model) => OrganizationModel.fromJson(model)));
  }
}

class OrganizationModel {
  String? appname;
  String? href;
  int? id;
  bool? isManager;
  bool? isParentOrganization;
  String? logoUrl;
  int? maximumUserAllowed;
  String? name;
  String? type;
  String? usernamePrefix;
  OrganizationModel(
      {required this.id,
      required this.href,
      required this.name,
      required this.appname,
      required this.isManager,
      required this.isParentOrganization,
      required this.logoUrl,
      required this.maximumUserAllowed,
      required this.type,
      required this.usernamePrefix});
  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      id: getJsonValueAsInt(json, "id"),
      href: getJsonValueAsString(json, "href"),
      name: getJsonValueAsString(json, "name"),
      appname: getJsonValueAsString(json, "app_name"),
      isManager: getJsonValueAsBool(json, "is_manager"),
      isParentOrganization: getJsonValueAsBool(json, "is_parent_organization"),
      logoUrl: getJsonValueAsString(json, "logo_url"),
      maximumUserAllowed: getJsonValueAsInt(json, "maximum_user_allowed"),
      type: getJsonValueAsString(json, "type"),
      usernamePrefix: getJsonValueAsString(json, "username_prefix"),
    );
  }
}
