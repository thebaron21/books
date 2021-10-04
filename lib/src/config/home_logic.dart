import 'dart:async';

enum HOMENAV { HOME, EDIT , MYBOOK }

class ControllerBookApp {
  StreamController<HOMENAV> _controllerBookApp = StreamController<HOMENAV>.broadcast();
  Stream<HOMENAV> get getControllerBookApp => _controllerBookApp.stream;
  StreamSink<HOMENAV> get setControllerBookApp => _controllerBookApp.sink;

  ControllerBookApp() {
    _controllerBookApp.add(HOMENAV.HOME);
  }
  void close() {
    _controllerBookApp.close();
    setControllerBookApp.close();
  }
}
