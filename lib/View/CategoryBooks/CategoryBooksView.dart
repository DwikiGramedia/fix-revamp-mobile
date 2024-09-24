import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Category/category_list_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Category/category_list_state.dart';
import 'package:revamp_eperpus_mobile/Helpers/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/Style.dart';
import '../../model/Product/library_product_model.dart';
import '../CustomWidget/button.dart';
import '../Product/Component/client_catalog_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryBooksView extends StatefulWidget {
  String category;
  CategoryBooksView({required this.category});

  @override
  State<CategoryBooksView> createState() => _CategoryBooksViewState();
}

class _CategoryBooksViewState extends State<CategoryBooksView> {
  int isDark = 0;
  SharedPreferences? sharedPreferences;
  PagingController<int, LibraryProductModel>? categoryController =
      PagingController(firstPageKey: 0);

  Future<void> initStateData() async {
    context.read<CategoryListCubit>().initState();
    sharedPreferences = await SharedPreferences.getInstance();

    isDark = sharedPreferences!.getInt('themeStatus')!;
  }

  @override
  void initState() {
    // TODO: implement initState
    categoryController = context.read<CategoryListCubit>().categoryController;
    categoryController!.addPageRequestListener((pageKey) {
      context.read<CategoryListCubit>().getProductCategoryList(
            category: widget.category,
          );
    });
    initStateData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final localization = AppLocalizations.of(context)!;
    Widget buildLibraryBooks() {
      return BlocBuilder<CategoryListCubit, CategoryListState>(
        builder: (context, state) {
          if (state is CategorylistLoading) {
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
          if (state is GetCategoryBooklistSuccess) {
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
          } else if (state is GetCategorylistFailed) {
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
          // context.read<CategoryListCubit>().getCategoryList(
          //       ApiClient.instance.baseOrganizationId,
          //       ApiClient.instance.baseCatalogId,
          //     );
          context.read<CategoryListCubit>().resetCategory();
          Navigator.pop(context);
          return true;
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(widget.category),
              snap: true,
              floating: true,
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  // context.read<CategoryListCubit>().getCategoryList(
                  //       ApiClient.instance.baseOrganizationId,
                  //       ApiClient.instance.baseCatalogId,
                  //     );
                  context.read<CategoryListCubit>().resetCategory();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.chevron_left),
              ),
            ),
            buildLibraryBooks()
          ],
        ),
      ),
    );
  }
}
