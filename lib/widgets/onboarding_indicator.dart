import 'package:edu_vista_app/utils/color.utility.dart';
import 'package:flutter/material.dart';

class OnboardingIndicator extends StatelessWidget {
  final int? positionIndex, currentIndex;

  const OnboardingIndicator({super.key,this.currentIndex,this.positionIndex});

  @override
  Widget build(BuildContext context) {
    return Container(


height: 10,
width: positionIndex==currentIndex?30:35,
decoration: BoxDecoration(color:
positionIndex==currentIndex?
ColorUtility.secondary:
Colors.black,

borderRadius: BorderRadius.circular(10),


),

    );
  }
}
