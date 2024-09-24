import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Catalog/catalog_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Catalog/catalog_state.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Category/category_list_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Category/category_list_state.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Library/product_cubit.dart';
import 'package:revamp_eperpus_mobile/Helpers/alert_unauthorized.dart';
import 'package:revamp_eperpus_mobile/Utils/Style.dart';
import 'package:revamp_eperpus_mobile/Utils/config.dart';
import 'package:revamp_eperpus_mobile/Utils/utils.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/button.dart';
import 'package:revamp_eperpus_mobile/View/Product/Component/client_catalog_item.dart';
import 'package:revamp_eperpus_mobile/View/Product/SearchLibrary/SearchLibraryBookView.dart';
import 'package:revamp_eperpus_mobile/Helpers/api_client.dart';
import 'package:revamp_eperpus_mobile/Helpers/cache.dart';
import 'package:revamp_eperpus_mobile/Helpers/upgrader_message.dart';
import 'package:revamp_eperpus_mobile/model/CatalogesDataModel.dart';
import 'package:revamp_eperpus_mobile/model/Product/Category/GetCategoryMetaModel.dart';
import 'package:revamp_eperpus_mobile/model/Product/library_product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:upgrader/upgrader.dart';

class ClientCatalogLibraryView extends StatefulWidget {
  const ClientCatalogLibraryView({
    Key? key,
    required this.libraryController,
    this.onGetCatalogs,
    this.catalogTitle,
    this.isOpenedCategory,
    this.categoryTitle,
    this.onChangeCategory,
    this.onChangeSort,
    this.onReloadPressed,
    this.onForceLogout,
  }) : super(key: key);

  final PagingController<int, LibraryProductModel>? libraryController;
  final Function(List<CatalogData>)? onGetCatalogs;
  final String? catalogTitle;
  final String? categoryTitle;
  final Function(bool)? isOpenedCategory;
  final Function(String?, String?, String?)? onChangeCategory;
  final Function(bool?, String?, String, Map<String, dynamic>?)? onChangeSort;
  final Function()? onReloadPressed;
  final VoidCallback? onForceLogout;
  @override
  State<ClientCatalogLibraryView> createState() =>
      _ClientCatalogLibraryViewState();
}

class _ClientCatalogLibraryViewState extends State<ClientCatalogLibraryView> {
  SharedPreferences? sharedPreferences;
  int isDark = 0;
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  String? valueDrop;
  String? category;
  bool isFirstTimeCategory = true;
  String sortByText = "";
  bool isUnauthorizedAlertShown = false;

  @override
  void initState() {
    category = widget.categoryTitle == null || widget.categoryTitle!.isEmpty
        ? "All Categories"
        : widget.categoryTitle;
    context.read<CatalogCubit>().getCatalog(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool? isFirstTime = true;

  Future<void> initStateData() async {
    isFirstTime = await getShowCaseHome();
    sharedPreferences = await SharedPreferences.getInstance();
    final resSortBy = await getSortText();
    if (isFirstTime!) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context).startShowCase([_one, _two]);
      });
      await setShowCaseHome(false);
    }
    setState(() {
      sortByText = resSortBy;
    });
    isDark = sharedPreferences!.getInt('themeStatus') ?? 1;
  }

  Future<void> onSearchPressed() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchLibraryBookView(
          catalog: context.read<ProductCubit>().urlProduct,
          isDark: isDark,
          onForceLogout: () => widget.onForceLogout!(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    var size = MediaQuery.of(context).size;

    Widget buildCategoryButton(String urlProduct) {
      return BlocBuilder<CategoryListCubit, CategoryListState>(
        builder: (context, state) {
          if (state is CategorylistLoading) {
            print("Build Category Button");
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GetCategorylistSuccess) {
            var dataCategory = state.model.meta.facets[1].values;
            dataCategory.insert(
              0,
              ItemValueFacets(
                count: 0,
                value: "All Categories",
              ),
            );
            return SizedBox(
              height: size.height * 0.375,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: dataCategory.length,
                itemBuilder: (context, index) {
                  final data = dataCategory[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: GestureDetector(
                      onTap: () {
                        print("CATALOG VALUE: ${data.value}");
                        widget.onChangeCategory!(
                            "Category", urlProduct, data.value);
                        setState(() {
                          category = data.value;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        width: size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data.value,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            category == data.value
                                ? const Icon(Icons.done)
                                : const SizedBox()
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
    }

    Widget dropDownCatalog() {
      return BlocConsumer<CatalogCubit, CatalogState>(
        builder: (context, state) {
          if (state is CatalogLoading) {
            return const CircularProgressIndicator();
          } else if (state is GetCatalogSuccess) {
            if (state.catalogList!.length <= 1 ||
                FlavorConfig.instance.flavor == Flavor.blims) {
              return Container(
                padding: const EdgeInsets.only(left: 12, top: 12),
                child: Text(state.catalogList?.first.title ?? ""),
              );
            } else {
              final title = widget.catalogTitle!.isEmpty
                  ? state.catalogList!.first.title
                  : widget.catalogTitle!;
              return Container(
                width: size.width * 0.75,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE5E5E5), width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: DropdownButton(
                  isDense: true,
                  isExpanded: true,
                  underline: Container(),
                  value: valueDrop,
                  hint: Text(
                    title!,
                    overflow: TextOverflow.ellipsis,
                  ),
                  items: state.catalogList?.map((e) {
                    return DropdownMenuItem<String>(
                      value: e.id.toString(),
                      child: Text(e.title ?? ""),
                    );
                  }).toList(),
                  onChanged: (String? value) async {
                    widget.onGetCatalogs!(state.catalogList!);
                    //  widget.onChangeCatalog!(value);
                    // var catalogId = state.catalogList
                    //     ?.where((element) => element.title == value)
                    //     .first;
                    // print(catalogId?.id ?? 0);
                    // await sharedPreferences?.setInt(
                    //     "catalogId", catalogId?.id ?? 0);
                    widget.onChangeCategory!(
                        "Catalog", value, "All Categories");
                    setState(
                      () {
                        valueDrop = value;
                      },
                    );
                  },
                ),
              );
            }
          } else if (state is GetCatalogFailed) {
            return Container();
          }
          return Container();
        },
        listener: (context, state) {
          if (state is CatalogUserForceLogout ||
              state is CatalogUserUnauthorized) {
            if (!isUnauthorizedAlertShown) {
              widget.onForceLogout!();
              showUnauthorizedDialog(
                context,
                localization,
              );
              setState(() {
                isUnauthorizedAlertShown = true;
              });
            }
          }
        },
      );
    }

    Widget dropDownCategory() {
      return BlocConsumer<CatalogCubit, CatalogState>(
        builder: (context, state) {
          if (state is CatalogLoading) {
            return const CircularProgressIndicator();
          } else if (state is GetCatalogSuccess) {
            return InkWell(
              onTap: () {
                widget.isOpenedCategory!(true);
                var urlProduct = context.read<ProductCubit>().urlProduct;
                context.read<CategoryListCubit>().getCategoryList(urlProduct);
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return SizedBox(
                      height: size.height * 0.5,
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  widget.isOpenedCategory!(false);
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                              ),
                              const Spacer(flex: 2),
                              Center(
                                child: Text(
                                  localization.category,
                                  style: h3Title,
                                ),
                              ),
                              const Spacer(flex: 3)
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                            ),
                            child: buildCategoryButton(urlProduct),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFE5E5E5),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Image(
                  image: AssetImage("assets/icon_assets/ic_union.png"),
                ),
              ),
            );
          } else if (state is GetCatalogFailed) {
            return Container();
          }
          return Container();
        },
        listener: (context, state) {
          if (state is CatalogUserForceLogout ||
              state is CatalogUserUnauthorized) {
            widget.onForceLogout!();
            showUnauthorizedDialog(
              context,
              localization,
            );
            setState(() {
              isUnauthorizedAlertShown = true;
            });
          }
        },
      );
    }

    Widget bottomSheetText({
      VoidCallback? onTap,
      String? text,
      bool showSelectedIcon = false,
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 8,
            ),
            width: size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Row(
              children: [
                Text(
                  "$text",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Visibility(
                  visible: showSelectedIcon,
                  child: const Icon(Icons.done),
                ),
              ],
            ),
          ),
        ),
      );
    }

    void buildSortBottomSheet() {
      List<Widget> listOfOptionWidget = [];
      List<Map<String, dynamic>> listOfOption = listOfSorting(context);
      for (var element in listOfOption) {
        listOfOptionWidget.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: bottomSheetText(
              onTap: () {
                widget.onChangeSort!(
                  element["value"],
                  "",
                  element["sortLabel"],
                  element,
                );
              },
              text: element["sortDetail"],
            ),
          ),
        );
      }
      showModalBottomSheet(
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return SizedBox(
            height: size.height * 0.5,
            child: Column(
              children: [
                const SizedBox(height: 24),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                    ),
                    const Spacer(flex: 2),
                    Center(
                      child: Text(
                        AppLocalizations.of(context)!.filterDate,
                        style: h3Title,
                      ),
                    ),
                    const Spacer(flex: 3)
                  ],
                ),
                ...listOfOptionWidget,
              ],
            ),
          );
        },
      );
    }

    Widget buildLibraryBooks() {
      return BlocConsumer<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
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
          if (state is GetListDataProduct) {
            final test = state.libraryController;
            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              sliver: PagedSliverGrid<int, LibraryProductModel>(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 160,
                  mainAxisExtent: 270,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 12,
                ),
                pagingController: widget.libraryController!,
                builderDelegate: PagedChildBuilderDelegate<LibraryProductModel>(
                  itemBuilder: (context, item, index) {
                    if (index == 0) {
                      return Showcase(
                        targetBorderRadius: BorderRadius.circular(10),
                        targetPadding: const EdgeInsets.all(12),
                        key: _two,
                        title: localization.book,
                        description: localization.pressForBookDetail,
                        tooltipBackgroundColor: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        targetShapeBorder: const CircleBorder(),
                        child: ClientCatalogItem(
                          data: item,
                          isDark: isDark,
                        ),
                      );
                    }
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
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(localization.noConnection),
                      const SizedBox(height: 4),
                      Text(localization.noConnectionMessage),
                      const SizedBox(height: 4),
                      Button(
                        title: localization.reload,
                        onTap: () {
                          category = widget.categoryTitle == null ||
                                  widget.categoryTitle!.isEmpty
                              ? "All Categories"
                              : widget.categoryTitle;
                          context.read<CatalogCubit>().getCatalog(context);
                          widget.onReloadPressed!();
                        },
                        radius: 12,
                        style: h6Title,
                        color: primaryColor,
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          return SliverToBoxAdapter(
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: const Center(
                child: Text("Error"),
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is UserForceLogout) {
            if (!isUnauthorizedAlertShown) {
              widget.onForceLogout!();

              showUnauthorizedDialog(
                context,
                localization,
              );
              setState(() {
                isUnauthorizedAlertShown = true;
              });
            }
          }
        },
      );
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

    Widget buildCatalogHeader() {
      return SliverAppBar(
        collapsedHeight: 190,
        toolbarHeight: 172,
        automaticallyImplyLeading: false,
        snap: true,
        floating: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        flexibleSpace: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildClientLogo(),
                BlocBuilder<CatalogCubit, CatalogState>(
                  builder: (context, state) {
                    if (state is CatalogLoading) {
                      return Container(
                        margin: const EdgeInsets.only(right: 12),
                        child: const CircularProgressIndicator(),
                      );
                    } else if (state is GetCatalogSuccess) {
                      return Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 4),
                            child: Showcase(
                              targetPadding: const EdgeInsets.all(5),
                              key: _one,
                              title: localization.searchButton,
                              description: localization.pressForSearch,
                              tooltipBackgroundColor:
                                  Theme.of(context).primaryColor,
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
                      );
                    }
                    return Container();
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [dropDownCatalog(), dropDownCategory()],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<ProductCubit, ProductState>(
                    builder: (context, state) {
                      if (state is ProductLoading) {
                        return Container();
                      }
                      if (state is GetListDataProduct) {
                        final sortLabel = listOfSorting(context)
                            .where((element) =>
                                element["value"] == state.sortLabel!["value"])
                            .first;
                        return InkWell(
                          onTap: () {
                            buildSortBottomSheet();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFE5E5E5),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(100)),
                            child: Row(
                              children: [
                                const Icon(Icons.filter_list_rounded),
                                const SizedBox(width: 8),
                                Text(
                                  sortLabel["sortLabel"],
                                  style: paragraph3,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    }

    return UpgradeAlert(
      upgrader: Upgrader(
        showIgnore: false,
        durationUntilAlertAgain: const Duration(days: 3),
        messages: MyUpgraderMessages(code: localization.upgradeCode),
        dialogStyle: Platform.isIOS
            ? UpgradeDialogStyle.cupertino
            : UpgradeDialogStyle.material,
        debugLogging: true,
        willDisplayUpgrade: ({
          String? appStoreVersion,
          required bool display,
          String? installedVersion,
          String? minAppVersion,
        }) {
          if (isFirstTime! && !display) {
            initStateData();
          }
        },
        onLater: () {
          setState(() {
            isFirstTime = true;
          });
          return false;
        },
        onUpdate: () {
          setState(() {
            isFirstTime = true;
          });
          return true;
        },
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [buildCatalogHeader(), buildLibraryBooks()],
        ),
      ),
    );
  }
}
