import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/WatchList/watch_list_cubit.dart';
import 'package:revamp_eperpus_mobile/Service/product_service.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/Card/book_available_card.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/alert_dialog_native.dart';
import 'package:revamp_eperpus_mobile/View/Product/DetailProduct/detail_product_view.dart';
import 'package:revamp_eperpus_mobile/Helpers/alert_custom.dart';
import 'package:revamp_eperpus_mobile/model/Product/library_product_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/watch_item_model.dart';

import 'package:revamp_eperpus_mobile/Utils/style.dart';
import '../../CustomWidget/button.dart';

class WatchListView extends StatefulWidget {
  WatchListView({Key? key, this.isDark}) : super(key: key);
  int? isDark;
  @override
  State<WatchListView> createState() => _WatchListViewState();
}

class _WatchListViewState extends State<WatchListView> {
  Future<void> onSelectAvailableBook(String url) async {
    try {
      final LibraryProductModel? bookDetail =
          await ProductService().getBorrowedDetail(url);
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DetailProductView(
            id: bookDetail?.id,
            itemUrl: bookDetail?.href,
            detailUrl: bookDetail?.details!.href,
            bookTitle: bookDetail?.title,
            bookId: bookDetail?.id,
            coverImage: bookDetail?.coverImage,
            currentlyAvailable: bookDetail?.currentlyAvailable,
          ),
        ),
      );
      context.read<WatchListCubit>().getWatchList();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    print("Widget.isDark: ${widget.isDark}");

    context.read<WatchListCubit>().getWatchList();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    var size = MediaQuery.of(context).size;
    final bool isDark = widget.isDark == 1;

    Widget buildAvailableBook() {
      return BlocBuilder<WatchListCubit, WatchListState>(
          builder: (context, state) {
        if (state is GetWatchlistData) {
          final List<WatchItemModel> availableBook = state.model
              .where((element) => element.currentlyAvailable > 0)
              .toList();

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  left: 24,
                  right: 28.5,
                  bottom: 0,
                  top: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(localization.bookAvailable, style: h4Title),
                        const SizedBox(width: 4),
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.blue,
                          child: Text(
                            "${state.model.where((element) => element.currentlyAvailable > 0).toList().length}",
                            style: subhead2.copyWith(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height:size.height > 1100 ? size.height * 0.175 : size.height * 0.3 - 12,
                width: size.width,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final itemCount = availableBook.length;
                    WatchItemModel book = availableBook[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          width: size.width - 48,
                          child: CardBookAvailableWidget(
                            currentlyAvailable: book.currentlyAvailable,
                            title: book.title!,
                            image: book.coverImage.href!,
                            name: book.vendor.title!,
                            onTapContent: () async {
                              await onSelectAvailableBook(
                                book.href!,
                              );
                            },
                            onTapClose: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialogNative(
                                    title: Text(
                                      localization.areYouSure,
                                      style: h5Title,
                                    ),
                                    content: Text(
                                      localization.areYouSureDelete,
                                    ),
                                    action: [
                                      AlertButton(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!.close,
                                          style: h5Title,
                                        ),
                                      ),
                                      AlertButton(
                                        onTap: () {
                                          context
                                              .read<WatchListCubit>()
                                              .deleteWatch(
                                                state.model[index].delete!,
                                              );
                                          context
                                              .read<WatchListCubit>()
                                              .getWatchList();
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!.delete,
                                          style: h5Title.copyWith(
                                              color: Colors.red),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(width: index == itemCount - 1 ? 24 : 0),
                      ],
                    );
                  },
                  itemCount: availableBook.length,
                ),
              )
            ],
          );
        } else if (state is GetWatchlistEmpty) {
          print("emmit GetWatchlistEmpty");
          return Column(
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      Text(localization.bookAvailable, style: h4Title),
                      const CircleAvatar(child: Text("0"))
                    ],
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Text(
                          localization.deleteAll,
                          style: h7Title.copyWith(color: Colors.grey),
                        ),
                        const Icon(
                          Icons.delete,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        } else if (state is GetFailedWatchlist) {
          debugPrint(state.message);
        }
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
                      Text(localization.bookAvailable, style: h4Title),
                      const SizedBox(width: 4),
                      const CircleAvatar(radius: 10, child: Text("0"))
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 104),
              child: CircularProgressIndicator(),
            )
          ],
        );
      });
    }

    Widget buildListOutOfStock() {
      return BlocBuilder<WatchListCubit, WatchListState>(
          builder: (context, state) {
        if (state is GetWatchlistData) {
          debugPrint("GetWatchlistData");
          final List<WatchItemModel> watchItems = state.model
              .where((element) => element.currentlyAvailable >= 0)
              .toList();
          
              return Expanded(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        left: 24,
                        right: 28.5,
                        bottom: 0,
                        top: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(localization.onQueue, style: h4Title),
                              const SizedBox(width: 4),
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.blue,
                                child: Text(
                                  "${state.model.where((element) => element.currentlyAvailable == 0).toList().length}",
                                  style: subhead2.copyWith(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 0,
                        top: 0,
                      ),
                      child: SizedBox(
                        height: size.height > 1100 ? size.height * 0.6 : size.height * 0.5,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            WatchItemModel book = watchItems[index];
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CardBookAvailableWidget(
                                currentlyAvailable: book.currentlyAvailable,
                                title: book.title!,
                                image: book.coverImage.href!,
                                name: book.vendor.title!,
                                onTapContent: () {},
                                onTapClose: () {
                                  Platform.isIOS
                                      ? showCupertinoDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialogNative(
                                              title: Text(
                                                AppLocalizations.of(context)!
                                                    .areYouSure,
                                                style: h5Title,
                                              ),
                                              content: Text(
                                                AppLocalizations.of(context)!
                                                    .areYouSureDelete,
                                              ),
                                              action: [
                                                CupertinoDialogAction(
                                                  child: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .close,
                                                        style: h5Title,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                CupertinoDialogAction(
                                                  child: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .delete,
                                                    style: h5Title.copyWith(
                                                        color: Colors.red),
                                                  ),
                                                  onPressed: () {
                                                    context
                                                        .read<WatchListCubit>()
                                                        .deleteWatch(
                                                          state.model[index]
                                                              .delete!,
                                                        );
                                                    context
                                                        .read<WatchListCubit>()
                                                        .getWatchList();
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            );
                                          })
                                      : showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialogNative(
                                              title: Text(
                                                AppLocalizations.of(context)!
                                                    .areYouSure,
                                                style: h5Title,
                                              ),
                                              content: Text(
                                                AppLocalizations.of(context)!
                                                    .areYouSureDelete,
                                              ),
                                              action: [
                                                Button(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .close,
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  radius: 12,
                                                  style: h5Title.copyWith(
                                                    color: Colors.black,
                                                  ),
                                                  color: Colors.grey,
                                                ),
                                                Button(
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .delete,
                                                  onTap: () {
                                                    context
                                                        .read<WatchListCubit>()
                                                        .deleteWatch(
                                                          state.model[index]
                                                              .delete!,
                                                        );
                                                    context
                                                        .read<WatchListCubit>()
                                                        .getWatchList();
                                                    Navigator.pop(context);
                                                  },
                                                  radius: 12,
                                                  style: h5Title.copyWith(
                                                    color: Colors.white,
                                                  ),
                                                  color: Colors.red,
                                                )
                                              ],
                                            );
                                          },
                                        );
                                },
                              ),
                            );
                          },
                          itemCount: watchItems.length,
                        ),
                      ),
                    )
                  ],
                ),
              );
           
        } else if (state is GetWatchlistEmpty) {
          return Column(
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      Text(localization.onQueue),
                      const CircleAvatar(child: Text("0"))
                    ],
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Text(
                          localization.deleteAll,
                          style: h6Title.copyWith(color: Colors.grey),
                        ),
                        const Icon(
                          Icons.delete,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        } else if (state is GetFailedWatchlist) {}
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
                        localization.onQueue,
                        style: h4Title,
                      ),
                      const SizedBox(width: 4),
                      const CircleAvatar(radius: 12, child: Text("0"))
                    ],
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
        );
      });
    }

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
          AppLocalizations.of(context)!.waitingList,
          style: h4Title.apply(color: isDark ? Colors.white : Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left),
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      body: SizedBox(
        height: size.height,
        child: Column(
          children: [
            buildAvailableBook(),
            buildListOutOfStock(),
          ],
        ),
      ),
    );
  }
}
