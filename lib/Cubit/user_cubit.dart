import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:revamp_eperpus_mobile/Service/analytic_services.dart';
import 'package:revamp_eperpus_mobile/Service/user_service.dart';
import 'package:revamp_eperpus_mobile/Helpers/api_client.dart';
import 'package:revamp_eperpus_mobile/Helpers/cache.dart';
import 'package:revamp_eperpus_mobile/model/Analytic/OpenAppAnalyticModel.dart';
import 'package:revamp_eperpus_mobile/model/Product/product_model.dart';
import 'package:revamp_eperpus_mobile/model/User/open_regis_model.dart';
import 'package:revamp_eperpus_mobile/model/User/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  void login(
    BuildContext context, {
    required String username,
    required String password,
    required String clientId,
    required String deviceId,
    required String modelDevice,
    required String versionOS,
  }) async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      emit(UserLoading());
      UserLoginResponse user = await UserService().login(
        username: username,
        password: password,
        deviceId: deviceId,
        clientId: clientId,
        modelDevice: modelDevice,
        osVersion: versionOS,
        uniqueId: "adads",
      );
      GetDataUserResponse? dataUser = await UserService().getDataUser(
        context: context,
      );
      if (dataUser.organizations
              ?.where((element) =>
                  element.appname!.contains(ApiClient.instance.appname) ||
                  element.id!.toString().contains(
                      ApiClient.instance.baseOrganizationId.toString()))
              .isNotEmpty ??
          false == true) {
        OrganizationModel? userOrg = dataUser.organizations
            ?.where((element) =>
                element.appname!.contains(ApiClient.instance.appname) ||
                element.id!
                    .toString()
                    .contains(ApiClient.instance.baseOrganizationId.toString()))
            .first;
        OrganizationModel? organizationUser = dataUser.organizations
            ?.where((element) => element.isParentOrganization == true)
            .first;
        sharedPreferences.setInt("organizationId", organizationUser?.id ?? 0);
        setOrgUrl(userOrg!.href!);
        emit(UserLoginSuccess(user: user));
      } else {
        sharedPreferences.remove("JWT");
        sharedPreferences.remove("user_id");
        sharedPreferences.remove("email");
        // sharedPreferences.remove("userAgent");
        sharedPreferences.remove("modelDevice");
        sharedPreferences.remove("clientId");
        sharedPreferences.remove("osVersion");
        emit(UserCantAccess());
      }
    } catch (e, s) {
      debugPrint("catch login ${e.toString()}");
      if (e.toString() ==
          "You have reached maximum number of authorized devices.\nPlease deauthorized first then re-login") {
        emit(UserProgressDeauthorized());
        // String deauthorize = await UserService().deauthorize(username: username, password: password);
        // UserDeauthorized(message: deauthorize);
      } else if (e.toString().contains("verify")) {
        emit(UserNeedVerification(error: e.toString(), errorCode: 403));
      } else {
        emit(UserFailed(error: e.toString()));
        await FirebaseCrashlytics.instance
            .recordError(e, s, reason: e.toString());
        emit(UserFailed(error: e.toString()));
      }
    }
  }

  void getDataUser(BuildContext context) async {
    try {
      emit(UserLoading());
      GetDataUserResponse user =
          await UserService().getDataUser(context: context);

      emit(GetDataUserSuccess(user: user));
    } catch (e) {
      if (e.toString().contains("Force logout")) {
        emit(GetUserForceLogout());
      } else {
        emit(UserFailed(error: e.toString()));
      }
    }
  }

  void checkUserToken(Map<String, dynamic> deviceData, GetDataUserResponse user,
      DateTime date) async {
    try {
      //String ipAddress = await AnalyticService().getIpAddress();
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo? iosInfo;
      if (Platform.isIOS) {
        iosInfo = await deviceInfo.iosInfo;
      }

      OpenAppAnalytic data = OpenAppAnalytic(
        sessionName: "",
        ipAddresss: "192.168.0.1",
        deviceModel: deviceData['model'] ?? "Model",
        dateTime: date.toString(),
        clientVersion: "2.0.0",
        deviceId:
            "${Platform.isIOS ? iosInfo?.identifierForVendor ?? "vendor ID" : deviceData['id'] ?? "vendor id"}",
        userId: user.id,
        organizationId: ApiClient.instance.baseOrganizationId,
        clientId: user.originClientId,
        catalogId: ApiClient.instance.baseCatalogId,
        osVersion: Platform.isIOS
            ? iosInfo?.systemVersion ?? "code name"
            : deviceData['version.codename'] ?? "code name",
      );
      OpenAppAnalyticModel dataAnalytic = OpenAppAnalyticModel(data: [data]);
      await AnalyticService().openApp(model: dataAnalytic);
      emit(UserSuccessAccess());
    } catch (e) {
      if (e.toString() ==
          "JWT Token signature is invalid, password already changed, login again to get new valid token") {
        emit(GetUserForceLogout());
      } else {
        emit(UserFailed(error: e.toString()));
      }
    }
  }

  void deauthorize({
    required String username,
    required String password,
    required String modelDevice,
    required String versionOS,
  }) async {
    try {
      emit(UserLoading());
      String deauthorize = await UserService().deauthorize(
          username: username,
          password: password,
          modelDevice: modelDevice,
          osVersion: versionOS);
      emit(UserDeauthorized(message: deauthorize));
    } catch (e) {
      emit(UserFailed(error: e.toString()));
    }
  }

  void change({
    required String currentPassword,
    required String newPassword,
    required BuildContext context,
  }) async {
    try {
      emit(UserLoading());
      Future.delayed(const Duration(seconds: 1));
      int message = await UserService().changePassword(
          currentPassword: currentPassword, newPassword: newPassword);
      if (message == 204) {
        emit(UserChangePasswordSuccess(message: "$message"));
      }
    } catch (e) {
      emit(UserFailed(error: e.toString()));
    }
  }

  Future<void> initEditProfile(GetDataUserResponse user) async {
    print("edit");
    emit(GetDataUserSuccess(user: user));
  }

  Future<void> logout() async {
    try {
      emit(UserLoading());
      Future.delayed(const Duration(seconds: 1));
      await UserService().logout();
      emit(UserLogoutSuccess());
    } catch (e) {
      emit(UserFailed(error: ""));
    }
  }

  Future<String> resendVerification({
    required BuildContext context,
    required String username,
  }) async {
    try {
      emit(UserLoading());
      final String res = await UserService().patchResendVerification(
        context: context,
        email: username,
      );
      emit(UserResendVerificationSuccess(message: res));
      return res;
    } on Exception catch (e) {
      debugPrint("Error: $e");
      emit(UserResendVerificationError(message: "$e"));
      return "$e";
    }
  }

  Future<String> deleteAccountCubit({
    required int userId,
    Map<String, dynamic>? payload,
    int? organizationId,
  }) async {
    try {
      emit(UserLoading());
      final String res = await UserService().deleteAccount(
        userId: userId,
        organizationId: organizationId!,
      );
      emit(DeleteUserSuccess(message: res));
      return res;
    } on Exception catch (e) {
      debugPrint("Error: $e");
      emit(DeleteUserError(message: "$e"));
      return "$e";
    }
  }

  Future<void> getOpenRegistration() async {
    try {
      emit(UserLoading());
      final dataFetch = await UserService().getOpenRegistration();
      final OpenRegistrationRes res = OpenRegistrationRes.fromJson(dataFetch);
      if (res.statusCode == 200) {
        final OpenRegistration content = res.openregis!;
        emit(IsUserRegistrationShown(content: content));
      } else {
        emit(IsUserRegistrationError(message: res.error!));
      }
    } on Exception catch (e) {
      debugPrint("Error getOpenRegistration: $e");
      emit(IsUserRegistrationError(message: e.toString()));
      throw "$e";
    }
  }

  Future<void> getUserQuotaStatus() async {
    try {
      emit(UserLoading());
      final dataFetch = await UserService().getOpenRegistration();
      final OpenRegistrationRes res = OpenRegistrationRes.fromJson(dataFetch);
      if (res.statusCode == 200) {
        final OpenRegistration content = res.openregis!;
        emit(IsGetUserQuotaSuccess(content: content));
      } else {
        emit(IsGetUserQuotaError(message: res.error!));
      }
    } on Exception catch (e) {
      emit(IsGetUserQuotaError(message: e.toString()));
      throw "$e";
    }
  }
}
