import 'dart:async';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart' as intl;
import 'package:revamp_eperpus_mobile/Cubit/Product/Borrow/borrow_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/DetailProduct/detail_product_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/PopularBook/popular_book_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/RecommendationBook/recommendation_book_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Review/review_list_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Review/review_list_state.dart';
import 'package:revamp_eperpus_mobile/Service/analytic_services.dart';
import 'package:revamp_eperpus_mobile/Service/MessagingService.dart';
import 'package:revamp_eperpus_mobile/Service/database_helper.dart';
import 'package:revamp_eperpus_mobile/Service/product_service.dart';
import 'package:revamp_eperpus_mobile/Utils/style.dart';
import 'package:revamp_eperpus_mobile/Utils/utils.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/alert_dialog_native.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/button.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/rating_card_tile.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/recommendation_book_tile.dart';
import 'package:revamp_eperpus_mobile/View/Product/Component/download_indicator_component.dart';
import 'package:revamp_eperpus_mobile/View/Product/ReviewProduct/review_product_view.dart';
import 'package:revamp_eperpus_mobile/Helpers/api_client.dart';
import 'package:revamp_eperpus_mobile/Helpers/cache.dart';
import 'package:revamp_eperpus_mobile/Helpers/ui_helper.dart';
import 'package:revamp_eperpus_mobile/model/Analytic/DownloadAnalyticModel.dart';
import 'package:revamp_eperpus_mobile/model/Product/PartModel/cover_image_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/ReviewModel/review_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/detail_product_model.dart';
import 'package:revamp_eperpus_mobile/model/ProductKey.dart';
import 'package:revamp_eperpus_mobile/model/iOS/DownloadParameters.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/product_detail.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:revamp_eperpus_mobile/Helpers/alert_custom.dart';
import 'package:revamp_eperpus_mobile/Helpers/event_channel.dart';

class DetailProductView extends StatefulWidget {
  final String? detailUrl;
  final String? itemUrl;
  final String? bookTitle;
  final CoverImage? coverImage;
  final int? bookId;
  final int? id;
  final String? downloadUrl;
  final int? currentlyAvailable;

  const DetailProductView(
      {Key? key,
      this.detailUrl,
      this.itemUrl,
      this.bookTitle,
      this.coverImage,
      this.bookId,
      this.id,
      this.downloadUrl,
      this.currentlyAvailable})
      : super(key: key);

  @override
  State<DetailProductView> createState() => _DetailProductViewState();
}

class _DetailProductViewState extends State<DetailProductView> {
  int selectedPage = 0;
  int pageLength = 5;
  late TargetPlatform? platform;
  static const channel =
      MethodChannel('com.apps-foundry.eperpuswl.id.eperpus/navToReader');

  final PageController _pageViewController =
      PageController(initialPage: 0, keepPage: false);
  int? brandId;
  int? currentlyAvailable;
  String? editionCode;
  int progressiOS = 0;
  String format = "";

  StreamController? _streamController;

  Future<void> onMessageOpenApp() async {
    await MessagingService().openMessage(context);
  }

  bool isDownloadActive = false;

  @override
  void initState() {
    super.initState();
    onMessageOpenApp();
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
    // context
    //     .read<RecommendationBookCubit>()
    //     .getRecommendationBooks(widget.bookId!);
    // context.read<PopularBookCubit>().getPopularBooks(widget.bookId!);
    context.read<ReviewListCubit>().getBookReviewList(
          context,
          bookId: widget.bookId!,
        );
    context.read<DetailProductCubit>().getItemInfo(widget.itemUrl!);
    context.read<BorrowCubit>().isBookExist(
        widget.bookTitle ?? "", widget.id ?? 0, widget.currentlyAvailable ?? 0);
    _streamController = StreamController.broadcast();
  }

  @override
  void dispose() {
    _streamController?.close();
    super.dispose();
  }

  void showDownloadCloseAlert(AppLocalizations localization) {
    showAlertCustom(
        context: context,
        title: const Text("Warning"),
        content: Text(localization.downloadWarning),
        actions: [
          AlertButton(
              onTap: () async {
                await DatabaseHelper().deleteBook(widget.id ?? 0);
                if (Platform.isIOS) {
                  EventChannelHelper().stopDownload();
                }
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(localization.logoutNo)),
          AlertButton(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(localization.close))
        ]);
  }

  Future<void> downloadiOS({required DownloadParameters model}) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    try {
      final localPath = (await findLocalPath(widget.id!))!;
      final saveDir = Directory(localPath);
      await saveDir.create();
      int downloadProgress = 0;
      var channel = EventChannelHelper();

      channel.loadingDownload(model.toJson(), context, widget.id ?? 0);
      channel.isLoading = true;
      DatabaseHelper database = DatabaseHelper();
      var date = DateTime.now();
      date.add(const Duration(days: 7));
      database.insertBook(
        SavedBook(
          image: widget.coverImage?.href ?? "",
          title: widget.bookTitle ?? "",
          detailUrl: "",
          filePathZip: "",
          productId: model.id,
          filePathPDF: "",
          brandId: model.brandId,
          key: model.key,
          userId: 0,
          fileType: model.fileType,
          editionCode: "",
          date: date.toString(),
          watermark: model.watermark,
          company: model.company,
          expires: model.expires,
        ),
      );
    } catch (e) {
      var date = intl.DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
          .format(DateTime.now());

      var userId = sharedPreferences.getInt("user_id");
      var modelDevice = sharedPreferences.getString("modelDevice");
      String apiAddress = await AnalyticService().getIpAddress();
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo? iosInfo;
      if (Platform.isIOS) {
        iosInfo = await deviceInfo.iosInfo;
      }
      DownloadAnalytic download = DownloadAnalytic(
          catalogId: ApiClient.instance.baseCatalogId,
          clientId: "${ApiClient.instance.clientId}",
          organizationId: ApiClient.instance.baseOrganizationId,
          userId: userId!,
          deviceId: iosInfo!.identifierForVendor ?? "",
          itemId: widget.id ?? 0,
          clientVersion: "2.0.7",
          dateTime: date.toString(),
          deviceModel: modelDevice!,
          downloadStatus: "Error",
          ipAddresss: apiAddress,
          sessionName: "");
      await debugLog("downloadiOS Error: $e");
      await AnalyticService()
          .downloadItem(model: DownloadAnlyticModel(data: [download]));
    }
  }

  bool permissionStatus = true;
  Future<void> checkPermission() async {
    final info = await DeviceInfoPlugin().androidInfo;

    PermissionStatus status = await Permission.storage.status;
    print("PermissionStatus status: $status");

    if(info.version.sdkInt < 33){
      if (status == PermissionStatus.granted) {
        setState(() {
          permissionStatus = true;
        });
      } else {
        PermissionStatus result = await Permission.storage.request();
        print("PermissionStatus result: $result");
        if (result == PermissionStatus.granted) {
          setState(() {
            permissionStatus = true;
          });
        } else if (result == PermissionStatus.denied) {
          await checkPermission();
        } else if (await Permission.storage.isPermanentlyDenied) {
          openAppSettings();
        }
      }
    }else{
      setState(() {
        permissionStatus = true;
      });
    }
  }

  Future<void> downloadAndroid(
    String url,
    ItemInfoModel itemInfo,
    String expires,
  ) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString("JWT");
    await checkPermission();
    if (permissionStatus) {
      final localPath = (await findLocalPath(widget.id!))!;
      final saveDir = Directory(localPath);
      await saveDir.create();

      String fileName = "${widget.id}.zip";

      try {
        await Future.delayed(const Duration(seconds: 1), () async {
          await context.read<BorrowCubit>().downloadDio(
                url: widget.downloadUrl ?? url,
                filepath: saveDir.path,
                fileName: fileName,
                title: widget.bookTitle!,
                auth: token!,
                bookId: widget.id ?? 0,
              );
          DatabaseHelper database = DatabaseHelper();
          ProductKey key = await ProductService().getKey(widget.id ?? 0);
          String? watermark = await getWatermark();
          var date = DateTime.now();
          date.add(const Duration(days: 7));
          print("Expires Date: $expires");
          database.insertBook(
            SavedBook(
              image: widget.coverImage?.href ?? "",
              title: widget.bookTitle!,
              detailUrl: widget.detailUrl ?? "",
              filePathZip: "${saveDir.path}/${widget.id}.zip",
              productId: widget.id ?? 0,
              filePathPDF: saveDir.path,
              brandId: itemInfo.brand!.id ?? 0,
              key: key.key,
              userId: 0,
              fileType: key.fileExtension,
              editionCode: itemInfo.editionCode ?? "",
              date: date.toString(),
              watermark: watermark ?? ApiClient.instance.watermark,
              company: itemInfo.vendor?.title ?? "",
              expires: expires,
            ),
          );
        });
      } catch (e) {
        await debugLog("catch error download android: $e");
        var date = intl.DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
            .format(DateTime.now());

        var userId = sharedPreferences.getInt("user_id");
        var modelDevice = sharedPreferences.getString("modelDevice");
        String apiAddress = await AnalyticService().getIpAddress();
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo? deviceInfo0;

        deviceInfo0 = await deviceInfo.androidInfo;

        DownloadAnalytic download = DownloadAnalytic(
            catalogId: ApiClient.instance.baseCatalogId,
            clientId: "${ApiClient.instance.clientId}",
            organizationId: ApiClient.instance.baseOrganizationId,
            userId: userId!,
            deviceId: deviceInfo0.id,
            itemId: widget.id ?? 0,
            clientVersion: "2.0.7",
            dateTime: date.toString(),
            deviceModel: modelDevice!,
            downloadStatus: "Error",
            ipAddresss: apiAddress,
            sessionName: "");
        await AnalyticService()
            .downloadItem(model: DownloadAnlyticModel(data: [download]));
      }
    } else {
      await debugLog("Permission download denied");
    }
  }

  Future<void> deleteFiles(int id) async {
    try {
      await channel.invokeMethod("delete", {"productId": id});
    } catch (e) {
      await debugLog(e.toString());
    }
  }

  Future<String?> openEpub(SavedBook data) async {
    try {
      String url = await channel.invokeMethod("epub", data.toJson());
      return url;
    } on PlatformException catch (e) {
      debugPrint("$e");
      return null;
    }
  }

  Future<String?> openPDF(SavedBook data) async {
    try {
      String url = await channel.invokeMethod("pdf", data.toJson());
      return url;
    } on PlatformException catch (e) {
      debugPrint("$e");

      return null;
    }
  }

  Widget recommendationBooks(Size size) {
    return BlocBuilder<RecommendationBookCubit, RecommendationBookState>(
        builder: (context, state) {
      if (state is RecommendationBookLoading) {
        return SizedBox(
          width: size.width,
          height: size.height,
          child: const Center(
            child: SpinKitFoldingCube(
              size: 32,
              color: Colors.blue,
            ),
          ),
        );
      } else if (state is GetRecommendationBooksResponse) {
        //Topik Serupa
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Topik Serupa",
                style: h4Title,
              ),
            ),
            SizedBox(
              height: size.height * 0.35,
              width: size.width,
              child: ListView.builder(
                padding: const EdgeInsets.all(13),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 136,
                    height: 175,
                    child: RecommendationBookWidget(
                      isDark: 1,
                      title: state.books[index].name!,
                      image:
                          "https://ebooks.gramedia.com/ebook-covers/${state.books[index].thumbImageNormal!}",
                      subtitle: state.books[index].vendor!.name!,
                      id: state.books[index].id!,
                    ),
                  );
                },
                itemCount: state.books.length < 10 ? state.books.length : 10,
              ),
            ),
          ],
        );
      }
      return Container();
    });
  }

  Widget popularBooks(Size size) {
    return BlocBuilder<PopularBookCubit, PopularBookState>(
        builder: (context, state) {
      if (state is PopularBookLoading) {
        return SizedBox(
          width: size.width,
          height: size.height,
          child: const Center(
            child: SpinKitFoldingCube(
              size: 32,
              color: Colors.blue,
            ),
          ),
        );
      } else if (state is GetPopularBooksResponse) {
        //Topik Serupa
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Sedang Populer",
                style: h4Title,
              ),
            ),
            SizedBox(
              height: size.height * 0.35,
              width: size.width,
              child: ListView.builder(
                padding: const EdgeInsets.all(13),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 136,
                    height: 175,
                    child: RecommendationBookWidget(
                      isDark: 1,
                      title: state.books[index].name,
                      image:
                          "https://s3-ap-southeast-1.amazonaws.com/ebook-covers${state.books[index].thumbImageNormal}",
                      subtitle: state.books[index].vendor.name,
                      id: state.books[index].id,
                    ),
                  );
                },
                itemCount: state.books.length < 10 ? state.books.length : 10,
              ),
            ),
          ],
        );
      }
      return Container();
    });
  }

  int numberOfBorrowed = 0;

  Future<void> getListOfBorrowed() async {
    DatabaseHelper database = DatabaseHelper();
    List<SavedBook> listOfBook = await database.getBooks();
    numberOfBorrowed = listOfBook.length;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final localization = AppLocalizations.of(context)!;

    Widget buttonBorrow({required ItemInfoModel itemInfo}) {
      return BlocConsumer<BorrowCubit, BorrowState>(
        builder: (context, state) {
          if (state is BorrowLoading) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: const FractionallySizedBox(
                widthFactor: 0.8,
                child: Center(
                  child: SpinKitFoldingCube(
                    size: 32,
                    color: Colors.blue,
                  ),
                ),
              ),
            );
          } else if (state is GetBorrowResponse) {
            return SizedBox(
              width: size.width,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (Platform.isIOS) {
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            String token = preferences.getString("JWT") ?? "";
                            ProductKey key =
                                await ProductService().getKey(widget.id ?? 0);
                            String? email = preferences.getString("email");
                            int? userId = preferences.getInt("user_id");
                            String? watermark = await getWatermark();
                            int? organizationId =
                                preferences.getInt("organizationId");
                            print("ORG ID ${organizationId ?? 0}");
                            int? catalogId = preferences.getInt("catalogId");
                            DownloadParameters dataModel = DownloadParameters(
                              id: widget.id ?? 0,
                              token: token,
                              brandId: itemInfo.brand!.id ?? 0,
                              editionCode: itemInfo.editionCode ?? "",
                              fileType: key.fileExtension,
                              key: key.key,
                              email: email ?? "",
                              userId: userId ?? 0,
                              watermark:
                                  watermark ?? ApiClient.instance.watermark,
                              company: itemInfo.vendor?.title ?? "",
                              clientId: ApiClient.instance.clientId,
                              catalogId: catalogId ?? 0,
                              organizationId: organizationId ?? 0,
                              borrowedId: state.borrowedRes.id,
                              item_type: '',
                              expires: state.borrowedRes.expires,
                            );
                            downloadiOS(model: dataModel);
                          } else {
                            downloadAndroid(
                              state.borrowedRes.download.href!,
                              itemInfo,
                              state.borrowedRes.expires,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue[800],
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text(
                          localization.download,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: ElevatedButton(
                        onPressed: () async {
                          context.read<BorrowCubit>().returnBookBeforeDownload(
                                widget.bookTitle ?? "",
                              );
                          context
                              .read<DetailProductCubit>()
                              .getDetailRetry(widget.itemUrl!);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text(localization.returnBook,
                            style: h4Title.copyWith(color: primaryColor)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is isBookBorrowed) {
            return SizedBox(
              width: size.width,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (Platform.isIOS) {
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            ProductKey key =
                                await ProductService().getKey(widget.id ?? 0);
                            String token = preferences.getString("JWT") ?? "";
                            String? email = preferences.getString("email");
                            int? userId = preferences.getInt("user_id");
                            String? watermark = await getWatermark();
                            int? organizationId =
                                preferences.getInt("organizationId");
                            int? catalogId = preferences.getInt("catalogId");
                            DownloadParameters dataModel = DownloadParameters(
                              id: widget.id ?? 0,
                              token: token,
                              brandId: itemInfo.brand!.id ?? 0,
                              editionCode: itemInfo.editionCode ?? "",
                              fileType: key.fileExtension,
                              key: key.key,
                              email: email ?? "",
                              userId: userId ?? 0,
                              watermark:
                                  watermark ?? ApiClient.instance.watermark,
                              company: itemInfo.vendor?.title ?? "",
                              clientId: ApiClient.instance.clientId,
                              catalogId: catalogId ?? 0,
                              organizationId: organizationId ?? 0,
                              borrowedId: state.message.borrowedId ?? 0,
                              item_type: '',
                              expires: state.message.expires ?? "",
                            );
                            print("${dataModel}");
                            downloadiOS(model: dataModel);
                          } else {
                            final downloadUrl =
                                "https://scoopadm.apps-foundry.com/scoopcor/api/v1/items/${widget.id}/download";
                            downloadAndroid(
                              downloadUrl,
                              itemInfo,
                              state.message.expires ?? "",
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue[800],
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text(
                          localization.download,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: ElevatedButton(
                        onPressed: () async {
                          context
                              .read<BorrowCubit>()
                              .returnBookBeforeDownload(widget.bookTitle ?? "");
                          context
                              .read<DetailProductCubit>()
                              .getDetailRetry(widget.itemUrl!);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text(localization.returnBook,
                            style: h4Title.copyWith(color: primaryColor)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is DownloadLoading) {
            // if (Platform.isIOS) {
            //   return ClipRRect(
            //     borderRadius: BorderRadius.circular(10.0),
            //     child: const FractionallySizedBox(
            //       widthFactor: 0.8,
            //       child: Center(
            //         child: SpinKitFoldingCube(
            //           size: 32,
            //           color: Colors.blue,
            //         ),
            //       ),
            //     ),
            //   );
            // } else {
            isDownloadActive = true;
            return Column(
              children: [
                DownloadIndicatorComponent(
                  length: state.total,
                  receive: state.receive,
                ),
              ],
            );
            //}
          } else if (state is DownloadedBook) {
            isDownloadActive = false;
            return SizedBox(
              width: size.width * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: ElevatedButton(
                        onPressed: () async {
                          SavedBook? data =
                              await DatabaseHelper().getBook(widget.id ?? 0);
                          if (Platform.isIOS) {
                            if (data?.fileType == "pdf") {
                              await debugLog("openPdf");
                              openPDF(data!);
                            } else {
                              openEpub(data!);
                            }
                          } else {
                            await unlockDownloadedZip(
                              context,
                              widget.bookTitle!,
                              widget.id!,
                              brandId!,
                              editionCode: editionCode,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text(
                          localization.read,
                          style: h3Title.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: ElevatedButton(
                        onPressed: () async {
                          await DatabaseHelper().deleteBook(widget.id ?? 0);
                          context.read<BorrowCubit>().returnBook(
                              widget.bookTitle ?? "", state.borrowedId);
                          context
                              .read<DetailProductCubit>()
                              .getDetailRetry(widget.itemUrl!);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text(localization.returnBook,
                            style: h4Title.copyWith(color: primaryColor)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is GetWatchResponse) {
            return SizedBox(
              width: size.width,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: SizedBox(
                        width: size.width,
                        child: ElevatedButton.icon(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: itemInfo.currentlyAvailable! > 0
                                ? Colors.blue[800]
                                : Colors.grey,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          icon: const Icon(Icons.alarm_rounded),
                          label: Text(
                            localization.remindMe,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: SizedBox(
                        width: size.width,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context
                                .read<BorrowCubit>()
                                .deleteWatch(widget.bookTitle ?? "");
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          icon: const Icon(Icons.alarm_off),
                          label: const Text(
                            "Hapus Antrian",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else if (state is DownloadFinished) {
            isDownloadActive = false;
            return SizedBox(
              width: size.width * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: ElevatedButton(
                        onPressed: () async {
                          SavedBook? data =
                              await DatabaseHelper().getBook(widget.id ?? 0);
                          if (Platform.isIOS) {
                            if (data?.fileType == "pdf") {
                              await debugLog("openPdf");
                              openPDF(data!);
                            } else {
                              openEpub(data!);
                            }
                          } else {
                            await unlockDownloadedZip(
                              context,
                              widget.bookTitle!,
                              widget.id!,
                              brandId!,
                              editionCode: editionCode,
                            );
                          }
                          await debugLog('brandId: $brandId');
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text(
                          localization.read,
                          style: h3Title.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: ElevatedButton(
                        onPressed: () async {
                          await DatabaseHelper().deleteBook(widget.id ?? 0);
                          if (Platform.isIOS) {
                            deleteFiles(widget.id ?? 0);
                            context
                                .read<BorrowCubit>()
                                .returnBook(widget.bookTitle ?? "", 0);
                            context
                                .read<DetailProductCubit>()
                                .getDetailRetry(widget.itemUrl!);
                          } else {
                            context
                                .read<BorrowCubit>()
                                .returnBook(widget.bookTitle ?? "", 0);
                            context
                                .read<DetailProductCubit>()
                                .getDetailRetry(widget.itemUrl!);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text(localization.returnBook,
                            style: h4Title.copyWith(color: primaryColor)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton.icon(
                onPressed: numberOfBorrowed < 2
                    ? () {
                        if (itemInfo.currentlyAvailable! > 0) {
                          context.read<BorrowCubit>().borrow(itemInfo);
                          context
                              .read<DetailProductCubit>()
                              .getDetailRetry(widget.itemUrl!);
                        } else {
                          context.read<BorrowCubit>().watch(itemInfo);
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  primary: itemInfo.currentlyAvailable! > 0
                      ? Colors.blue[800]
                      : Colors.blue[800],
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                icon: itemInfo.currentlyAvailable! > 0
                    ? const Icon(Icons.book)
                    : const Icon(Icons.alarm_rounded),
                label: Text(
                  itemInfo.currentlyAvailable! > 0
                      ? localization.borrow
                      : localization.remindMe,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is GetFailedBorrowResponse) {
            if (Platform.isIOS) {
              showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialogNative(
                      title: Text("Pesan"),
                      content: Text(state.message),
                      action: [
                        CupertinoDialogAction(
                          child: Text(localization.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    );
                  });
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialogNative(
                    title: Text("Pesan"),
                    content: Text(state.message),
                    action: [
                      Button(
                        title: "Close",
                        onTap: () => Navigator.pop(context),
                        radius: 12,
                        style: h6Title,
                        color: primaryColor,
                      )
                    ],
                  );
                },
              );
            }
          } else if (state is GetFailedDownloadResponse) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialogNative(
                  title: Text(state.message),
                  content: const Text("Download Failed"),
                  action: [
                    Button(
                      title: "Close",
                      onTap: () => Navigator.pop(context),
                      radius: 12,
                      style: h6Title,
                      color: primaryColor,
                    )
                  ],
                );
              },
            );
          } else if (state is ReturnSuccess) {
            if (Platform.isIOS) {
              showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: Text(localization.successReturnedBook),
                      content: Text(localization.thankYou),
                      actions: [
                        CupertinoDialogAction(
                          child: Text(localization.close),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  });
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialogNative(
                      title: Text(localization.successReturnedBook),
                      content: Text(localization.thankYou),
                      action: [
                        Button(
                          title: localization.close,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          radius: 12,
                          style: h6Title,
                          color: primaryColor,
                        )
                      ],
                    );
                  });
            }
          }
        },
      );
    }

    Widget productPreviewImages(
      maxWidth,
      maxHeight,
      List<String> imagesArray,
    ) {
      return Column(
        children: [
          ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
            child: PageView.builder(
              controller: _pageViewController,
              onPageChanged: (index) {
                setState(() => selectedPage = index);
              },
              itemCount: (imagesArray.isNotEmpty) ? imagesArray.length : 0,
              itemBuilder: (context, index) => Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: SizedBox(
                        height: 240,
                        child: CachedNetworkImage(
                          height: 240,
                          fit: BoxFit.cover,
                          imageUrl: imagesArray[index],
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error, size: 30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          (imagesArray.length > 1)
              ? Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: UIHelper.buildPageIndicator(
                      (imagesArray.isNotEmpty) ? imagesArray.length : 1,
                      selectedPage,
                      context,
                      indicatorSize: 8,
                    ),
                  ),
                )
              : Container(
                  height: 10,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
        ],
      );
    }

    List<String> imageThumbnail = [widget.coverImage!.href!];
    Widget builderDetail() {
      return BlocBuilder<DetailProductCubit, DetailProductState>(
          builder: (context, state) {
        // await debugLog(state);
        if (state is DetailProductLoading) {
          return SliverToBoxAdapter(
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: const Center(
                child: SpinKitFoldingCube(
                  size: 32,
                  color: Colors.blue,
                ),
              ),
            ),
          );
        }
        if (state is GetDetailProductResponse) {
          final detailProduct = state.detailProduct;
          brandId = detailProduct.brand!.id;
          // await debugLog("detailProduct brandId: $brandId");
          editionCode = detailProduct.editionCode;
          // await debugLog("detailProduct editionCode: $editionCode");
          List<String> imagePreviews = [];
          // await debugLog("count: ${detailProduct.preview!.length}");
          for (var element in detailProduct.preview!) {
            // await debugLog(element.href);
            imagePreviews.add(element.href!);
          }
          final String bookDescription = detailProduct.description!;
          bool isHtml = bookDescription.contains("<p>");
          return SliverList(
            delegate: SliverChildListDelegate(
              [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SingleChildScrollView(
                      // scrollDirection: Axis.vertical,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          // ANCHOR - Product Image and Preview Function
                          const SizedBox(height: 20),
                          OpenContainer(
                            closedElevation: 0.0,
                            openElevation: 1.0,
                            closedColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            middleColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            openColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            transitionType: ContainerTransitionType.fadeThrough,
                            transitionDuration:
                                const Duration(milliseconds: 1000),
                            openBuilder: (context, action) => ProductPreview(
                              maxWidth: size.width,
                              maxHeight: size.height * 0.6,
                              imagesArray: imagePreviews.isNotEmpty
                                  ? imagePreviews
                                  : imageThumbnail,
                            ),
                            closedBuilder: (context, openPreviewContainer) {
                              return GestureDetector(
                                  onTap: openPreviewContainer,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      productPreviewImages(
                                        size.width,
                                        240.0,
                                        imagePreviews.isNotEmpty
                                            ? imagePreviews
                                            : imageThumbnail,
                                      ),
                                      Visibility(
                                        visible: false,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: const Banner(
                                            layoutDirection: TextDirection.ltr,
                                            message: "EPUB",
                                            color: Colors.blue,
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10,
                                            ),
                                            location: BannerLocation.bottomEnd,
                                            child: SizedBox(
                                              height: 240,
                                              width: 153,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ));
                            },
                          ),
                          const SizedBox(height: 20),

                          // ANCHOR - Product Name and Author
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              children: [
                                Text(
                                  detailProduct.title!,
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  detailProduct.subtitle!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                  ),
                                ),
                                const Divider(
                                  indent: 0,
                                  endIndent: 0,
                                  thickness: 2,
                                  height: 30,
                                ),
                              ],
                            ),
                          ),

                          // ANCHOR - Product Rating, File Size, Page size, Stock
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                color: Theme.of(context).splashColor,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          localization.rating,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          detailProduct.rating!.average
                                                  .toString() +
                                              '/5',
                                          style: const TextStyle(
                                            letterSpacing: 2,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          localization.pagesize,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          "${detailProduct.pageCount}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          localization.fileSize,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          detailProduct.fileSize!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          localization.stock,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          detailProduct.currentlyAvailable
                                              .toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "Format",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          "${state.detailProduct.contentType == "pdf" ? "PDF" : "EPUB"}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // ANCHOR - Borrow, Remind Me
                          buttonBorrow(itemInfo: detailProduct),
                          const SizedBox(height: 30),

                          // ANCHOR - Product Overview
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                  localization.overview,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  child: isHtml
                                      ? HtmlWidget(bookDescription)
                                      : Text(
                                          bookDescription,
                                          textAlign: TextAlign.justify,
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: 0,
                                          ),
                                        ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),

                          // ANCHOR - Product Reviews
                          BlocBuilder<ReviewListCubit, ReviewListState>(
                            builder: (context, state) {
                              if (state is ReviewListResState) {
                                List<Review> dataList =
                                    state.props[1] as List<Review>;
                                bool isLoading = state.props[2] as bool;
                                return Visibility(
                                  visible: !isLoading && dataList.isNotEmpty,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24),
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextButton.icon(
                                                onPressed: () {
                                                  // if (isReviewEmpty == true) {
                                                  //   return;
                                                  // }
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return ReviewProductView(
                                                          model: detailProduct,
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.arrow_back_ios_rounded,
                                                  size: 19,
                                                ),
                                                label: Text(
                                                  localization.seeAll,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                                style: TextButton.styleFrom(),
                                              ),
                                              Text(
                                                localization.reviews,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        width: double.infinity,
                                        height: 220,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: size.width * 0.1,
                                          ),
                                          itemBuilder: (context, index) {
                                            Review item = dataList[index];
                                            return RatingCardTile(item: item);
                                          },
                                          itemCount: dataList.length < 2
                                              ? dataList.length
                                              : 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              if (state is ReviewListFailed) {
                                return Container();
                              }
                              return Container();
                            },
                          ),
                          // recommendationBooks(size),
                          // const SizedBox(height: 12),
                          // popularBooks(size),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        }
        return const SliverToBoxAdapter(child: Text("Error"));
      });
    }

    return WillPopScope(
      onWillPop: () async {
        if (isDownloadActive) {
          showDownloadCloseAlert(localization);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          foregroundColor: Theme.of(context).textSelectionTheme.selectionColor,
          backgroundColor: Platform.isIOS
              ? Theme.of(context).scaffoldBackgroundColor
              : Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text(localization.info),
                    content: Text(localization.bookInfo),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(
                Icons.info_outline,
              ),
            ),
          ],
        ),
        body: CustomScrollView(
          slivers: [builderDetail()],
        ),
      ),
    );
  }
}
