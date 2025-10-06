import 'package:dchakra/fade/button_theme.dart';
import 'package:dchakra/icons/logo.dart';
import 'package:dchakra/pages/documentation.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.5,
              left: MediaQuery.of(context).size.width * 0.5,
              child: Transform.translate(
                offset: Offset(-611 / 2, -611 / 2),
                child: Hero(tag: 'appLogoHero', child: AppLogo(size: 278)),
              ),
            ),
          ],
        ),

        Center(child: LinrGrage()),
        Positioned(
          bottom: 100,
          left: 0,
          right: 0,
          child: Center(
            child: BtnTheme(
              text: "Login with Google",
              color: Color.fromARGB(52, 248, 223, 140),
              child: Documentation(),
            ),
          ),
        ),
      ],
    );
  }
}
