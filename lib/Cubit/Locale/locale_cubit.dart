import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:revamp_eperpus_mobile/Service/user_service.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  Locale? localeData;
  LocaleCubit() : super(LocaleInitial());

  
  void setLocale(String codeLang)async{
    Locale dataLocale = Locale(codeLang);
    await UserService().setLocale(dataLocale);
    localeData = dataLocale;
  }
}
