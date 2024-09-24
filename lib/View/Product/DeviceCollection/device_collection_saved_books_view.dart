import 'dart:io';

import 'package:flutter/material.dart';
import 'package:revamp_eperpus_mobile/Helpers/cache.dart';
import 'package:revamp_eperpus_mobile/Service/database_helper.dart';
import 'package:revamp_eperpus_mobile/Service/product_service.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/Card/book_borrowed_card.dart';
import 'package:revamp_eperpus_mobile/View/Product/DetailProduct/detail_product_view.dart';
import 'package:revamp_eperpus_mobile/model/Product/library_product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceCollectionSavedBooksView extends StatefulWidget {
  const DeviceCollectionSavedBooksView(
      {Key? key,
      required this.books,
      required this.appBarTitle,
      required this.isDark})
      : super(key: key);
  final List<SavedBook> books;
  final String appBarTitle;
  final int isDark;

  @override
  State<DeviceCollectionSavedBooksView> createState() =>
      _DeviceCollectionSavedBooksViewState();
}

class _DeviceCollectionSavedBooksViewState
    extends State<DeviceCollectionSavedBooksView> {
  List<SavedBook> borrowedBook = [];

  int isDark = 1;
  Future<void> getColorTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isDark = sharedPreferences.getInt('themeStatus')!;
  }

  Future<void> getBorrowedBook() async {
    DatabaseHelper helper = DatabaseHelper();
    List<SavedBook> books = await helper.getBooks();
    setState(() {
      borrowedBook = books;
    });
  }

  Future<void> onSelectBorrowedBook(String url) async {
    try {
      final LibraryProductModel? bookDetail =
          await ProductService().getBorrowedDetail(url);
      dynamic res = await Navigator.of(context).push(
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
      await getBorrowedBook();
    } catch (e) {
      await debugLog(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      borrowedBook = widget.books;
    });
    getColorTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    for (var book in widget.books) {
      widgets.add(
        CardBookBorrowedWidget(
          title: book.title,
          image: book.image,
          name: book.title,
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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.chevron_left,
            color: widget.isDark == 1 ? Colors.black : Colors.white,
          ),
        ),
        title: Text(
          widget.appBarTitle,
          style: TextStyle(
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
            return OrientationBuilder(
              builder: (_, orientation) {
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
              },
            );
          }
        },
      ),
    );
  }
}
