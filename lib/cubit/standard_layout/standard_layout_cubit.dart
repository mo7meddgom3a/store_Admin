import 'package:flutter_bloc/flutter_bloc.dart';

part 'standard_layout_state.dart';

class StandardLayoutCubit extends Cubit<StandardLayoutState> {
  StandardLayoutCubit() : super(DashboardLayout());

  void changeLayout(int index) {
    print("switch called $index");
    switch (index) {
      case 0:
        emit(DashboardLayout());
      case 1:
        emit(StoreLayout());
      case 2:
        emit(Orders());
      case 3:
        emit(Categories());
    }
    ;
  }
}
