part of 'digital_card_cubit.dart';

abstract class DigitalCardState extends Equatable {
  const DigitalCardState();
  @override
  List<Object> get props => [];
}

class DigitalCardInitial extends DigitalCardState {}

class DigitalCardLoading extends DigitalCardState {}

class DigitalCardRes extends DigitalCardState {
  String? imageUrl;

  DigitalCardRes({required this.imageUrl});
  @override
  List<Object> get props => [imageUrl!];
}

class DigitalCardError extends DigitalCardState{}
