import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:revamp_eperpus_mobile/Service/product_service.dart';
import 'package:revamp_eperpus_mobile/Helpers/cache.dart';
import 'package:revamp_eperpus_mobile/model/Product/watch_item_model.dart';

part 'watch_list_state.dart';

class WatchListCubit extends Cubit<WatchListState> {
  WatchListCubit() : super(WatchListInitial());

  void getWatchList() async {
    try {
      emit(WatchListLoading());
      List<WatchItemModel> model = await ProductService().getWatchItemList();
      await debugLog(model.toString());
      emit(GetWatchlistData(model: model));
    } catch (e) {
      emit(GetFailedWatchlist(message: e.toString()));
    }
  }

  void deleteWatch(String link) async {
    try {
      emit(WatchListLoading());
      String delete = await ProductService().deleteWatch(link);
      List<WatchItemModel> model = await ProductService().getWatchItemList();
      emit(GetWatchlistData(model: model));
    } catch (e) {
      emit(GetFailedWatchlist(message: e.toString()));
    }
  }
}
