import 'dart:async';
import 'package:books/src/config/route.dart';
import 'package:books/src/widgets/slide_items/slide_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import '../home.dart';
import '../widgets/slide_dots.dart';
import 'package:books/src/config/constants.dart';
import 'package:books/src/logic/function/slider.dart';
import 'package:flutter/cupertino.dart';

import 'pages/auth/auth_page.dart';

class SliderLayoutView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SliderLayoutViewState();
}

class _SliderLayoutViewState extends State<SliderLayoutView> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  User user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    Timer.periodic(
      Duration(seconds: 5),
      (Timer timer) {
        if (_currentPage < 2) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  int getPage(int current) {
    _onPageChanged(current);
    return _currentPage;
  }

  @override
  Widget build(BuildContext context) => topSliderLayout();

  Widget topSliderLayout() => Container(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              Text("dfjlksdfjkls\b{adf}"),
              PageView.builder(
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                onPageChanged: (index) {
                  _onPageChanged(index);
                  print(index);
                },
                itemCount: sliderArrayList.length,
                itemBuilder: (ctx, i) => SlideItem(i),
              ),
              Stack(
                alignment: AlignmentDirectional.topStart,
                children: <Widget>[
                  _currentPage == 2
                      ? Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 15.0, bottom: 15.0),
                            child: InkWell(
                              onTap: () async {
                                final settings = await Hive.openBox('settings');
                                await settings.put("inital", false);
                                RouterC.of(context).push(
                                  user != null ? HomePage() : LoginPage(),
                                );
                              },
                              child: Text(
                                Constants.SKIP,
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        )
                      : Center(),
                  Container(
                    alignment: AlignmentDirectional.bottomCenter,
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        for (int i = 0; i < sliderArrayList.length; i++)
                          if (i == _currentPage)
                            SlideDots(true)
                          else
                            SlideDots(false)
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
}
