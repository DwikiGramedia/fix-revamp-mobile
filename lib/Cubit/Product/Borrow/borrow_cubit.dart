import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:revamp_eperpus_mobile/Service/database_helper.dart';
import 'package:revamp_eperpus_mobile/Service/product_service.dart';
import 'package:revamp_eperpus_mobile/Helpers/event_channel.dart';
import 'package:revamp_eperpus_mobile/model/Product/borrowed_response_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/detail_product_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/watch_item_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:revamp_eperpus_mobile/Service/analytic_services.dart';
import 'package:revamp_eperpus_mobile/Helpers/api_client.dart';
import 'package:revamp_eperpus_mobile/Helpers/cache.dart';
import 'package:revamp_eperpus_mobile/model/Analytic/DownloadAnalyticModel.dart';
import 'package:revamp_eperpus_mobile/model/file_product.dart';

part 'borrow_state.dart';

class BorrowCubit extends Cubit<BorrowState> {
  BorrowCubit() : super(BorrowInitial());

  void borrow(ItemInfoModel data) async {
    try {
      emit(BorrowLoading());
      BorrowedResponseModel model = await ProductService().borrow(data);
      await Future.delayed(const Duration(seconds: 2));
      emit(GetBorrowResponse(borrowedRes: model));
    } catch (e) {
      //emit(DownloadFinished());
      print("Failed Borrow");
      emit(GetFailedBorrowResponse(message: e.toString()));
    }
  }

  void watch(ItemInfoModel data) async {
    try {
      emit(BorrowLoading());
      String message = await ProductService().watch(data);
      await Future.delayed(const Duration(seconds: 2));
      emit(GetWatchResponse(message: message));
    } catch (e) {
      print("Failed watch");
      emit(GetFailedBorrowResponse(message: e.toString()));
    }
  }

  void downloadiOS(int progress, int id, bool isLoading) async {
    try {
      //String? message = await ProductService().download(data,data2);
      // await debugLog('Progress: $progress');
      if (progress < 100 && isLoading == true) {
        emit(DownloadLoading(total: 100, receive: progress));
      } else {
        var date = intl.DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
            .format(DateTime.now());
        var sharedPreferences = await SharedPreferences.getInstance();

        var userId = sharedPreferences.getInt("user_id");
        var modelDevice = sharedPreferences.getString("modelDevice");
        var clientId = sharedPreferences.getString("clientId");
        String apiAddress = await AnalyticService().getIpAddress();
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

        IosDeviceInfo iosInfo;
        AndroidDeviceInfo androidDeviceInfo;
        if (Platform.isAndroid) {
          androidDeviceInfo = await deviceInfo.androidInfo;
          DownloadAnalytic download = DownloadAnalytic(
            catalogId: ApiClient.instance.baseCatalogId,
            clientId: "${ApiClient.instance.clientId}",
            organizationId: ApiClient.instance.baseOrganizationId,
            userId: userId!,
            deviceId: androidDeviceInfo.id,
            itemId: id,
            clientVersion: "2.0.7",
            dateTime: date.toString(),
            deviceModel: modelDevice!,
            downloadStatus: "Error",
            ipAddresss: apiAddress,
            sessionName: "",
          );
          await AnalyticService()
              .downloadItem(model: DownloadAnlyticModel(data: [download]));
          emit(DownloadFinished());
        } else {
          iosInfo = await deviceInfo.iosInfo;
          DownloadAnalytic download = DownloadAnalytic(
            catalogId: ApiClient.instance.baseCatalogId,
            clientId: clientId!,
            organizationId: ApiClient.instance.baseOrganizationId,
            userId: userId!,
            deviceId: iosInfo.identifierForVendor!,
            itemId: id,
            clientVersion: "2.0.7",
            dateTime: date.toString(),
            deviceModel: modelDevice!,
            downloadStatus: "Error",
            ipAddresss: apiAddress,
            sessionName: "",
          );
          await AnalyticService()
              .downloadItem(model: DownloadAnlyticModel(data: [download]));
          emit(DownloadFinished());
        }

        // emit(BorrowLoading());
      }
    } on DioError catch (e) {
      emit(GetFailedDownloadResponse(message: e.message ?? ""));
    }
  }

  void download(int progress, int id) async {
    try {
      //String? message = await ProductService().download(data,data2);
      // await debugLog('Progress: $progress');
      if (progress < 100) {
        emit(DownloadLoading(total: 100, receive: progress));
      } else {
        var date = intl.DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
            .format(DateTime.now());
        var sharedPreferences = await SharedPreferences.getInstance();

        var userId = sharedPreferences.getInt("user_id");
        var modelDevice = sharedPreferences.getString("modelDevice");
        var clientId = sharedPreferences.getString("clientId");
        String apiAddress = await AnalyticService().getIpAddress();
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

        IosDeviceInfo iosInfo;
        AndroidDeviceInfo androidDeviceInfo;
        if (Platform.isAndroid) {
          androidDeviceInfo = await deviceInfo.androidInfo;
          DownloadAnalytic download = DownloadAnalytic(
            catalogId: ApiClient.instance.baseCatalogId,
            clientId: "${ApiClient.instance.clientId}",
            organizationId: ApiClient.instance.baseOrganizationId,
            userId: userId!,
            deviceId: androidDeviceInfo.id,
            itemId: id,
            clientVersion: "2.0.7",
            dateTime: date.toString(),
            deviceModel: modelDevice!,
            downloadStatus: "Error",
            ipAddresss: apiAddress,
            sessionName: "",
          );
          await AnalyticService()
              .downloadItem(model: DownloadAnlyticModel(data: [download]));
          emit(DownloadFinished());
        } else {
          iosInfo = await deviceInfo.iosInfo;
          DownloadAnalytic download = DownloadAnalytic(
            catalogId: ApiClient.instance.baseCatalogId,
            clientId: clientId!,
            organizationId: ApiClient.instance.baseOrganizationId,
            userId: userId!,
            deviceId: iosInfo.identifierForVendor!,
            itemId: id,
            clientVersion: "2.0.7",
            dateTime: date.toString(),
            deviceModel: modelDevice!,
            downloadStatus: "Error",
            ipAddresss: apiAddress,
            sessionName: "",
          );
          await AnalyticService()
              .downloadItem(model: DownloadAnlyticModel(data: [download]));
          emit(DownloadFinished());
        }

        // emit(BorrowLoading());
      }
    } on DioError catch (e) {
      emit(GetFailedDownloadResponse(message: e.message ?? ""));
    }
  }

  Future<int> downloadDio({
    required String url,
    required String filepath,
    required String fileName,
    required String title,
    required String auth,
    required int bookId,
  }) async {
    var file = File("$filepath/$fileName");

    var dio = Dio();
    dio.interceptors.add(LogInterceptor());
    try {
      final header = {
        "Authorization": auth,
      };
      var response = await dio.get(
        url,
        onReceiveProgress: (received, total) {
          int percentage =
              int.parse((received / total * 100).toStringAsFixed(0));
          // _showProgressNotification();
          if (total != -1) {
            emit(DownloadLoading(total: 0, receive: percentage));
            int downloadProgress =
                int.parse((received / total * 100).toStringAsFixed(0));
            download(downloadProgress, bookId);
          }
        },
        //Received data with List<int>
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: const Duration(seconds: 30),
          headers: header,
        ),
      );
      debugPrint("download path: $filepath");
      var raf = file.openSync(mode: FileMode.write);
      print("RAF: $raf");
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
      return 100;
    } catch (e) {
      debugPrint(e.toString());
    }
    return 0;
  }

  void isBookExist(String title, int id, int countBooks) async {
    try {
      emit(BorrowLoading());
      FileProduct message = await ProductService().isBorrowed(title);
      List<WatchItemModel> watchItems =
          await ProductService().getWatchItemList();
      var items =
          watchItems.where((element) => element.title == title).toList();

      await debugLog(message.url); // await debugLog(message);
      if (message.url == "Belum minjam buku") {
        if (items.isNotEmpty &&
            items.first.title == title &&
            (countBooks < 1)) {
          emit(const GetWatchResponse(message: "Sudah Dalam Antrian"));
        } else {
          emit(BorrowInitial());
        }
        //emit(BorrowInitial());
      } else {
        SavedBook? data = await DatabaseHelper().getBook(id);
        if (data == null) {
          emit(isBookBorrowed(message: message));
        } else {
          emit(DownloadedBook(borrowedId: message.borrowedId ?? 0));
        }
      }
    } catch (e) {
      print("Failed isBookExist");
      emit(GetFailedBorrowResponse(message: e.toString()));
    }
  }

  void returnBook(String title, int id) async {
    try {
      emit(BorrowLoading());
      FileProduct message = await ProductService().isBorrowed(title);
      await DatabaseHelper().deleteBook(id);

      String? returnBook =
          await ProductService().returnBorrowed(message.borrowedId ?? id);
      if (returnBook == "Success mengembalikan  buku") {
        emit(ReturnSuccess());
      } else {
        emit(DownloadedBook(borrowedId: message.borrowedId ?? 0));
      }
    } catch (e) {
      print("Failed returnBook");
      emit(GetFailedBorrowResponse(message: e.toString()));
    }
  }

  void returnBookBeforeDownload(String title) async {
    try {
      emit(BorrowLoading());
      FileProduct message = await ProductService().isBorrowed(title);
      //await DatabaseHelper().deleteBook(id);

      String? returnBook =
          await ProductService().returnBorrowed(message.borrowedId!);
      if (returnBook == "Success mengembalikan  buku") {
        emit(ReturnSuccess());
      } else {
        emit(DownloadedBook(borrowedId: message.borrowedId ?? 0));
      }
    } catch (e) {
      print("Failed returnBookBeforeDownload");
      emit(GetFailedBorrowResponse(message: e.toString()));
    }
  }

  void cancelDownload(String title, int id, int countBooks) async {
    try {
      emit(BorrowLoading());
      EventChannelHelper().isLoading = false;
      EventChannelHelper().stopDownload();
      isBookExist(title, id, countBooks);
    } catch (e) {
      print("Failed cancelDownload");
      emit(GetFailedBorrowResponse(message: e.toString()));
    }
  }

  void deleteWatch(String title) async {
    try {
      emit(BorrowLoading());
      List<WatchItemModel> model = await ProductService().getWatchItemList();
      var items = model.where((element) => element.title == title).toList();
      await ProductService().deleteWatch(items.first.delete ?? "");
      emit(BorrowInitial());
    } catch (e) {
      print("Failed deleteWatch");
      emit(GetFailedBorrowResponse(message: e.toString()));
    }
  }
}
