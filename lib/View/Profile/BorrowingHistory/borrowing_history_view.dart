import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/BorrowHistory/borrow_hirstory_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Review/book_rating_add_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/Review/book_rating_add_state.dart';
import 'package:revamp_eperpus_mobile/Helpers/app_theme_pref.dart';
import 'package:revamp_eperpus_mobile/Helpers/util_constant.dart';
import 'package:revamp_eperpus_mobile/Utils/style.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/Card/borrow_book_card.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/alert_dialog_native.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/button.dart';
import 'package:revamp_eperpus_mobile/View/SignIn/signin_view.dart';
import 'package:revamp_eperpus_mobile/model/Product/product_model.dart';

class BorrowingHistoryView extends StatefulWidget {
  static const routeName = 'borrowHistory';

  BorrowingHistoryView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BorrowingHistoryViewState();
  }
}

class BorrowingHistoryViewState extends State<BorrowingHistoryView> {
  DateTime dateTime = DateTime.now();
  final TextEditingController reviewController = TextEditingController();
  final TextEditingController searchHistoryController = TextEditingController();
  PagingController<int, HistoryBorrowProductModel>? borrowingHistoryController =
      PagingController(firstPageKey: 0);
  int isDark = lightAppTheme;

  @override
  void initState() {
    context.read<BorrowHistoryCubit>().initState();
    initDarkMode();
    borrowingHistoryController =
        context.read<BorrowHistoryCubit>().borrowingHistoryController;
    borrowingHistoryController!.addPageRequestListener((pageKey) {
      context.read<BorrowHistoryCubit>().getListHistory(dateTime);
    });
    // context.read<BorrowHistoryCubit>().getListHistory(dateTime);
    super.initState();
  }

  Future<void> initDarkMode() async {
    final int themeValue =
        await getAppTheme() == lightAppTheme ? darkAppTheme : lightAppTheme;
    setState(() {
      isDark = themeValue;
    });
  }

  Widget ratingStar({
    Color activeColor = Colors.grey,
    int index = 0,
    int rating = 0,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: () => context.read<BookRatingAddCubit>().setRating(index),
      child: Icon(
        Icons.star,
        color: activeColor,
        size: 18,
      ),
    );
  }

  Widget interactiveRatingStar(BookRatingAddState state) {
    int? rating = context.read<BookRatingAddCubit>().rating;
    List<Widget> widgets = [];
    for (int i = 0; i < 5; i++) {
      widgets.add(
        ratingStar(
          activeColor: i < rating && rating > 0 ? Colors.yellow : Colors.grey,
          index: i,
          rating: rating,
        ),
      );
    }
    return Row(children: widgets);
  }

  Future<void> showMyDialog({
    required HistoryBorrowProductModel item,
    required VoidCallback? onTapped,
    required AppLocalizations localization,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return BlocBuilder<BookRatingAddCubit, BookRatingAddState>(
          builder: (context, ratingState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          localization.rateThisBook,
                          style: paragraph4.copyWith(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF6E7178),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(item.coverImage!.href!),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                item.title!,
                                style: h5Title,
                                maxLines: 2,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "${localization.by} ${item.vendor!.title}",
                                style: paragraph4.copyWith(),
                                maxLines: 2,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        interactiveRatingStar(ratingState),
                        const SizedBox(width: 8),
                        Text(
                          context.read<BookRatingAddCubit>().ratingText,
                          style: subhead3.copyWith(fontSize: 12),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black38,
                            spreadRadius: 3,
                            offset: Offset(2, 2),
                          )
                        ],
                      ),
                      child: TextField(
                        controller: reviewController,
                        onChanged: (String text) {
                          context
                              .read<BookRatingAddCubit>()
                              .setReviewText(text);
                        },
                        style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        maxLength: 500,
                        decoration: InputDecoration(
                          hintText: localization.reviewDescription,
                          hintStyle:
                              paragraph4.apply(color: const Color(0xFF6E7178)),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 6,
                          ),
                          errorText:
                              context.read<BookRatingAddCubit>().errorText(
                                    localization.emptyTextField,
                                    localization.minimumText20,
                                  ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Button(
                      title: localization.post,
                      onTap:
                          reviewController.text.length < 20 ? null : onTapped,
                      radius: 8,
                      style: h5Title,
                      color: primaryColor,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget listBook(Size size, AppLocalizations localization) {
    return BlocConsumer<BorrowHistoryCubit, BorrowHistoryState>(
      builder: (context, state) {
        if (state is BorrowHistoryLoading) {
          SizedBox(
            width: size.width,
            height: 100,
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        if (state is GetListOfBorrowingHistories) {
          return PagedListView<int, HistoryBorrowProductModel>(
            shrinkWrap: false,
            pagingController: borrowingHistoryController!,
            builderDelegate:
                PagedChildBuilderDelegate<HistoryBorrowProductModel>(
              itemBuilder: (context, item, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: CardBorrowedBookHistory(
                    name: '${item.vendor!.title}',
                    title: "${item.title}",
                    dateBorrow: item.borrowingStartTIME!,
                    image: "${item.coverImage!.href}",
                    isReviewed: item.reviewStatus!,
                    onTaped: () {
                      context.read<BookRatingAddCubit>().setRatingTextList([
                        localization.terrible,
                        localization.bad,
                        localization.average,
                        localization.good,
                        localization.excellent,
                      ]);
                      context.read<BookRatingAddCubit>().setReviewText('');
                      showMyDialog(
                        item: item,
                        onTapped: () async {
                          Navigator.pop(context);
                          await context
                              .read<BookRatingAddCubit>()
                              .postBookRatingAdd(
                                context,
                                borrowingId: item.id!,
                                reviewText: reviewController.text,
                              );
                          reviewController.text = '';
                          resetContentList();
                        },
                        localization: localization,
                      );
                    },
                  ),
                );
              },
            ),
          );
        }
        if (state is GetListOfSearchHistories) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.searchHistories.length,
            itemBuilder: (context, index) {
              final item = state.searchHistories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: CardBorrowedBookHistory(
                  name: '${item.vendor!.title}',
                  title: "${item.title}",
                  dateBorrow: item.borrowingStartTIME!,
                  image: "${item.coverImage!.href}",
                  isReviewed: item.reviewStatus!,
                  onTaped: () {
                    context.read<BookRatingAddCubit>().setRatingTextList([
                      localization.terrible,
                      localization.bad,
                      localization.average,
                      localization.good,
                      localization.excellent,
                    ]);
                    context.read<BookRatingAddCubit>().setReviewText('');
                    showMyDialog(
                      item: item,
                      onTapped: () {
                        Navigator.pop(context);
                        context.read<BookRatingAddCubit>().postBookRatingAdd(
                              context,
                              borrowingId: item.id!,
                              reviewText: reviewController.text,
                            );
                        reviewController.text = '';
                        resetContentList();
                      },
                      localization: localization,
                    );
                  },
                ),
              );
            },
          );
        }
        return SizedBox(
          width: size.width,
          height: 100,
          child: const Center(child: CircularProgressIndicator()),
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
                  content: Text(AppLocalizations.of(context)!.unauthorizedText),
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
                  content: Text(AppLocalizations.of(context)!.unauthorizedText),
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
      },
    );
  }

  void resetContentList() {
    context.read<BorrowHistoryCubit>().resetPagination();
    borrowingHistoryController =
        context.read<BorrowHistoryCubit>().borrowingHistoryController;
    borrowingHistoryController!.addPageRequestListener((pageKey) {
      context.read<BorrowHistoryCubit>().getListHistory(dateTime);
    });
    context.read<BorrowHistoryCubit>().getListHistory(dateTime);
  }

  @override
  void dispose() {
    borrowingHistoryController;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final Size size = MediaQuery.of(context).size;
    final bool isDarkTheme = isDark == 1;
    return WillPopScope(
      onWillPop: () async {
        context.read<BorrowHistoryCubit>().resetPagination();
        borrowingHistoryController =
            context.read<BorrowHistoryCubit>().borrowingHistoryController;
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
            localization.borrowingHistory,
            style:
                h4Title.apply(color: isDarkTheme ? Colors.white : Colors.black),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            icon: const Icon(Icons.chevron_left),
            color: isDarkTheme ? Colors.white : Colors.black,
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(64.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchHistoryController,
                      onSubmitted: (String value) {
                        if (value == "") {
                          resetContentList();
                        } else {
                          context
                              .read<BorrowHistoryCubit>()
                              .searchHistory(value);
                        }
                      },
                      onChanged: (String? value) {},
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: IconButton(
                          onPressed: () {
                            searchHistoryController.clear();
                            resetContentList();
                          },
                          icon: const Icon(Icons.clear),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: lightBlue),
                        ),
                        labelText: localization.historySearchHint,
                        labelStyle: paragraph4.apply(color: lightBlue),
                        contentPadding: const EdgeInsets.symmetric(vertical: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            resetContentList();
          },
          child: listBook(size, localization),
        ),
      ),
    );
  }
}
