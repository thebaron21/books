
import 'package:books/src/config/constants.dart';
import 'package:flutter/material.dart';

class Slider {
  final String sliderImageUrl;
  final String sliderHeading;
  final String sliderSubHeading;

  Slider(
      {@required this.sliderImageUrl,
        @required this.sliderHeading,
        @required this.sliderSubHeading});
}

final sliderArrayList = [
  Slider(
      sliderImageUrl: 'assets/images/slider_1.png',
      sliderHeading: Constants.ONE,
      sliderSubHeading: Constants.SLIDER_HEADING_1),
  Slider(
      sliderImageUrl: 'assets/images/slider_2.png',
      sliderHeading: Constants.TWO,
      sliderSubHeading: Constants.SLIDER_HEADING_2),
  Slider(
      sliderImageUrl: 'assets/images/slider_3.png',
      sliderHeading: Constants.THREE,
      sliderSubHeading: Constants.SLIDER_HEADING_3),
];
