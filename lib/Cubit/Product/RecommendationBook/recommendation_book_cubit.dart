import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revamp_eperpus_mobile/Service/product_service.dart';
import 'package:revamp_eperpus_mobile/Helpers/cache.dart';
import 'package:revamp_eperpus_mobile/model/Product/library_product_model.dart';
import 'package:revamp_eperpus_mobile/model/ProductKey.dart';
import 'package:revamp_eperpus_mobile/model/recommended_product_response.dart';

part 'recommendation_book_state.dart';

class RecommendationBookCubit extends Cubit<RecommendationBookState> {
  RecommendationBookCubit() : super(RecommendationBookInitial());
  String format = "";
  void getRecommendationBooks(int id) async {
    try {
      emit(RecommendationBookLoading());
      List<RecomendationItem> books =
          await ProductService().getRecommendationsBook(id);
      ProductKey value = await ProductService().getKey(id);
      format = value.fileExtension;
      emit(GetRecommendationBooksResponse(books: books));
    } catch (e) {
      emit(GetFailedRecommendationBooks(message: e.toString()));
    }
  }

  LibraryProductModel? bookDetail;
  void getRecommendationDetail(int id) async {
    try {
      await debugLog('getRecommendationDetail');
      bookDetail = await ProductService().getRecommendationsDetail(id);
    } catch (e) {
      emit(GetFailedRecommendationBooks(message: e.toString()));
    }
  }
}
