import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Collection/collection_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Library/product_cubit.dart';
import 'package:revamp_eperpus_mobile/Helpers/api_client.dart';
import 'package:revamp_eperpus_mobile/Utils/Style.dart';
import 'package:revamp_eperpus_mobile/Utils/utils.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/alert_dialog_native.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/button.dart';
import 'package:revamp_eperpus_mobile/View/Product/Component/client_catalog_item.dart';
import 'package:revamp_eperpus_mobile/View/Product/SearchLibrary/SearchLibraryBookView.dart';
import 'package:revamp_eperpus_mobile/View/SignIn/signin_view.dart';
import 'package:revamp_eperpus_mobile/model/Product/library_product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

class ClientCatalogLibraryInternalView extends StatefulWidget {
  const ClientCatalogLibraryInternalView({
    Key? key,
    required this.collectionController,
    this.onForceLogout,
  }) : super(key: key);

  final PagingController<int, LibraryProductModel>? collectionController;
  final VoidCallback? onForceLogout;
  @override
  State<ClientCatalogLibraryInternalView> createState() =>
      _ClientCatalogLibraryInternalViewState();
}

class _ClientCatalogLibraryInternalViewState
    extends State<ClientCatalogLibraryInternalView> {
  // final GlobalKey _bookKey = GlobalKey();
  // final GlobalKey _notificationKey = GlobalKey();
  final GlobalKey _one = GlobalKey();

  SharedPreferences? sharedPreferences;
  int isDark = 0;
  @override
  void initState() {
    // TODO: implement initState
    initStateData();
    super.initState();
  }

  bool? isFirstTime = true;
  Future<void> initStateData() async {
    //context.read<CollectionCubit>().initState();
    sharedPreferences = await SharedPreferences.getInstance();
    // if (isFirstTime!) {
    //   // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   //   ShowCaseWidget.of(context).startShowCase([_bookKey, _notificationKey]);
    //   //   super.initState();
    //   // });
    //   await setShowCaseCollection(false);
    // }
    isDark = sharedPreferences!.getInt('themeStatus')!;
  }

  Widget buildClientCatalogGrid({
    required List<LibraryProductModel> model,
    required int isDark,
    required PagingController<int, LibraryProductModel> pagingController,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 10,
          childAspectRatio: 1.0,
          mainAxisExtent: 350,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return ClientCatalogItem(
              data: model[index],
              isDark: isDark,
            );
          },
          childCount: model.length,
        ),
      ),
    );
  }

  Future<void> onSearchPressed() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return SearchLibraryBookView(
            catalog:
                "https://scoopadm.apps-foundry.com/scoopcor/api/v1/organizations/1100769/shared-catalogs/15",
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //context.read<CollectionCubit>().initState();
    var size = MediaQuery.of(context).size;

    Widget buildCollectionBooks() {
      return BlocConsumer<CollectionCubit, CollectionState>(
        builder: (context, state) {
          if (state is CollectionLoading) {
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
          if (state is GetListDataProductCollection) {
            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              sliver: PagedSliverGrid<int, LibraryProductModel>(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 160,
                  mainAxisExtent: 270,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 12,
                ),
                pagingController: widget.collectionController!,
                builderDelegate: PagedChildBuilderDelegate<LibraryProductModel>(
                  itemBuilder: (context, item, index) {
                    return ClientCatalogItem(
                      data: item,
                      isDark: isDark,
                    );
                  },
                ),
              ),
            );
          } else if (state is GetListDataFailed) {
            return SliverToBoxAdapter(
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: const Center(child: Text("Error")),
              ),
            );
          }
          return SliverToBoxAdapter(
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: const Center(child: Text("Server Time Out")),
            ),
          );
        },
        listener: (context, state) {
          if (state is CollectionUserForceLogout) {
            if (Platform.isIOS) {
              showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialogNative(
                        title: Text("Force Logout"),
                        content: Text(
                            "Login session is over, please re-login again"),
                        action: [
                          CupertinoDialogAction(
                            child: Text(AppLocalizations.of(context)!.close),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context!,
                                SignInUIForm.routeName,
                              );
                            },
                          )
                        ]);
                  });
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialogNative(
                        title: Text("Force Logout"),
                        content: Text(
                            "Login session is over, please re-login again"),
                        action: [
                          Button(
                            title: AppLocalizations.of(context)!.close,
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context!,
                                SignInUIForm.routeName,
                              );
                            },
                            radius: 12,
                            color: Colors.green,
                            style: h6Title,
                          )
                        ]);
                  });
            }
          }
        },
      );
    }

    final localization = AppLocalizations.of(context)!;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 80,
            automaticallyImplyLeading: false,
            snap: true,
            floating: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            flexibleSpace: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 12),
                  child: SizedBox(
                    width: size.width * 0.3,
                    height: size.height * 0.05,
                    child: Image.asset(
                      logoImage(
                        organization: ApiClient.instance.baseOrganizationId,
                      ),
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 4, top: 8),
                      child: Showcase(
                        targetPadding: const EdgeInsets.all(5),
                        key: _one,
                        title: localization.searchButton,
                        description: localization.pressForSearch,
                        tooltipBackgroundColor: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        targetShapeBorder: const CircleBorder(),
                        child: IconButton(
                          iconSize: 30,
                          onPressed: () {
                            onSearchPressed();
                          },
                          icon: const Icon(Icons.search_rounded),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          buildCollectionBooks()
        ],
      ),
    );
  }
}
