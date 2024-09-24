import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revamp_eperpus_mobile/Service/product_service.dart';
import 'package:revamp_eperpus_mobile/model/popular_product_item_response.dart';

part 'popular_book_state.dart';

class PopularBookCubit extends Cubit<PopularBookState> {
  PopularBookCubit() : super(PopularBookInitial());

  void getPopularBooks(int id) async {
    try {
      emit(PopularBookLoading());
      final List<PopularBookItem> popularBooks =
          await ProductService().getPopularBookResponse(id);
      emit(GetPopularBooksResponse(books: popularBooks));
    } catch (e) {
      emit(GetFailedPopularBooks(message: e.toString()));
    }
  }
}
