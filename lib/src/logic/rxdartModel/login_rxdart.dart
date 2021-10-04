import 'package:books/src/logic/firebase/authentication.dart';
import 'package:rxdart/rxdart.dart';

class AuthenticatinoRxdart {
  AuthenticationRepository _authenticationRepository =
      AuthenticationRepository();

  BehaviorSubject<LoginState> _subjectLogin = BehaviorSubject<LoginState>();
  BehaviorSubject<RegisterState> _subjectSignUp =
      BehaviorSubject<RegisterState>();

  /// [Logic]
  login(String email, String pass) async {
    var data =
        await _authenticationRepository.login(email: email, password: pass);
    if (_subjectLogin.isClosed == false) {
      _subjectLogin.sink.add(data);
    }
  }

  singUp(String email, String pass) async {
    var data =
        await _authenticationRepository.register(email: email, password: pass);
    if (_subjectSignUp.isClosed == false) {
      _subjectSignUp.sink.add(data);
    }
  }

  /// [Close] all Subjects
  closeLogin() {
    if (_subjectLogin.isClosed == false) _subjectLogin.close();
  }

  closeSignUp() {
    if (_subjectSignUp.isClosed == false) _subjectSignUp.close();
  }

  /// [Getter] Subjects
  BehaviorSubject<LoginState> get subjectLogin => _subjectLogin;
  BehaviorSubject<RegisterState> get subjectSignUp => _subjectSignUp;
}
