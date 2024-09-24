import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'borrow_list_state.dart';

class BorrowListCubit extends Cubit<BorrowListState> {
  BorrowListCubit() : super(BorrowListInitial());
}
