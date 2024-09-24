// Generated, built and configurated privately for Gramedia Asri Media projects
// Any use of this content without permission will be a legal violation
// ============================================================================
// @author Samuel O R Napitupulu
// @email samuel.napitupulu@gramedia.id
// @create date 2022-03-27 02:55:42
// @modify date 2022-03-30 02:38:27
// @desc [description]
// ============================================================================
// Copyrigthed Gramedia Asri Media 2022-03-27 02:55:42

// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Collection/collection_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Library/product_cubit.dart';
import 'package:revamp_eperpus_mobile/Service/MessagingService.dart';
import 'package:revamp_eperpus_mobile/Utils/config.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/back_to_exit_popup.dart';
import 'package:revamp_eperpus_mobile/View/Product/ClientCatalogLibrary/client_catalog_library_view.dart';
import 'package:revamp_eperpus_mobile/View/Product/ClientInternalCatalogLibrary/client_catalog_library_internal_view.dart';
import 'package:revamp_eperpus_mobile/View/Product/DeviceCollection/device_collection_view.dart';
import 'package:revamp_eperpus_mobile/View/Profile/profile_view.dart';
import 'package:revamp_eperpus_mobile/Helpers/cache.dart';
import 'package:revamp_eperpus_mobile/model/CatalogesDataModel.dart';
import 'package:revamp_eperpus_mobile/model/Product/library_product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This is the stateful widget that the main application instantiates.
class HomePage extends StatefulWidget {
  static const routeName = '/homepage';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const platform =
      MethodChannel('com.apps-foundry.eperpuswl.id.eperpus/navToReader');

  int _selectedIndex = 0;
  double appBarHeight = 75.0;
  String catalogTitle = '';
  String category = "";
  bool isOpenedCategoryBottom = false;
  List<int> bookInBytes = [];

  bool isFirstTime = true;
  DateTime onBackPressedTime = DateTime.now();

  PagingController<int, LibraryProductModel>? libraryController =
      PagingController(firstPageKey: 0);

  PagingController<int, LibraryProductModel>? collectionController =
      PagingController(firstPageKey: 0);

  void initCubitState() {
    print("INIT HOME RELOAD");
    onMessageOpenApp();
    context.read<ProductCubit>().updateFirebaseMessagingKey;
    context.read<ProductCubit>().initState();
    catalogTitle = context.read<ProductCubit>().catalogTitle;
    category = context.read<ProductCubit>().categoryTitle;
    libraryController = context.read<ProductCubit>().libraryController;
    libraryController!.addPageRequestListener(
      (pageKey) {
        context
            .read<ProductCubit>()
            .getProductList(context, categories: category);
      },
    );
    if (FlavorConfig.instance.flavor == Flavor.blims) {
      context.read<CollectionCubit>().initState();
      collectionController =
          context.read<CollectionCubit>().collectionController;
      collectionController!.addPageRequestListener(
        (pageKey) {
          context
              .read<CollectionCubit>()
              .getCollectionList(context, catalogId: 15);
        },
      );
    }
  }

  Future<void> reloadContent() async {
    context.read<ProductCubit>().resetPagination();
    libraryController!.removePageRequestListener((pageKey) {
      context
          .read<ProductCubit>()
          .getProductList(context, categories: category);
    });
    await context
        .read<ProductCubit>()
        .resetProductListByCategory(context, "", category);
    // initCubitState();
  }

  @override
  void initState() {
    if (isFirstTime) {
      initCubitState();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> onMessageOpenApp() async {
    await MessagingService().openMessage(context);
  }

  List<CatalogData> catalogList = [];
  Future<void> getCatalog(List<CatalogData> catalogs) async {
    setState(() {
      catalogList = catalogs;
    });
  }

  Future<void> getCategories(
      String selectedCataloghref, String? category) async {
    await context.read<ProductCubit>().onLoading();
    await context
        .read<ProductCubit>()
        .resetProductListByCategory(context, selectedCataloghref, category!);
  }

  void onChangeCategory(String? value, String? href, String? category) async {
    await debugLog("Mencoba testing catalog $href");
    if (value == "Catalog") {
      await context.read<ProductCubit>().onLoading();
      final String selectedCatalog = catalogList
          .where((element) => element.id == int.parse(href!))
          .first
          .title!;

      final String selectedCataloghref = catalogList
          .where((element) => element.id == int.parse(href!))
          .first
          .href!;
      List<String> seperateOrganizationId = selectedCataloghref.split("/");
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await debugLog("Mencoba testing catalog ${int.parse(href!)}");
      sharedPreferences.setInt("catalogId", int.parse(href));

      await context.read<ProductCubit>().resetProductList(context,
          selectedCataloghref, selectedCatalog, seperateOrganizationId[7]);
      context.read<ProductCubit>().categoryTitle = "";
    } else {
      await context.read<ProductCubit>().onLoading();
      await context
          .read<ProductCubit>()
          .resetProductListByCategory(context, href!, category!);
    }
  }

  void isOpenCategory(bool isOpened) {
    setState(() {
      isOpenedCategoryBottom = isOpened;
    });
  }

  Future<void> onChangeSort(
    bool? isAscending,
    String? category,
    String sortingValue,
    Map<String, dynamic>? sortLabelValue,
  ) async {
    await setSortText(sortingValue);
    Navigator.pop(context);
    await context.read<ProductCubit>().onLoading();
    await context
        .read<ProductCubit>()
        .sortCatalogByDate(context, isAscending, sortLabelValue);
    context.read<ProductCubit>().isAscending = isAscending;
  }

  List<Widget> _widgetOptions() {
    List<Widget> listOfWidgets = <Widget>[];

    if (FlavorConfig.instance.flavor == Flavor.blims) {
      listOfWidgets = <Widget>[
        ClientCatalogLibraryView(
          libraryController: libraryController,
          onGetCatalogs: getCatalog,
          catalogTitle: catalogTitle,
          categoryTitle: category,
          onChangeCategory: onChangeCategory,
          isOpenedCategory: isOpenCategory,
          onChangeSort: onChangeSort,
          onReloadPressed: reloadContent,
          onForceLogout: () => onForcedLogout(),
        ),
        ClientCatalogLibraryInternalView(
          collectionController: collectionController,
          onForceLogout: () => onForcedLogout(),
        ),
        DeviceCollectionView(
          onForceLogout: () => onForcedLogout(),
        ),
        // SearchProductPage(),
        ProfileView(
          onForceLogout: () => onForcedLogout(),
        )
      ];
    } else {
      listOfWidgets = <Widget>[
        ClientCatalogLibraryView(
          libraryController: libraryController,
          onGetCatalogs: getCatalog,
          catalogTitle: catalogTitle,
          categoryTitle: category,
          onChangeCategory: onChangeCategory,
          isOpenedCategory: isOpenCategory,
          onChangeSort: onChangeSort,
          onReloadPressed: reloadContent,
          onForceLogout: () => onForcedLogout(),
        ),
        DeviceCollectionView(
          onForceLogout: () => onForcedLogout(),
        ),
        // SearchProductPage(),
        ProfileView(
          onForceLogout: () => onForcedLogout(),
        )
      ];
    }

    return listOfWidgets;
  }

  void getTotalAnalytics() async {
    try {
      var value =
          await platform.invokeMethod<int>("totalAnalytic", {"Test": "Test"});
      var valueCount = value ?? 0;
      var pref = await SharedPreferences.getInstance();
      pref.setInt("countAnalytic", valueCount);
    } on PlatformException catch (e) {
      await debugLog(e.toString());
    }
  }

  void onForcedLogout() async {
    print("onForcedLogout");
    context.read<CollectionCubit>().resetCollection();
    context
        .read<ProductCubit>()
        .resetProductWithoutURLProduct(context, "", "", "");
  }

  void _onItemTapped(int index) async {
    setState(() {
      switch (index) {
        case 0:
          context.read<CollectionCubit>().resetCollection();
          libraryController = context.read<ProductCubit>().libraryController;

          libraryController!.addPageRequestListener((pageKey) {
            context
                .read<ProductCubit>()
                .getProductList(context, categories: category);
          });
          break;
        case 1:
          if (FlavorConfig.instance.flavor == Flavor.blims) {
            context.read<CollectionCubit>().resetCollection();
            collectionController =
                context.read<CollectionCubit>().collectionController;
            collectionController!.addPageRequestListener((pageKey) {
              context
                  .read<CollectionCubit>()
                  .getCollectionList(context, catalogId: 15);
              context
                  .read<ProductCubit>()
                  .resetProductWithoutURLProduct(context, "", "", "");
            });
          } else {
            context.read<CollectionCubit>().resetCollection();
            context
                .read<ProductCubit>()
                .resetProductWithoutURLProduct(context, "", "", "");
            break;
          }
          break;
        default:
          context.read<CollectionCubit>().resetCollection();
          context
              .read<ProductCubit>()
              .resetProductWithoutURLProduct(context, "", "", "");
          break;
      }

      _selectedIndex = index;
    });
  }

  List<BottomNavigationBarItem> _bottomNavigationItems() {
    List<BottomNavigationBarItem> navBarItems = <BottomNavigationBarItem>[];

    if (FlavorConfig.instance.flavor == Flavor.blims) {
      navBarItems = <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined),
          label: AppLocalizations.of(context)!.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.auto_stories_outlined),
          label: AppLocalizations.of(context)!.catalog,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.smartphone_outlined),
          label: AppLocalizations.of(context)!.device,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.account_circle_outlined),
          label: AppLocalizations.of(context)!.account,
        ),
      ];
    } else {
      navBarItems = <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined),
          label: AppLocalizations.of(context)!.home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.smartphone_outlined),
          label: AppLocalizations.of(context)!.device,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.account_circle_outlined),
          label: AppLocalizations.of(context)!.account,
        ),
      ];
    }

    return navBarItems;
  }

  bool isAllowExit = false;
  void setAllowExit(bool value) {
    setState(() {
      isAllowExit = value;
    });
    Future.delayed(const Duration(seconds: 5), () {
      print('Function executed after 5 seconds');
      setState(() {
        isAllowExit = false;
      });
    });
  }

  Future<bool> onBackButtonPressed() async {
    final difference = DateTime.now().difference(onBackPressedTime);
    if (difference >= const Duration(seconds: 5) || !isAllowExit) {
      setAllowExit(true);
      onBackPressedTime = DateTime.now();
      backToExitSnack(context, AppLocalizations.of(context)!.pressedToBack);
      return false;
    } else {
      onBackPressedTime = onBackPressedTime.add(const Duration(seconds: 5));
      setAllowExit(false);
      if (Platform.isIOS) {
        exit(0);
      } else {
        SystemNavigator.pop(animated: true);
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    onBackPressedTime = DateTime.now();
    return WillPopScope(
      onWillPop: () => onBackButtonPressed(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          foregroundColor: Theme.of(context).textSelectionTheme.selectionColor,
          backgroundColor: Platform.isIOS
              ? Theme.of(context).scaffoldBackgroundColor
              : Colors.transparent,
          toolbarHeight: 0,
          elevation: 0,
        ),
        resizeToAvoidBottomInset: true,
        body: _selectedIndex == 0
            ? _widgetOptions().elementAt(_selectedIndex)
            : SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: _widgetOptions().elementAt(_selectedIndex),
                ),
              ),
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 25.0,
          items: _bottomNavigationItems(),
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
