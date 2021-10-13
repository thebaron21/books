import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



// ignore: must_be_immutable
class SlideDots extends StatefulWidget {
  bool isActive;
  SlideDots(this.isActive);

  @override
  State<SlideDots> createState() => _SlideDotsState();
}

class _SlideDotsState extends State<SlideDots> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 3.3),
      height: widget.isActive ? 10 : 6,
      width: widget.isActive ? 10 : 6,
      decoration: BoxDecoration(
        color: widget.isActive ? Colors.white : Colors.grey,
        border: widget.isActive ?  Border.all(color: Color(0xff927DFF),width: 2.0,) : Border.all(color: Colors.transparent,width: 1,),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
