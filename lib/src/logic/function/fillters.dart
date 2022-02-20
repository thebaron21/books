class Fillter {
  final String type;
  final String text;

  Fillter({this.type, this.text});
}

class FillterFunction {
  List<Fillter> fillters = [];

  setItem(Fillter item) {
    if (fillters.length == 0) {
      fillters.add(item);
    } else {
      int realIndex = -1;
      for (int i = 0; i < fillters.length; i++) {
        realIndex++;
        if (fillters[i].type != item.type) {
          fillters.add(item);
        } else {
          // repeatItem(item);
          print("G");
        }
      }
    }
  }

  deleteItem(int index) {
    fillters.removeAt(index);
  }

  getKey() {
    String key;
    fillters.forEach((element) {
      if (element.type == "key") {
        key = element.text;
      }
    });
    return key;
  }

  getCategory() {
    String category;
    fillters.forEach((element) {
      if (element.type == "category") {
        category = element.text;
      }
    });
    return category;
  }

  getType() {
    String type;
    fillters.forEach((element) {
      if (element.type == "type") {
        type = element.text;
      }
    });
    return type;
  }

  void repeatItem(Fillter item) {
    int index = -1;
    for (int i = 0; i < fillters.length; i++) {
      index++;
      if (item.type == fillters[i].type) {
        break;
      }
    }
    fillters[index] = item;
  }

  bool findItem(String s) {
    for (int i = 0; i < fillters.length; i++) {
      if (fillters[i].text == s) {
        return true;
      }
    }
    return false;
  }
}
