import 'package:dchakra/icons/logo.dart';
import 'package:flutter/material.dart';

class LevelDocumentation extends StatelessWidget {
  const LevelDocumentation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 55,
              right: -320,
              child: SizedBox(
                height: 650,
                width: 650,
                child: FadeTransitionSample(
                  begin: 0.0,
                  end: 1.0,
                  child: AppLogo(size: 350),
                ),
              ),
            ),

            Center(child: LinrGrage()),
            Center(
              child: GlassEffect(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 55,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color.fromARGB(38, 248, 223, 140),
                              const Color.fromARGB(22, 0, 0, 0),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: BoxBorder.fromLTRB(
                            bottom: BorderSide(
                              width: 1,
                              color: const Color.fromARGB(47, 151, 144, 83),
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Chakra current Level",
                            style: const TextStyle(
                              color: Color.fromARGB(92, 255, 255, 255),
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
