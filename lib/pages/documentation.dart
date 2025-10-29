import 'package:dchakra/fade/fade_ani_chain.dart';
import 'package:dchakra/icons/logo.dart';
import 'package:dchakra/pages/level_documentation.dart';
import 'package:flutter/material.dart';

class Documentation extends StatelessWidget {
  const Documentation({super.key});

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
                child: AppLogo(size: 350),
              ),
            ),
            Center(child: LinrGrage()),
            Center(
              child: GlassEffect(
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: SequentialFadeDemo(
                    onDone: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) {
                            return LevelDocumentation();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(bottom: 40,left: 120,right: 120,child: IconButton.outlined(onPressed: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder){
                return LevelDocumentation();
              }));
            }, icon: Icon(Icons.arrow_forward_rounded)))
          ],
        ),
      ),
    );
  }
}
