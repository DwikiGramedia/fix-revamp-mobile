import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revamp_eperpus_mobile/Service/user_service.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(ForgotPasswordInitial());

  Future<void> sendForgotPassword({
    required BuildContext context,
    required String username,
  }) async {
    try {
      emit(ForgotPasswordLoading());
      final String res = await UserService().resetPassword(
        context: context,
        username: username,
      );
      emit(ForgotPasswordSuccess(message: res));
    } on Exception catch (e) {
      debugPrint("Error: $e");
      emit(ForgotPasswordError(message: "$e"));
    }
  }
}
