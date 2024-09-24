import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Catalog/catalog_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Catalog/catalog_state.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/SearchBook/search_book_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:revamp_eperpus_mobile/Utils/Style.dart';
import 'package:revamp_eperpus_mobile/model/CatalogesDataModel.dart';
import 'package:revamp_eperpus_mobile/model/Product/library_product_model.dart';
import '../Component/client_catalog_item.dart';

class SearchCatalogBookSelectionView extends StatefulWidget {
  CatalogData catalog;
  SearchCatalogBookSelectionView({required this.catalog});

  @override
  State<SearchCatalogBookSelectionView> createState() =>
      _SearchCatalogBookSelectionViewState();
}

class _SearchCatalogBookSelectionViewState
    extends State<SearchCatalogBookSelectionView> {
  TextEditingController? searchTextController = TextEditingController();
  FocusNode? searchTextFocus = FocusNode();
  int isDark = 0;
  PagingController<int, LibraryProductModel>? categoryController =
      PagingController(firstPageKey: 0);
  List<String> searchingHistoryList = [];
  List<String> searchingList = [
    "Biographies & Memoirs",
    "Business & Investing",
  ];

  Future<void> initStateData() async {
    context.read<CatalogCubit>().initState();
    var sharedPreferences = await SharedPreferences.getInstance();

    isDark = sharedPreferences.getInt('themeStatus')!;
  }

  @override
  void initState() {
    // TODO: implement initState
    initStateData();
    categoryController = context.read<CatalogCubit>().categoryController;
    categoryController!.addPageRequestListener((pageKey) {
      context.read<CatalogCubit>().getProductCategoryList(
            context: context,
            href: widget.catalog.href ?? "",
            query: '',
          );
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    categoryController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget listBook() {
      return BlocBuilder<CatalogCubit, CatalogState>(builder: (context, state) {
        if (state is CatalogLoading) {
          return SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(30),
              child: const SpinKitFoldingCube(
                size: 32,
                color: Colors.blue,
              ),
            ),
          );
        } else if (state is GetCatalogListSuccess) {
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
            child: Container(
              width: size.width,
              margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 10),
              child: Image.asset('assets/images/emptyresult.png'),
            ),
          );
        } else if (state is CatalogBookFocus) {
          searchingHistoryList.addAll(state.historyList != null
              ? state.historyList!.reversed.toList()
              : []);
          return SliverToBoxAdapter(
            child: GestureDetector(
              onPanDown: (_) => searchTextFocus?.unfocus(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.topSearch,
                      style: h4Title,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: <Widget>[
                        for (String title in searchingList)
                          InkWell(
                            onTap: () async {
                              setState(
                                () {
                                  searchTextController?.text = title;
                                  searchTextFocus?.unfocus();
                                  context.read<SearchBookCubit>().changeState(
                                        state: SearchBookFocus(
                                          historyList: [title],
                                        ),
                                      );
                                },
                              );
                              context
                                  .read<SearchBookCubit>()
                                  .getProductList(queryString: title);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(width: 1, color: lightBlue),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                title,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      AppLocalizations.of(context)!.historySearch,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: size.width,
                    height: size.height * 0.5,
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: searchingHistoryList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            searchTextController?.text =
                                searchingHistoryList[index];
                            searchTextFocus?.unfocus();
                            context.read<SearchBookCubit>().getProductList(
                                queryString: searchingHistoryList[index]);
                            context.read<SearchBookCubit>().addHistoryList();
                          },
                          child: Column(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Row(
                                  children: [
                                    Image.asset(
                                        'assets/icon_assets/ic_clock.png'),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        searchingHistoryList[index],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
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
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(
                          color: Colors.transparent,
                          height: 0,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SliverToBoxAdapter(child: Text("????"));
      });
    }

    Widget searchBar() {
      bool showCloseButton = false;
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                autofocus: true,
                controller: searchTextController,
                onSubmitted: (String? value) {
                  categoryController = PagingController(firstPageKey: 0);
                  categoryController =
                      context.read<CatalogCubit>().categoryController;
                  context.read<CatalogCubit>().initState();
                  categoryController!.addPageRequestListener((pageKey) {
                    context.read<CatalogCubit>().getProductCategoryList(
                          context: context,
                          href: widget.catalog.href ?? "",
                          query: value ?? "",
                        );
                  });
                },
                onChanged: (String? value) {
                  if (value!.length >= 3) {
                    context.read<CatalogCubit>().resetCategory();
                  } else {
                    context.read<CatalogCubit>().getHistoryList();
                  }
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

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            pinned: true,
            expandedHeight: 40,
            centerTitle: true,
            leading: IconButton(
                onPressed: () {
                  context.read<CatalogCubit>().resetCategory();
                  context.read<CatalogCubit>().getProductCategoryList(
                        context: context,
                        href: widget.catalog.href ?? "",
                        query: '',
                      );
                  Navigator.pop(context);
                },
                icon: Icon(Icons.chevron_left)),
            title: Text(
              AppLocalizations.of(context)!.searchBook,
              style: h4Title,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: searchBar(),
            ),
          ),
          listBook()
        ],
      ),
    );
  }
}
