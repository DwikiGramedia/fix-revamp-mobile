import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revamp_eperpus_mobile/Service/user_service.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future<void> registerAccount({
    required BuildContext context,
    required String username,
    required String birthdate,
    required int gender,
    required String email,
    required String password,
    required String deviceModel,
    required String oSVersion,
    String? firstName,
    String? lastName,
  }) async {
    try {
      emit(RegisterLoading());
      Future.delayed(const Duration(seconds: 1));
      final Map<String, dynamic> res = await UserService().addUserAccount(
        context: context,
        username: username,
        birthdate: birthdate,
        gender: gender,
        email: email,
        password: password,
        deviceModel: deviceModel,
        oSVersion: oSVersion,
        firstName: firstName,
        lastName: lastName,
      );
      int statusCode = res["status"];
      String message = res["message"];
      if (statusCode == 204 || statusCode == 201 || statusCode == 200) {
        emit(RegisterSuccess(message: message));
      } else if (statusCode == 400) {
        emit(RegisterOutQuota(message: message));
      } else {
        emit(RegisterError(message: message));
      }
    } on Exception catch (e) {
      print(e);
      debugPrint("Error Exception: $e");
      emit(RegisterError(message: "$e"));
    }
  }
}
