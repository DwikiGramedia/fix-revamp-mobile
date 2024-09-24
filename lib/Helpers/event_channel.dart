import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Cubit/Product/Borrow/borrow_cubit.dart';

class EventChannelHelper {
  StreamSubscription<dynamic>? downloadStream;

  static const channel =
      MethodChannel('com.apps-foundry.eperpuswl.id.eperpus/navToReader');
  static const EventChannel downloadChannel =
      EventChannel('com.apps-foundry.eperpuswl.id.eperpus/download');
  var isLoading = false;
  void loadingDownload(
    
      Map<String, dynamic> arguments, BuildContext context, int id) async {
    try {
      int valueBefore = 0;
      downloadStream =
          downloadChannel.receiveBroadcastStream(arguments).listen((event) {
        int valueDownload = double.parse("${event * 100}").toInt();
        
          context.read<BorrowCubit>().downloadiOS(valueDownload, id,isLoading);
        
      });
    } catch (e) {
      print(e);
    }
  }

  void stopDownload() async {
    await downloadStream?.cancel();
  }
}
