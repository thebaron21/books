import 'package:books/src/logic/models/book._model.dart';

class LibraryReponse {
  List<BookModel> books;
  String error;

  LibraryReponse.withJson(var json)
      : books = (json as List).map((e) => BookModel.withJson(e)).toList(),
        error = "";

  LibraryReponse.withError(e)
      : books = [],
        error = e.toString();
}
