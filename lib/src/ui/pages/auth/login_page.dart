import 'package:books/src/config/LocaleLang.dart';
import 'package:books/src/config/route.dart';
import 'package:books/src/logic/firebase/authentication.dart';
import 'package:books/src/logic/rxdartModel/login_rxdart.dart';
import 'package:books/src/home.dart';
import 'package:books/src/ui/pages/payment_account.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();
  TextEditingController _passConfiramtion = TextEditingController();
  final String _logo = "assets/img/log1-01.png";
  AuthenticatinoRxdart _authenticatinoRxdart = AuthenticatinoRxdart();
  @override
  void dispose() {
    super.dispose();
    _authenticatinoRxdart.closeLogin();
    _authenticatinoRxdart.closeSignUp();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _logoApp(size),
              line2,
              selectType(size),
              line,
              desginTextField(
                size,
                _email,
                AppLocale.of(context).getTranslated("email"),
              ),
              line2,
              desginTextField(
                  size, _pass, AppLocale.of(context).getTranslated("password"),
                  isPass: true),
              isLogin == false ? line2 : line4,
              isLogin == false
                  ? desginTextField(
                      size,
                      _passConfiramtion,
                      AppLocale.of(context)
                          .getTranslated("password_confirmation"),
                      isPass: true)
                  : Text(""),
              // isLogin == false ? _typeAccount(size) : Text(""),
              isLogin == false ? line : line4,
              isLoading == false
                  ? _signInAndSignUp(size)
                  : Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.teal,
                      ),
                    ),
              line,
              _fotgotPassword(size)
            ],
          ),
        ),
      ),
    );
  }

  /// [Line] Between
  get line => SizedBox(
        height: 30,
      );
  get line2 => SizedBox(
        height: 10,
      );
  get line3 => SizedBox(
        width: 10,
      );
  get line4 => SizedBox(
        height: 0,
      );

  /// [Design]
  _logoApp(size) {
    return Container(
      width: size.width * 0.5,
      height: size.height * 0.3,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        image: DecorationImage(fit: BoxFit.cover, image: AssetImage(_logo)),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.teal.withOpacity(0.2),
          width: 10,
        ),
      ),
    );
  }

  desginTextField(Size size, TextEditingController con, String s,
      {isPass = false}) {
    return Container(
      width: size.width * 0.9,
      height: size.height * 0.07,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: con,
        obscureText: isPass,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: s,
        ),
      ),
    );
  }

  /// [Data] is Select Type
  bool isLogin = true;
  bool isLoading = false;

  selectType(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _textSelectType(
          AppLocale.of(context).getTranslated("sign_in"),
          () {
            if (isLogin == true) {
              setState(() => isLogin = false);
            } else {
              setState(() => isLogin = true);
            }
            print("Is Login : $isLogin");
          },
          isLogin == true ? Colors.teal : Colors.grey,
        ),
        line3,
        Container(
          color: Colors.black,
          height: 35,
          width: 2.5,
        ),
        line3,
        _textSelectType(
          AppLocale.of(context).getTranslated("sign_up"),
          () {
            if (isLogin == false) {
              setState(() => isLogin = true);
            } else {
              setState(() => isLogin = false);
            }
          },
          isLogin == false ? Colors.teal : Colors.grey,
        )
      ],
    );
  }

  _textSelectType(String text, Function onTap, Color color) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: GoogleFonts.lalezar(
            fontSize: 45, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  _signInAndSignUp(Size size) {
    return InkWell(
      onTap: () async {
        setState(() => isLoading = true);
//        await Future.delayed(Duration(seconds: 4));
        print(isLoading);
        if (isLogin == true) {
          await _authenticatinoRxdart.login(_email.text, _pass.text);
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
                RouterC.of(context)
                    .message("خطأ", "البريد الإلكتروني غير موجود");
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
          if (_pass.text == _passConfiramtion.text) {
            await _authenticatinoRxdart.singUp(_email.text, _pass.text);
            _authenticatinoRxdart.subjectSignUp.listen((value) {
              print("Sing Up is Value : $value");
              switch (value) {
                case RegisterState.Success:
                  if (isFree == true) {
                    RouterC.of(context).pushBack(HomePage());
                  } else {
                    RouterC.of(context).pushBack(PaymentAccount());
                  }
                  break;
                case RegisterState.WeakPassword:
                  RouterC.of(context).message("خطا", "كلمة المرور ضعيفة");
                  break;
                case RegisterState.EmailAlreadyInUse:
                  RouterC.of(context)
                      .message("خطا", "البريد الإلكتروني مستخدم ");
                  break;
                case RegisterState.InvalidEmail:
                  RouterC.of(context)
                      .message("خطا", "خطأ في البريد الإلكتروني");
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
      },
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
          style:  GoogleFonts.lalezar(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  _fotgotPassword(Size size) {
    // ignore: deprecated_member_use
    return FlatButton(
      onPressed: () {},
      child: Text(
        AppLocale.of(context).getTranslated("forgot_password"),
        style:  GoogleFonts.lalezar(
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  bool isFree = true;
  // ignore: unused_element
  _typeAccount(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
      child: Row(
        children: [
          Text("Free an Account"),
          Switch(
            value: isFree,
            onChanged: (value) {
              setState(() => isFree = value);
            },
          ),
        ],
      ),
    );
  }
}