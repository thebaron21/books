import 'package:books/src/logic/firebase/categories_bloc.dart';

class ItemsSearch {
  final List<String> categories = [];
  final List<String> types = [];
  CategoriesFirebase bloc = CategoriesFirebase();

  ItemsSearch() {
    init();
  }
  init() async {
    var data = await bloc.fetchCategories();
    data.docs.forEach((element) {
      String item = (element.data() as Map)["name"];
      categories.add(item);
    });
    print(categories);
  }
}
