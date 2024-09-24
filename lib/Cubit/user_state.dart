part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoginSuccess extends UserState {
  final UserLoginResponse user;
  UserLoginSuccess({required this.user});
  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class UserCantAccess extends UserState {}

class UserRegisterSuccess extends UserState {
  final String message;
  const UserRegisterSuccess({required this.message});
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class UserBorrowListProductSuccess extends UserState {
  final List<HistoryBorrowProductModel> models;
  UserBorrowListProductSuccess({required this.models});

  @override
  // TODO: implement props
  List<Object?> get props => [models];
}

class GetUserForceLogout extends UserState {}

class UserLogoutSuccess extends UserState {}

class UserProgressDeauthorized extends UserState {}

class UserDeauthorized extends UserState {
  final String message;
  UserDeauthorized({required this.message});
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class UserChangePasswordSuccess extends UserState {
  final String message;
  UserChangePasswordSuccess({required this.message});
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class UserFailed extends UserState {
  final int? errorCode;
  final String error;
  UserFailed({required this.error, this.errorCode});
  @override
  // TODO: implement props
  List<Object?> get props => [error, errorCode];
}

class GetDataUserSuccess extends UserState {
  final GetDataUserResponse user;
  GetDataUserSuccess({required this.user});
  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class UserSuccessAccess extends UserState {}

class UpdatePasswordSuccess extends UserState {
  final int message;
  const UpdatePasswordSuccess({required this.message});
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class UpdatePasswordError extends UserState {
  final String error;
  const UpdatePasswordError({required this.error});
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class UserAppTheme extends UserState {
  final bool darkAppTheme;
  final ThemeData appThemeData;
  const UserAppTheme({required this.darkAppTheme, required this.appThemeData});

  @override
  List<Object?> get props => [darkAppTheme, appThemeData];
}

class UserRegister extends UserState {
  final String error;
  const UserRegister({required this.error});
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class UserNeedVerification extends UserState {
  final int? errorCode;
  final String error;
  UserNeedVerification({required this.error, this.errorCode});
  @override
  // TODO: implement props
  List<Object?> get props => [error, errorCode];
}

class UserResendVerificationSuccess extends UserState {
  final String message;
  const UserResendVerificationSuccess({required this.message});
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class UserResendVerificationError extends UserState {
  final String message;
  const UserResendVerificationError({required this.message});
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class DeleteUserSuccess extends UserState {
  final String message;
  const DeleteUserSuccess({required this.message});
  @override
  List<Object?> get props => [message];
}

class DeleteUserError extends UserState {
  final String message;
  const DeleteUserError({required this.message});
  @override
  List<Object?> get props => [message];
}

class IsUserRegistrationShown extends UserState {
  final OpenRegistration content;
  const IsUserRegistrationShown({required this.content});
  @override
  List<Object?> get props => [content];
}

class IsUserRegistrationError extends UserState {
  final String message;
  const IsUserRegistrationError({required this.message});
  @override
  List<Object?> get props => [message];
}

class IsGetUserQuotaSuccess extends UserState {
  final OpenRegistration content;
  const IsGetUserQuotaSuccess({required this.content});
  @override
  List<Object?> get props => [content];
}

class IsGetUserQuotaError extends UserState {
  final String message;
  const IsGetUserQuotaError({required this.message});
  @override
  List<Object?> get props => [message];
}


