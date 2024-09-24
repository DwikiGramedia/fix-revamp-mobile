import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:revamp_eperpus_mobile/Service/product_service.dart';
import 'package:revamp_eperpus_mobile/model/Product/detail_product_model.dart';

part 'detail_product_state.dart';

class DetailProductCubit extends Cubit<DetailProductState> {
  DetailProductCubit() : super(DetailProductInitial());
  void getItemInfo(String url) async {
    try {
      emit(DetailProductLoading());
      ItemInfoModel itemInfo = await ProductService().detailItem(url);

      emit(GetDetailProductResponse(detailProduct: itemInfo));
    } catch (e) {
      emit(GetFailedDetailProductReponse(message: e.toString()));
    }
  }

  void getDetailRetry(String url) async {
    try {
      Future.delayed(Duration(seconds: 2)).then((value) async {
        ItemInfoModel model = await ProductService().detailItem(url);
        emit(GetDetailProductResponse(detailProduct: model));
      });
    } catch (e) {
      if (e.toString() == "Force logout") {
        emit(UserForceLogout());
      }
      emit(GetFailedDetailProductReponse(message: e.toString()));
    }
  }
}
