import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/DeviceCollection/device_collection_cubit.dart';
import 'package:revamp_eperpus_mobile/Cubit/Product/DeviceCollection/saved_collection_cubit.dart';
import 'package:revamp_eperpus_mobile/Helpers/cache.dart';
import 'package:revamp_eperpus_mobile/Service/product_service.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/Card/book_borrowed_card.dart';
import 'package:revamp_eperpus_mobile/View/Product/DetailProduct/detail_product_view.dart';
import 'package:revamp_eperpus_mobile/model/Product/borrowed_item_model.dart';
import 'package:revamp_eperpus_mobile/model/Product/library_product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceCollectionAllView extends StatefulWidget {
  const DeviceCollectionAllView({
    Key? key,
    required this.books,
    required this.appBarTitle,
    required this.isDark,
  }) : super(key: key);
  final List<BorrowedBookModel> books;
  final String appBarTitle;
  final int isDark;

  @override
  State<DeviceCollectionAllView> createState() =>
      _DeviceCollectionAllViewState();
}

class _DeviceCollectionAllViewState extends State<DeviceCollectionAllView> {
  List<BorrowedBookModel> borrowedBook = [];
  @override
  void initState() {
    print("Init State Device Collection");
    setState(() {
      borrowedBook = widget.books;
    });
    getColorTheme();
    super.initState();
  }

  int isDark = 1;
  Future<void> getColorTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isDark = sharedPreferences.getInt('themeStatus')!;
  }

  Future<void> getBorrowedBook() async {
    List<BorrowedBookModel> res = await ProductService().getBorrowList();
    setState(() {
      borrowedBook = res;
    });
  }

  Future<void> onSelectBorrowedBook(String url) async {
    try {
      await debugLog(url);
      final LibraryProductModel? bookDetail =
          await ProductService().getBorrowedDetail(url);
      final res = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DetailProductView(
            id: bookDetail?.id,
            itemUrl: bookDetail?.href,
            detailUrl: bookDetail?.details!.href,
            bookTitle: bookDetail?.title,
            bookId: bookDetail?.id,
            coverImage: bookDetail?.coverImage,
          ),
        ),
      );
      debugPrint(res);
      await getBorrowedBook();
      context.read<DeviceCollectionCubit>().getDeviceCollection();
      context.read<SavedCollectionCubit>().getDataSaved();
    } catch (e) {
      await debugLog("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    for (var book in borrowedBook) {
      widgets.add(
        GestureDetector(
          onTap: () {
            onSelectBorrowedBook(book.bookItem.href ?? "");
          },
          child: CardBookBorrowedWidget(
            title: book.title,
            image: book.coverImage.href ?? "",
            name: book.vendor.title ?? "",
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Platform.isIOS
            ? Theme.of(context).primaryColor
            : const Color(0xFF091A33),
        backgroundColor: Platform.isIOS
            ? Theme.of(context).scaffoldBackgroundColor
            : Colors.transparent,
        elevation: 0,
        title: Text(
          widget.appBarTitle,
          style: TextStyle(
            color: widget.isDark == 1 ? Colors.black : Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.chevron_left,
            color: widget.isDark == 1 ? Colors.black : Colors.white,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraint) {
          if (constraint.maxWidth < 600) {
            return GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              childAspectRatio: 2 / 3.2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: widgets,
            );
          } else {
            return OrientationBuilder(builder: (_, orientation) {
              if (orientation == Orientation.portrait) {
                return GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  childAspectRatio: 1 / 1.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 4,
                  children: widgets,
                );
              } else {
                return GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  childAspectRatio: 1 / 1.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 6,
                  children: widgets,
                );
              }
            });
          }
        },
      ),
    );
  }
}
