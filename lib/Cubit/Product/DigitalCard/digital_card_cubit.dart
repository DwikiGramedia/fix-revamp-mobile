import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revamp_eperpus_mobile/Service/digital_card_service.dart';
import 'package:revamp_eperpus_mobile/Helpers/cache.dart';
import 'package:revamp_eperpus_mobile/Helpers/snacks.dart';
part 'digital_card_state.dart';

class DigitalCardCubit extends Cubit<DigitalCardState> {
  DigitalCardCubit() : super(DigitalCardInitial());

  String? imageUrl;
  Future<void> getDigitalCardUser(
    BuildContext context, {
    required int userId,
  }) async {
    emit(DigitalCardLoading());
    try {
      imageUrl = await DigitalCardService.instance.getDigitalCard(
        userId: userId,
      );
      await debugLog('iamge url = $imageUrl');
      emit(DigitalCardRes(imageUrl: imageUrl!));
    } catch (err) {
      emit(DigitalCardError());
      debugPrint("err: $err");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Snacks.errorAction(
            err.toString(),
            'Dismiss',
            () => ScaffoldMessenger.of(context).hideCurrentSnackBar,
            false,
          ),
        ),
      );
    }
  }
}
