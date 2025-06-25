import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingCubit extends Cubit<int> {
  OnboardingCubit() : super(0);

  void setCurrentIndex(int index) {
    emit(index);
  }

  void nextPage(PageController controller) {
    controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool shouldShowControls() {
    return state == 1 || state == 2; // Show only on pages 1 and 2
  }

  void skip(PageController controller) {
    controller.jumpToPage(2); // Skips to the last page (third page in this case)
  }
}