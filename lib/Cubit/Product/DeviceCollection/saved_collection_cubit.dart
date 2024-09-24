import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:revamp_eperpus_mobile/Service/database_helper.dart';
import 'package:revamp_eperpus_mobile/Service/product_service.dart';
import 'package:revamp_eperpus_mobile/model/Product/borrowed_item_model.dart';
part 'saved_collection_state.dart';

class SavedCollectionCubit extends Cubit<SavedCollectionState> {
  SavedCollectionCubit() : super(SavedCollectionInitial());
  List<BorrowedBookModel>? borrowedBooks;

  Future<void> deleteReturnedBook({
    required int? productId,
    required List<BorrowedBookModel> listOfBook,
  }) async {
    if (!listOfBook.map((book) => book.details.id).contains(productId)) {
      await DatabaseHelper().deleteBook(productId!);
    }
  }

  bool isDateBeforeToday(DateTime date) {
    DateTime today = DateTime.now();
    return date.isBefore(DateTime(today.year, today.month, today.day));
  }

  void getDataSaved() async {
    List<SavedBook> savedBook = [];
    try {
      emit(SavedCollectionLoading());
      final borrowedBook = await ProductService().getBorrowList();
      final List<SavedBook> localBook = await DatabaseHelper().getBooks();
      localBook.forEach((element) async {
        bool isBookExist = borrowedBook.any((book) => book.title == element.title);
        if(isBookExist){
          savedBook.add(element);
        }
        DateTime date = DateTime.parse(element.expires!);
        if (isDateBeforeToday(date)) {
          await DatabaseHelper().deleteBook(element.productId);
        }
      });
      if (savedBook.isEmpty) {
        emit(GetEmptyDataSavedCollection(message: "Empty Saved book"));
      } else {
        emit(GetDataSavedCollection(model: savedBook));
      }
    } catch (e) {
      final List<SavedBook> localBook = await DatabaseHelper().getBooks();
      localBook.forEach((element) async {
        DateTime date = DateTime.parse(element.expires!);
        print("DATE TIME BOOK = ${isDateBeforeToday(date)}");
        if (isDateBeforeToday(date)) {
          await DatabaseHelper().deleteBook(element.productId);
        }
      });
      emit(GetDataSavedCollection(model: localBook));
    }
  }
}
