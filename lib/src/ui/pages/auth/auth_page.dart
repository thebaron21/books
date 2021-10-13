import 'package:books/res.dart';
import 'package:books/src/config/LocaleLang.dart';
import 'package:books/src/config/route.dart';
import 'package:books/src/logic/firebase/authentication.dart';
import 'package:books/src/logic/rxdartModel/login_rxdart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../home.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<LoginPage> {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'acceptTerms': false
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();
  bool isLoading = false;
  bool accept = false;
  bool isLogin = true;

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      fit: BoxFit.cover,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
      image: AssetImage(Res.book),
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'E-Mail', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email';
        }
      },
      controller: _email,
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password', filled: true, fillColor: Colors.white),
      obscureText: true,
      controller: _pass,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password invalid';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildPasswordConfirmTextField() {
    return TextFormField(
      controller: _passwordTextController,
      decoration: InputDecoration(
          labelText: 'Confirm Password',
          filled: true,
          fillColor: Colors.white,
          labelStyle: TextStyle(color: Colors.black)),
      obscureText: true,
      validator: (String value) {
        if (_passwordTextController.text != value) {
          return 'Passwords do not match.';
        }
      },
    );
  }

  Widget _buildAcceptSwitch() {
    return SwitchListTile(
      value: _formData['acceptTerms'],
      onChanged: (bool value) {
        setState(() {
          _formData['acceptTerms'] = value;
        });
      },
      title: Text('Accept Terms'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: _buildBackgroundImage(),
        ),
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: targetWidth,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildEmailTextField(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _buildPasswordTextField(),
                    SizedBox(
                      height: 10.0,
                    ),
                    isLogin == false
                        ? _buildPasswordConfirmTextField()
                        : Container(),
                    _buildAcceptSwitch(),
                    SizedBox(
                      height: 10.0,
                    ),
                    FlatButton(
                      child: Text(
                          'Switch to ${isLogin == false ? 'Signup' : 'Login'}'),
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    isLoading == true
                        ? CircularProgressIndicator()
                        : RaisedButton(
                            textColor: Colors.white,
                            child: Text(isLogin == true ? 'LOGIN' : 'SIGNUP'),
                            onPressed: () => _submit(),
                          )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AuthenticatinoRxdart _authenticatinoRxdart = AuthenticatinoRxdart();
  @override
  void dispose() {
    super.dispose();
    _authenticatinoRxdart.closeLogin();
    _authenticatinoRxdart.closeSignUp();
  }

  _submit() async {

    print(_formData['acceptTerms']);
    if (_formData['acceptTerms'] == true) {
      setState(() => isLoading = true);
      if (isLogin == true) {
        print("IsLogin : $isLogin");
        await _authenticatinoRxdart.login(
            _email.text, _pass.text);
        _authenticatinoRxdart.subjectLogin.listen((value) {
          print("Login is Value $value");
          switch (value) {
            case LoginState.Success:
              RouterC.of(context).pushBack(HomePage());
              break;
            case LoginState.UserNotFound:
              RouterC.of(context).message("خطأ", "المستخدم غير موجود");
              break;
            case LoginState.InvalidEmail:
              RouterC.of(context).message("خطأ", "البريد الإلكتروني غير موجود");
              break;
            case LoginState.Failure:
              RouterC.of(context).message("خطا", "خطأ غيرمعروف");
              break;
            case LoginState.WrongPassword:
              RouterC.of(context).message("خطا", "كلمة المرور غير صحيحة");
              break;
          }
        });
      } else {
        if (_pass.text == _passwordTextController.text) {
          await _authenticatinoRxdart.singUp(_email.text, _pass.text);
          _authenticatinoRxdart.subjectSignUp.listen((value) {
            print("Sing Up is Value : $value");
            switch (value) {
              case RegisterState.Success:
                RouterC.of(context).pushBack(HomePage());
                break;
              case RegisterState.WeakPassword:
                RouterC.of(context).message("خطا", "كلمة المرور ضعيفة");
                break;
              case RegisterState.EmailAlreadyInUse:
                RouterC.of(context).message("خطا", "البريد الإلكتروني مستخدم ");
                break;
              case RegisterState.InvalidEmail:
                RouterC.of(context).message("خطا", "خطأ في البريد الإلكتروني");
                break;
              case RegisterState.Unknown:
                RouterC.of(context).message("خطا", "خطأ مجهول");
                break;
              case RegisterState.Failure:
                RouterC.of(context).message("خطا", "خطأ غير معروف");
                break;
            }
          });
          setState(() => isLoading = false);
        } else {
          setState(() => isLoading = false);
          RouterC.of(context).message("خطأ", "كلمة السر غير متطابقة");
        }
      }

      setState(() => isLoading = false);
    } else {
      RouterC.of(context).message('تنبيه', 'يجب الموافقة على الشروط');
    }
  }

  _signInAndSignUp(Size size) {
    return InkWell(
      onTap: null,
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.07,
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: Text(
          isLogin == false
              ? AppLocale.of(context).getTranslated("register")
              : AppLocale.of(context).getTranslated("login"),
          style: GoogleFonts.lalezar(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
