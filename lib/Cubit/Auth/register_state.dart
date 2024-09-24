part of 'register_cubit.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();
  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String message;
  const RegisterSuccess({required this.message});
  @override
// TODO: implement props
  List<Object?> get props => [message];
}

class RegisterOutQuota extends RegisterState {
  final String message;
  const RegisterOutQuota({required this.message});
  @override
  List<Object?> get props => [message];
}

class RegisterError extends RegisterState {
  final String message;
  const RegisterError({required this.message});
  @override
// TODO: implement props
  List<Object?> get props => [message];
}
