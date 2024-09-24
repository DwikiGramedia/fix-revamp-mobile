import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/SearchBook/search_book_cubit.dart';

import 'package:revamp_eperpus_mobile/Utils/style.dart';
import 'package:revamp_eperpus_mobile/model/Product/library_product_model.dart';
import '../DetailProduct/detail_product_view.dart';

class SearchBookView extends StatefulWidget {
  static const routeName = 'searchBook';
  const SearchBookView({Key? key}) : super(key: key);

  @override
  State<SearchBookView> createState() => _SearchBookViewState();
}

class _SearchBookViewState extends State<SearchBookView> {
  TextEditingController? searchTextController = TextEditingController();
  FocusNode? searchTextFocus = FocusNode();

  @override
  void initState() {
    context.read<SearchBookCubit>().addHistoryList(item: "books");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> searchingHistoryList = [];

    List<String> searchingList = [
      "Biographies & Memoirs",
      "Business & Investing",
    ];

    var size = MediaQuery.of(context).size;
    Widget listBook() {
      return BlocBuilder<SearchBookCubit, SearchBookState>(
          builder: (context, state) {
        if (state is SearchBookLoading) {
          return SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(30),
              child: const SpinKitFoldingCube(
                size: 32,
                color: Colors.blue,
              ),
            ),
          );
        } else if (state is GetSearchBookList) {
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0,
                childAspectRatio: 2.0,
                mainAxisExtent: 260,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  LibraryProductModel item = state.model[index];
                  return SizedBox(
                    height: size.height,
                    width: size.width,
                    child: GestureDetector(
                      onTap: () {
                        searchTextFocus?.unfocus();
                        context.read<SearchBookCubit>().addHistoryList(
                              item: searchTextController?.text,
                            );
                      },
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DetailProductView(
                                id: item.id,
                                itemUrl: item.href,
                                detailUrl: item.details!.href,
                                bookTitle: item.title,
                                bookId: item.id,
                                coverImage: item.coverImage,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Banner(
                                  layoutDirection: TextDirection.ltr,
                                  message: "New",
                                  color: Colors.blue,
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10,
                                  ),
                                  location: BannerLocation.topEnd,
                                  child: CachedNetworkImage(
                                    height: 197,
                                    width: 153,
                                    fit: BoxFit.cover,
                                    imageUrl: item.coverImage!.href!,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.error,
                                      size: 30,
                                    ),
                                  )
                                  // Image.network(
                                  //   widget.productData.coverImageHref,
                                  //   height: itemHeight * 0.8,
                                  //   fit: BoxFit.cover,
                                  // ),
                                  ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 5),
                              child: Text(
                                item.title!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Text(
                              item.subtitle!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: lightBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: state.model.length,
              ),
            ),
          );
        } else if (state is SearchBookEmpty) {
          return SliverToBoxAdapter(
            child: Container(
              width: size.width,
              margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 10),
              child: Image.asset('assets/images/emptyresult.png'),
            ),
          );
        } else if (state is SearchBookFocus) {
          searchingHistoryList.addAll(state.historyList);
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
                                    Image.asset('assets/icon_assets/ic_clock.png'),
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
                onChanged: (String? value) {
                  if (value!.length >= 3) {
                    context
                        .read<SearchBookCubit>()
                        .getProductList(queryString: value);
                  } else {
                    context.read<SearchBookCubit>().addHistoryList();
                  }
                },
                onTap: () {
                  context.read<SearchBookCubit>().addHistoryList();
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            pinned: true,
            expandedHeight: 40,
            centerTitle: true,
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
