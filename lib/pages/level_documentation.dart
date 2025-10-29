import 'package:dchakra/icons/chakra_list.dart';
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
              height: 650,
              width: 650,
              left: -320,
              child: Opacity(opacity: 0.1,child: SizedBox(child: AppLogo())),
            ),
            Center(child: LinrGrage()),
            Center(
              child: GlassEffect(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    Positioned(
                      top: 15,
                      left: 0,
                      right: 0,
                      child: SizedBox(
                        height: 55,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            "Chakra Progress Tracker",
                            style: const TextStyle(
                              color: Color.fromARGB(207, 255, 255, 255),
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                    botmNavBar(),
                    Positioned(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 85, 0, 71),
                        height: double.infinity,
                        width: double.infinity,
                        child: Center(child: ContainList()),
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

botmNavBar() {
  return Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 70,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: BorderDirectional(
                            top: BorderSide(
                              width: 1,
                              color: const Color.fromARGB(22, 255, 255, 255),
                            ),
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.home_rounded),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.calendar_month_rounded),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.settings),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.person),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
}
