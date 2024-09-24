import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/DeviceCollection/device_collection_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/DeviceCollection/saved_collection_cubit.dart';
import 'package:revamp_eperpus_mobile/Helpers/alert_unauthorized.dart';
import 'package:revamp_eperpus_mobile/Service/database_helper.dart';
import 'package:revamp_eperpus_mobile/Service/product_service.dart';
import 'package:revamp_eperpus_mobile/Utils/Style.dart';
import 'package:revamp_eperpus_mobile/Utils/config.dart';
import 'package:revamp_eperpus_mobile/Utils/utils.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/Card/book_borrowed_card.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/button.dart';
import 'package:revamp_eperpus_mobile/View/Product/DetailProduct/detail_product_view.dart';
import 'package:revamp_eperpus_mobile/View/Product/DeviceCollection/device_collection_all_view.dart';
import 'package:revamp_eperpus_mobile/View/Product/DeviceCollection/device_collection_saved_books_view.dart';
import 'package:revamp_eperpus_mobile/Helpers/cache.dart';
import 'package:revamp_eperpus_mobile/model/Product/borrowed_item_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/library_product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import 'package:revamp_eperpus_mobile/Helpers/api_client.dart';
import '../../CustomWidget/alert_dialog_native.dart';
import '../../SignIn/signin_view.dart';

class DeviceCollectionView extends StatefulWidget {
  const DeviceCollectionView({Key? key, this.onForceLogout}) : super(key: key);
  final VoidCallback? onForceLogout;

  @override
  State<DeviceCollectionView> createState() => _DeviceCollectionViewState();
}

class _DeviceCollectionViewState extends State<DeviceCollectionView> {
  static const platform =
      MethodChannel('com.apps-foundry.eperpuswl.id.eperpus/navToReader');
  var databaseHelper = DatabaseHelper();
  int isDark = 0;
  int countValueAnalytic = 0;

  Future<void> navigationReader(String url, SavedBook data) async {
    try {
      await platform.invokeMethod('goToReader', data.toJson());
    } on PlatformException catch (e) {
      await debugLog(e.toString());
    }
  }

  Future<void> syncDataAnalytics() async {
    try {
      await platform.invokeMethod("syncReader", {"Test": "Test"});
    } on PlatformException catch (e) {
      await debugLog(e.toString());
    }
  }

  final GlobalKey _borrowedCount = GlobalKey();
  final GlobalKey _borrowedBook = GlobalKey();

  @override
  void initState() {
    initStateDarkMode();
    context.read<DeviceCollectionCubit>().getDeviceCollection();
    context.read<SavedCollectionCubit>().getDataSaved();
    initShowCase();
    super.initState();
  }

  Future<void> initStateDarkMode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isDark = sharedPreferences.getInt('themeStatus')!;
    var date = DateTime.now();
    DatabaseHelper helper = DatabaseHelper();
    List<SavedBook> books = await helper.getBooks();
    countValueAnalytic = sharedPreferences.getInt("countAnalytic") ?? 0;
    for (var element in books) {
      if (element.date == date.toString()) {
        helper.deleteBook(element.productId);
      }
    }
  }

  Future<void> onSelectBorrowedBook(String url) async {
    try {
      await debugLog(url);
      final LibraryProductModel? bookDetail =
          await ProductService().getBorrowedDetail(url);
      final res = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DetailProductView(
            id: bookDetail?.id,
            itemUrl: bookDetail?.href,
            detailUrl: bookDetail?.details!.href,
            bookTitle: bookDetail?.title,
            bookId: bookDetail?.id,
            coverImage: bookDetail?.coverImage,
          ),
        ),
      );
      debugPrint(res);
      // context.read<DeviceCollectionCubit>().getDeviceCollection();
      // context.read<SavedCollectionCubit>().getDatasaved();
    } catch (e) {
      await debugLog("Error: $e");
    }
  }

  Future<String?> unzipFile(SavedBook data) async {
    try {
      String url = await platform.invokeMethod("unzipFile", data.toJson());
      return url;
    } catch (e) {
      await debugLog("Error: $e");
      return null;
    }
  }

  Future<void> deleteFiles(int id) async {
    try {
      await platform.invokeMethod("delete", {"productId": id});
    } catch (e) {
      await debugLog("Error: $e");
    }
  }

  Future<String?> openEpub(SavedBook data) async {
    try {
      String url = await platform.invokeMethod("epub", data.toJson());
      return url;
    } on PlatformException catch (e) {
      await debugLog("Error: $e");
      return null;
    }
  }

  Future<String?> openPDF(SavedBook data) async {
    try {
      String url = await platform.invokeMethod("pdf", data.toJson());
      return url;
    } on PlatformException catch (e) {
      await debugLog("Error: $e");
      return null;
    }
  }

  bool? isFirstTime = true;
  Future<void> initShowCase() async {
    isFirstTime = await getShowCaseDevice();
    if (isFirstTime!) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context)
            .startShowCase([_borrowedCount, _borrowedBook]);
        // super.initState();
      });
      await setShowCaseDevice(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget buildBorrowedBookList() {
      return BlocConsumer<DeviceCollectionCubit, DeviceCollectionState>(
        builder: (context, state) {
          if (state is DeviceCollectionLoading) {}
          if (state is GetDataCollectionEmpty) {
            return Container(
              width: size.width,
              height: size.height * 0.3,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 28.5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.borrowedBook,
                              style: h4Title.apply(
                                color: isDark == 1
                                    ? const Color(0XFF091A33)
                                    : Colors.white,
                              ),
                            ),
                            const SizedBox(width: 4),
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.blue,
                              child: Text(
                                "0",
                                style: h4Title.copyWith(color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          if (state is GetDataCollectionResponse) {
            return Container(
              width: size.width,
              height: size.height * 0.3,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 28.5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Showcase(
                          key: _borrowedCount,
                          title: AppLocalizations.of(context)!.deviceCase,
                          description:
                              AppLocalizations.of(context)!.messageCase,
                          tooltipBackgroundColor:
                              Theme.of(context).primaryColor,
                          textColor: isDark == 0 ? Colors.black : Colors.white,
                          targetShapeBorder: const CircleBorder(),
                          child: Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.borrowedBook,
                                style: h4Title.apply(
                                  color: isDark != null
                                      ? isDark == 0
                                          ? Colors.white
                                          : Colors.black
                                      : Colors.black54,
                                ),
                              ),
                              const SizedBox(width: 4),
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.blue,
                                child: Text(
                                  "${state.model.length}",
                                  style: h4Title.copyWith(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            dynamic res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DeviceCollectionAllView(
                                  books: state.model,
                                  appBarTitle: AppLocalizations.of(context)!
                                      .borrowedBook,
                                  isDark: isDark,
                                ),
                              ),
                            );
                            debugPrint('$res');
                            context
                                .read<DeviceCollectionCubit>()
                                .getDeviceCollection();
                            context.read<SavedCollectionCubit>().getDataSaved();
                          },
                          child: Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.seeAll,
                                style: h6Title.copyWith(
                                  color: isDark == 1
                                      ? const Color(0XFF091A33)
                                      : Colors.white,
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: primaryColor,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 124,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final BorrowedBookModel borrowedBook =
                            state.model[index];
                        DateTime expiresDateTime =
                            DateTime.parse(borrowedBook.expires);
                        final DateFormat formatter = DateFormat('dd-MM-yyyy');
                        final String expiresDate =
                            formatter.format(expiresDateTime);
                        return Container(
                          padding: index == 0
                              ? const EdgeInsets.only(
                                  left: 12, top: 4, bottom: 4)
                              : const EdgeInsets.symmetric(vertical: 4),
                          child: CardBookDownloadedWidget(
                            isDark: isDark,
                            id: borrowedBook.details.id!,
                            itemUrl: borrowedBook.catalogItem.href!,
                            detailUrl: borrowedBook.details.href!,
                            bookTitle: borrowedBook.title,
                            bookId: borrowedBook.details.id!,
                            coverImage: borrowedBook.coverImage,
                            name: borrowedBook.vendor.title!,
                            downloadUrl: borrowedBook.download.href!,
                            expiresDate: expiresDate,
                          ),
                        );
                      },
                      itemCount: state.model.length,
                    ),
                  )
                ],
              ),
            );
          }
          if (state is GetFailedDataCollection) {}
          return Container(
            width: size.width,
            height: size.height * 0.3,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    left: 24,
                    right: 28.5,
                    bottom: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(AppLocalizations.of(context)!.borrowedBook,
                              style: h4Title),
                          const SizedBox(width: 4),
                          CircleAvatar(
                            radius: 12,
                            child: Text(
                              "0",
                              style: h4Title.copyWith(color: Colors.white),
                            ),
                            backgroundColor: Colors.blue,
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.seeAll,
                              style: h6Title.copyWith(color: Colors.grey),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: primaryColor,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 104),
                  child: CircularProgressIndicator(),
                )
              ],
            ),
          );
        },
        listener: (context, state) {
          if (state is UserForceLogout) {
            if (Platform.isIOS) {
              showCupertinoDialog(
                context: context,
                builder: (context) {
                  return AlertDialogNative(
                    title: Text(AppLocalizations.of(context)!.unauthorized),
                    content:
                        Text(AppLocalizations.of(context)!.unauthorizedText),
                    action: [
                      CupertinoDialogAction(
                        child: Text(AppLocalizations.of(context)!.close),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            SignInUIForm.routeName,
                          );
                        },
                      )
                    ],
                  );
                },
              );
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialogNative(
                    title: Text(AppLocalizations.of(context)!.unauthorized),
                    content:
                        Text(AppLocalizations.of(context)!.unauthorizedText),
                    action: [
                      Button(
                        title: AppLocalizations.of(context)!.close,
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            SignInUIForm.routeName,
                          );
                        },
                        radius: 12,
                        color: Colors.green,
                        style: h6Title,
                      )
                    ],
                  );
                },
              );
            }
          }
          if (state is DeviceReturnSuccess) {
            if (Platform.isIOS) {
              showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: Text(
                          AppLocalizations.of(context)!.successReturnedBook),
                      content: Text(AppLocalizations.of(context)!.thankYou),
                      actions: [
                        CupertinoDialogAction(
                          child: Text(AppLocalizations.of(context)!.close),
                          onPressed: () {
                            context
                                .read<DeviceCollectionCubit>()
                                .getDeviceCollection();
                            context.read<SavedCollectionCubit>().getDataSaved();
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
                      title: Text(
                          AppLocalizations.of(context)!.successReturnedBook),
                      content: Text(AppLocalizations.of(context)!.thankYou),
                      action: [
                        Button(
                          title: AppLocalizations.of(context)!.close,
                          onTap: () {
                            context
                                .read<DeviceCollectionCubit>()
                                .getDeviceCollection();
                            context.read<SavedCollectionCubit>().getDataSaved();
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
          if (state is GetBorrowedUnauthorized) {
            widget.onForceLogout!();
            showUnauthorizedDialog(context, AppLocalizations.of(context)!);
          }
        },
      );
    }

    Widget buildDownloadedBookList() {
      return BlocConsumer<SavedCollectionCubit, SavedCollectionState>(
          builder: (context, state) {
        if (state is DeviceCollectionLoading) {
          return SizedBox(
            width: size.width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 28.5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.borrowedBook,
                            style: h4Title,
                          ),
                          const SizedBox(width: 4),
                          const CircleAvatar(
                            radius: 12,
                            child: Text("0"),
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.seeAll,
                              style: h6Title.copyWith(color: Colors.grey),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: primaryColor,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(),
                )
              ],
            ),
          );
        } else if (state is GetEmptyDataSavedCollection) {
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  left: 24,
                  right: 28.5,
                  bottom: 8,
                  top: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.savedBooks,
                      style: h4Title.apply(
                        color: isDark != null
                            ? isDark == 0
                                ? Colors.white
                                : Colors.black
                            : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 262,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ],
          );
        } else if (state is GetDataSavedCollection) {
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  left: 24,
                  right: 28.5,
                  bottom: 8,
                  top: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.saveBook,
                          style: h4Title,
                        ),
                        const SizedBox(width: 4),
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.blue,
                          child: Text(
                            "${state.model.length}",
                            style: h4Title.copyWith(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DeviceCollectionSavedBooksView(
                              isDark: isDark,
                              books: state.model,
                              appBarTitle:
                                  AppLocalizations.of(context)!.savedBooks,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.seeAll,
                            style: h6Title.copyWith(
                                color:
                                    isDark == 0 ? Colors.white : Colors.black),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: primaryColor,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 270,
                color: Theme.of(context).scaffoldBackgroundColor,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.model.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding:
                          index == 0 ? const EdgeInsets.only(left: 16) : null,
                      child: GestureDetector(
                        onTap: () async {
                          if (Platform.isIOS) {
                            showCupertinoDialog(
                                context: context,
                                builder: (context) {
                                  return const CupertinoAlertDialog(
                                    content: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                });
                            Timer(const Duration(seconds: 4), () {
                              Navigator.pop(context);
                            });
                            if (state.model[index].fileType == "pdf") {
                              openPDF(state.model[index]);
                            } else {
                              openEpub(state.model[index]);
                            }
                          } else {
                            SavedBook? data = await DatabaseHelper()
                                .getBook(state.model[index].productId);
                            unlockDownloadedZip(
                              context,
                              data!.title,
                              data.productId,
                              data.brandId,
                              editionCode: data.editionCode,
                            );
                          }
                        },
                        child: CardBookBorrowedWidget(
                          title: state.model[index].title,
                          image: state.model[index].image,
                          name: state.model[index].company,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
        return SizedBox(
          width: size.width,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  left: 24,
                  right: 28.5,
                  bottom: 8,
                  top: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.savedBooks,
                          style: h4Title,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          Text(
                            AppLocalizations.of(context)!.seeAll,
                            style: h6Title.copyWith(color: Colors.grey),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: primaryColor,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
                width: 40,
                child: CircularProgressIndicator(),
              )
            ],
          ),
        );
      }, listener: (context, state) {
        if (state is GetFailedSaveDataCollection) {}
      });
    }

    Widget buildClientLogo() {
      final bool isStretch = FlavorConfig.instance.values.isLogoStretch!;
      return Container(
        margin: const EdgeInsets.only(left: 20, top: 0),
        padding: isStretch ? null : const EdgeInsets.only(top: 8),
        alignment: Alignment.centerLeft,
        width: size.width * 0.25,
        height: 64,
        decoration: isStretch
            ? BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    logoImage(
                      organization: ApiClient.instance.baseOrganizationId,
                    ),
                  ),
                  fit: BoxFit.cover,
                ),
              )
            : null,
        child: isStretch
            ? null
            : Image(
                image: AssetImage(
                  logoImage(
                    organization: ApiClient.instance.baseOrganizationId,
                  ),
                ),
                fit: BoxFit.cover,
              ),
      );
    }

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 72,
            snap: true,
            floating: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            flexibleSpace: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [buildClientLogo()],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [buildBorrowedBookList(), buildDownloadedBookList()],
            ),
          )
        ],
      ),
    );
  }
}
