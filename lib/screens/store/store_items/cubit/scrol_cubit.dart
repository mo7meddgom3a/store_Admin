import 'package:bloc/bloc.dart';

part 'scrol_state.dart';

class ImageScrollCubit extends Cubit<double> {
  ImageScrollCubit() : super(0);

  void scroll(ScrollDirection direction, double maxScrollExtent) {
    double newPosition = state;
    if (direction == ScrollDirection.left) {
      newPosition = (newPosition - 78).clamp(0, maxScrollExtent);
    } else if (direction == ScrollDirection.right) {
      newPosition = (newPosition + 78).clamp(0, maxScrollExtent);
    }
    emit(newPosition);
  }
}