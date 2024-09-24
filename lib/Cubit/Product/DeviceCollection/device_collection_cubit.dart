import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:revamp_eperpus_mobile/Service/product_service.dart';
import 'package:revamp_eperpus_mobile/model/Product/borrowed_item_model.dart';

import 'package:revamp_eperpus_mobile/Service/database_helper.dart';
import 'package:revamp_eperpus_mobile/model/file_product.dart';

part 'device_collection_state.dart';

class DeviceCollectionCubit extends Cubit<DeviceCollectionState> {
  DeviceCollectionCubit() : super(DeviceCollectionInitial());
  List<BorrowedBookModel> model = [];

  void getDeviceCollection() async {
    try {
      emit(DeviceCollectionLoading());
      model = await ProductService().getBorrowList();
      model.forEach((element) {
        DateTime date = DateTime.parse(element.expires);
        print("DATE TIME BOOK Borrow= ${date}");
      });
      emit(GetDataCollectionResponse(model: model));
    } catch (e) {
      if (e.toString() == "Force logout") {
        print("Exception: $e");
        emit(UserForceLogout());
      } else if (e == "401" || e == 401) {
        emit(GetBorrowedUnauthorized());
      } else {
        print("model.isEmpty");
        emit(GetFailedDataCollection(message: e.toString()));
      }
    }
  }

  void returnBook(String title, int id) async {
    try {
      emit(DeviceCollectionLoading());

      FileProduct message = await ProductService().isBorrowed(title);
      await DatabaseHelper().deleteBook(message.id ?? 0);
      String? returnBook =
          await ProductService().returnBorrowed(message.borrowedId ?? id);
      if (returnBook == "Success mengembalikan  buku") {
        emit(DeviceReturnSuccess());
      } else {
        //emit(DownloadedBook(borrowedId: message.borrowedId ?? 0));
      }
    } catch (e) {
      emit(GetFailedDataCollection(message: e.toString()));
    }
  }
}
