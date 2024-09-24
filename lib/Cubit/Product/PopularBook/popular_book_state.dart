part of "popular_book_cubit.dart";

abstract class PopularBookState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PopularBookInitial extends PopularBookState {}

class PopularBookLoading extends PopularBookState {}

class GetPopularBooksResponse extends PopularBookState {
  final List<PopularBookItem> books;
  GetPopularBooksResponse({required this.books});
  @override
  // TODO: implement props
  List<Object?> get props => [books];
}

class GetFailedPopularBooks extends PopularBookState {
  final String message;
  GetFailedPopularBooks({required this.message});
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
