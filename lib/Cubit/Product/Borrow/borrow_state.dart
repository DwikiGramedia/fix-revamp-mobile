part of 'borrow_cubit.dart';

abstract class BorrowState extends Equatable {
  const BorrowState();
  @override
  List<Object> get props => [];
}

class BorrowInitial extends BorrowState {}

class BorrowLoading extends BorrowState {}

class DownloadLoading extends BorrowState {
  final int receive;
  final int total;
  const DownloadLoading({required this.total, required this.receive});
  @override
  List<Object> get props => [receive, total];
}

class DownloadLoadingStream extends BorrowState {
  final Stream<dynamic> valueDynamic;
  const DownloadLoadingStream({required this.valueDynamic});

  @override
  List<Object> get props => [valueDynamic];
}

class GetWatchResponse extends BorrowState {
  final String message;
  const GetWatchResponse({required this.message});
  @override
  List<Object> get props => [message];
}

class DownloadFinished extends BorrowState {}

class GetBorrowResponse extends BorrowState {
  final BorrowedResponseModel borrowedRes;
  const GetBorrowResponse({required this.borrowedRes});
  @override
  List<Object> get props => [borrowedRes];
}

class GetDownloadResponse extends BorrowState {
  final String message;
  const GetDownloadResponse({required this.message});
  @override
  List<Object> get props => [message];
}

class GetFailedBorrowResponse extends BorrowState {
  final String message;
  const GetFailedBorrowResponse({required this.message});
  @override
  List<Object> get props => [message];
}

class DownloadedBook extends BorrowState {
  final int borrowedId;
  const DownloadedBook({required this.borrowedId});
  @override
  List<Object> get props => [borrowedId];
}

class ReturnSuccess extends BorrowState {}

class isBookBorrowed extends BorrowState {
  final FileProduct message;
  const isBookBorrowed({required this.message});
}

class IsBorrowedBookFailedResponse extends BorrowState {
  final String message;
  const IsBorrowedBookFailedResponse({required this.message});
}

class GetFailedDownloadResponse extends BorrowState {
  final String message;
  const GetFailedDownloadResponse({required this.message});
  @override
  List<Object> get props => [message];
}
