import 'package:dchakra/icons/logo.dart';
import 'package:dchakra/pages/level_documentation.dart' show botmNavBar;
import 'package:dchakra/pages/yoga&meditaton/timer_bar.dart';
import 'package:flutter/material.dart';
class MantraChant extends StatelessWidget {
  final String chakraName;
  final Color getClr;
  const MantraChant({super.key, required this.chakraName, required this.getClr});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(leading: BackButton(),title: Text(chakraName),),body: Stack(
      children: [
        Positioned(
              top: 55,
              right: -320,
              child: SizedBox(
                height: 650,
                width: 650,
                child: Opacity(opacity: 0.2,child: AppLogo(size: 350)),
              ),
        ),
        Positioned(bottom: 90,left: 30,right: 30,child: CountdownTimer( color: getClr, maxSeconds: 300, nextPage: () {  }, prevPage: () {  },)),
        botmNavBar()
      ],
    ));
  }
}