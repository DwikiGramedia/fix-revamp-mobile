import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/DigitalCard/digital_card_cubit.dart';
import 'package:revamp_eperpus_mobile/Utils/Style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DigitalCardArgs {
  DigitalCardArgs({this.userId, required int organizationId});

  final int? userId;
}

class DigitalCardView extends StatefulWidget {
  static const routeName = 'digital-Card-view';
  const DigitalCardView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DigitalCardViewState();
  }
}

class DigitalCardViewState extends State<DigitalCardView> {
  SharedPreferences? preferences;
  DigitalCardArgs? args;

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(const Duration(milliseconds: 500), () {
      context.read<DigitalCardCubit>().getDigitalCardUser(
            context,
            userId: args!.userId!,
          );
    });

    //setVersionAndToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as DigitalCardArgs;
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        foregroundColor:
        Platform.isIOS ? Theme.of(context).cardColor : const Color(0xFF091A33),
        backgroundColor: Platform.isIOS ? Theme.of(context).scaffoldBackgroundColor : Colors.transparent,
        elevation: 0,
        title: Text(
          localization.digitalCard,
          style: h4Title,
        ),
      ),
      body: BlocBuilder<DigitalCardCubit, DigitalCardState>(
        builder: (context, state) {
          if (state is DigitalCardLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is DigitalCardRes) {
            return Center(
              child: state.imageUrl != null && state.imageUrl!.isNotEmpty
                  ? Image.network(state.imageUrl!)
                  : Container(),
            );
          }
          if (state is DigitalCardError) {
            const Center(
              child: Text("Digital Card Not Found"),
            );
          }
          return Container();
        },
      ),
    );
  }
}
