import 'package:get/get.dart';

class ProductDetailsController extends GetxController {
  var selectedColor = Rxn<String>();
  var selectedSize = Rxn<String>();
  var availableSizes = <String>[].obs;

  void setColor(String? color, List<String> sizes) {
    selectedColor.value = color;
    availableSizes.value = sizes;
    if (color == null) {
      selectedSize.value = null;
    }
  }

  void setSize(String? size) {
    selectedSize.value = size;
  }
}
