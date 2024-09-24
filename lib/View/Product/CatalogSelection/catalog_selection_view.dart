import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Catalog/catalog_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Catalog/catalog_state.dart';
import 'package:revamp_eperpus_mobile/View/Category/CategoryListNewView.dart';
import 'package:revamp_eperpus_mobile/View/Product/SearchLibrary/SearchCatalogBookSelectionView.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:revamp_eperpus_mobile/Utils/Style.dart';
import 'package:revamp_eperpus_mobile/model/CatalogesDataModel.dart';
import 'package:revamp_eperpus_mobile/model/Product/library_product_model.dart';
import '../../CustomWidget/button.dart';
import '../Component/client_catalog_item.dart';

class CatalogSelectionView extends StatefulWidget {
  static const String routeName = "catalog_selection_view";
  CatalogData catalog;
  CatalogSelectionView({required this.catalog});

  @override
  State<CatalogSelectionView> createState() => _CatalogSelectionViewState();
}

class _CatalogSelectionViewState extends State<CatalogSelectionView> {
  PagingController<int, LibraryProductModel>? categoryController =
      PagingController(firstPageKey: 0);
  SharedPreferences? sharedPreferences;
  int isDark = 0;
  Future<void> initStateData() async {
    context.read<CatalogCubit>().initState();
    sharedPreferences = await SharedPreferences.getInstance();

    isDark = sharedPreferences!.getInt('themeStatus')!;
  }

  @override
  void initState() {
    // TODO: implement initState
    initStateData();
    categoryController = context.read<CatalogCubit>().categoryController;
    categoryController!.addPageRequestListener((pageKey) {
      context
          .read<CatalogCubit>()
          .getProductCategoryList(context: context, href: widget.catalog.href ?? "", query: '');
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //categoryController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final localization = AppLocalizations.of(context)!;

    Widget buildLibraryBooks() {
      return BlocBuilder<CatalogCubit, CatalogState>(
        builder: (context, state) {
          if (state is CatalogLoading) {
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
          if (state is GetCatalogListSuccess) {
            categoryController = state.categoryController;
            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              sliver: PagedSliverGrid<int, LibraryProductModel>(
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
              ),
            );
          } else if (state is GetCatalogFailed) {
            return SliverToBoxAdapter(
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(localization.failedToLoad),
                      Button(
                        title: localization.reload,
                        onTap: () => initStateData(),
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
      );
    }

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          context.read<CatalogCubit>().getCatalog(context);
          context.read<CatalogCubit>().resetCategory();
          Navigator.pop(context);
          return true;
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(widget.catalog.title ?? ""),
              snap: true,
              floating: true,
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  context.read<CatalogCubit>().getCatalog(context);
                  context.read<CatalogCubit>().resetCategory();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.chevron_left),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CategoryListNewView(catalog: widget.catalog)),
                      );
                    },
                    icon: Icon(Icons.list)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SearchCatalogBookSelectionView(
                                    catalog: widget.catalog)),
                      );
                    },
                    icon: Icon(Icons.search_rounded))
              ],
            ),
            buildLibraryBooks()
          ],
        ),
      ),
    );
  }
}
