import 'package:books/src/config/constants.dart';
import 'package:books/src/logic/function/slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SlideItem extends StatelessWidget {
  final int index;
  SlideItem(this.index);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.width * 0.6,
          width: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(sliderArrayList[index].sliderImageUrl),
            ),
          ),
        ),
        SizedBox(
          height: 60.0,
        ),
        Text(
          sliderArrayList[index].sliderHeading,
          style: GoogleFonts.tajawal(
            fontWeight: FontWeight.w700,
            fontSize: 20.5,
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              sliderArrayList[index].sliderSubHeading,
              style: GoogleFonts.tajawal(
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
