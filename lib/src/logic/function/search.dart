class SearchFunction {
  List<String> searchText(String text) {
    List<String> obj = [];
    List string = text.split("");
    List outTime = [];
    for (int i = 0; i < string.length; i++) {
      for (int o = 0; o <= i; o++) {
        outTime.add(string[o]);
      }
      obj.add(this._text(outTime));
      outTime.clear();
    }
    return obj;
  }

  String _text(List strings) {
    String finalText = "";
    for (String i in strings) {
      finalText = finalText + i;
    }
    return finalText;
  }
}
