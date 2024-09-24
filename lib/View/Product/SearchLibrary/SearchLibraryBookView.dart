import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Catalog/catalog_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Catalog/catalog_state.dart';
import 'package:revamp_eperpus_mobile/Helpers/alert_unauthorized.dart';
import 'package:revamp_eperpus_mobile/Service/user_service.dart';
import 'package:revamp_eperpus_mobile/Utils/Style.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/alert_dialog_native.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/button.dart';
import 'package:revamp_eperpus_mobile/View/Product/Component/client_catalog_item.dart';
import 'package:revamp_eperpus_mobile/View/SignIn/signin_view.dart';
import 'package:revamp_eperpus_mobile/model/Product/library_product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchLibraryBookView extends StatefulWidget {
  final String catalog;
  int? isDark;
  final VoidCallback? onForceLogout;

  SearchLibraryBookView({
    Key? key,
    required this.catalog,
    this.isDark,
    this.onForceLogout,
  }) : super(key: key);
  @override
  State<SearchLibraryBookView> createState() => _SearchLibraryBookViewState();
}

class _SearchLibraryBookViewState extends State<SearchLibraryBookView> {
  TextEditingController? searchTextController = TextEditingController();
  FocusNode? searchTextFocus = FocusNode();
  int isDark = 0;
  PagingController<int, LibraryProductModel>? categoryController =
      PagingController(firstPageKey: 0);
  List<String> searchingHistoryList = [];
  bool isUnauthorizedAlertShown = false;

  Future<void> initStateData() async {
    context.read<CatalogCubit>().getHistoryList();
    var sharedPreferences = await SharedPreferences.getInstance();
    isDark = sharedPreferences.getInt('themeStatus')!;
  }

  @override
  void initState() {
    // TODO: implement initState
    initStateData();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> onSearchSubmit(String? value) async {
    context.read<CatalogCubit>().resetCategory();
    String text = value ?? '';
    categoryController = PagingController(firstPageKey: 0);
    categoryController = context.read<CatalogCubit>().categoryController;
    context.read<CatalogCubit>().initState();
    if (text.isNotEmpty) {
      context.read<CatalogCubit>().setSearchedHistory(text);
    }
    categoryController!.addPageRequestListener((pageKey) {
      context.read<CatalogCubit>().getProductCategoryList(
            context: context,
            href: widget.catalog,
            query: text,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final bool isDarkTheme = widget.isDark == 0;
    Widget buildListOfBook() {
      return BlocBuilder<CatalogCubit, CatalogState>(builder: (context, state) {
        if (state is CatalogLoading) {
          return Container(
            margin: const EdgeInsets.all(30),
            child: const SpinKitFoldingCube(
              size: 32,
              color: Colors.blue,
            ),
          );
        } else if (state is GetCatalogListSuccess) {
          return PagedGridView<int, LibraryProductModel>(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 160,
              mainAxisExtent: 270,
              crossAxisSpacing: 16,
              mainAxisSpacing: 20,
            ),
            pagingController: categoryController!,
            builderDelegate: PagedChildBuilderDelegate<LibraryProductModel>(
              itemBuilder: (context, item, index) {
                return ClientCatalogItem(
                  data: item,
                  isDark: isDark,
                );
              },
            ),
          );
        } else if (state is GetCatalogFailed) {
          return Container(
            width: size.width,
            margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 10),
            child: Image.asset('assets/images/emptyresult.png'),
          );
        } else if (state is CatalogBookFocus) {
          searchingHistoryList = state.historyList != null
              ? state.historyList!.reversed.toList()
              : [];
          List<Widget> widgets = [];
          for (var element in searchingHistoryList) {
            widgets.add(GestureDetector(
              onTap: () async {
                searchTextFocus!.unfocus();
                searchTextController!.text = element;
                await onSearchSubmit(element);
              },
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Image.asset('assets/icon_assets/ic_clock.png'),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            element,
                            style: Theme.of(context).textTheme.bodyLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: lightGray,
                    thickness: 1,
                    height: 20,
                    indent: 52,
                    endIndent: 24,
                  ),
                ],
              ),
            ));
          }
          return ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      AppLocalizations.of(context)!.historySearch,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...widgets,
                ],
              ),
            ),
          );
        }
        return const SizedBox();
      });
    }

    Widget buildSearchBar() {
      bool showCloseButton = false;
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: searchTextController,
                onSubmitted: (String? value) async {
                  await onSearchSubmit(value);
                },
                onTap: () {
                  context.read<CatalogCubit>().getHistoryList();
                },
                focusNode: searchTextFocus,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: lightBlue),
                  ),
                  labelText: AppLocalizations.of(context)!.categoryGroupSearch,
                  labelStyle: paragraph4.apply(color: lightBlue),
                  contentPadding: const EdgeInsets.symmetric(vertical: 2),
                ),
              ),
            ),
            Visibility(
              visible: showCloseButton,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: paragraph4.apply(color: lightBlue),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        foregroundColor: Platform.isIOS
            ? Theme.of(context).cardColor
            : const Color(0xFF091A33),
        backgroundColor: Platform.isIOS
            ? Theme.of(context).scaffoldBackgroundColor
            : Colors.transparent,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.searchBook,
          style: h3Title.apply(
            color: isDarkTheme ? Colors.white : Colors.black,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            context.read<CatalogCubit>().resetCategory();
            context.read<CatalogCubit>().getCatalog(context);
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left),
          color: isDarkTheme ? Colors.white : Colors.black,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(64.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: buildSearchBar(),
          ),
        ),
      ),
      body: BlocConsumer<CatalogCubit, CatalogState>(
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              context.read<CatalogCubit>().resetCategory();
              context.read<CatalogCubit>().getCatalog(context);
              Navigator.pop(context);
              return false;
            },
            child: buildListOfBook(),
          );
        },
        listener: (context, state) {
          if (state is GetCatalogForceLogout ||
              state is GetCatalogUnauthorized) {
            if (!isUnauthorizedAlertShown) {
              if (Platform.isIOS) {
                showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialogNative(
                      title: Text(localization.unauthorized),
                      content: Text(localization.unauthorizedText),
                      action: [
                        CupertinoDialogAction(
                          child: Text(AppLocalizations.of(context)!.close),
                          onPressed: () async {
                            await UserService().logout();
                            print("context: $context");
                            print("localization: $localization");
                            Navigator.pop(context);
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              SignInUIForm.routeName,
                              (route) => false,
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
                      title: Text(localization.forceLogout),
                      content: Text(localization.unauthorizedText),
                      action: [
                        Button(
                          title: AppLocalizations.of(context)!.close,
                          onTap: () async {
                            await UserService().logout();
                            print("context: $context");
                            print("localization: $localization");
                            Navigator.pop(context);
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              SignInUIForm.routeName,
                              (route) => false,
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
              setState(() {
                isUnauthorizedAlertShown = true;
              });
            }
          }
        },
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
