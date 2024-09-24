part of 'watch_list_cubit.dart';

abstract class WatchListState extends Equatable {
  const WatchListState();
  @override
  List<Object> get props => [];
}

class WatchListInitial extends WatchListState{}
class WatchListLoading extends WatchListState{}
class GetWatchlistEmpty extends WatchListState{
  String message;
  GetWatchlistEmpty({required this.message});
  @override
  // TODO: implement props
  List<Object> get props => [message];
}
class GetWatchlistData extends WatchListState{
  final List<WatchItemModel> model;
  const GetWatchlistData({required this.model});
  @override
  // TODO: implement props
  List<Object> get props => [model];
}
class GetFailedWatchlist extends WatchListState{
  String message;
  GetFailedWatchlist({required this.message});
}
