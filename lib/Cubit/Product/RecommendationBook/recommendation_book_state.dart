part of "recommendation_book_cubit.dart";

abstract class RecommendationBookState extends Equatable{

  @override
  List<Object?> get props => [];
}

class RecommendationBookInitial extends RecommendationBookState {}
class RecommendationBookLoading extends RecommendationBookState {}
class GetRecommendationBooksResponse extends RecommendationBookState {
  final List<RecomendationItem> books;
  GetRecommendationBooksResponse({required this.books});
  @override
  // TODO: implement props
  List<Object?> get props => [books];
}
class GetFailedRecommendationBooks extends RecommendationBookState{
  final String message;
  GetFailedRecommendationBooks({required this.message});
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}