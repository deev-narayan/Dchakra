import 'package:dchakra/fade/fade_ani_chain.dart';
import 'package:dchakra/icons/logo.dart';
import 'package:dchakra/pages/level_documentation.dart';
import 'package:flutter/material.dart';

class Documentation extends StatelessWidget {
  final String username;

  const Documentation({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: screenHeight * 0.05,
              right: -screenWidth * 0.5,
              child: SizedBox(
                height: screenHeight * 0.8,
                width: screenHeight * 0.8,
                child: Opacity(opacity: 0.4, child: AppLogo(size: screenWidth * 0.5)),
              ),
            ),
            Center(child: LinrGrage()),
            Center(
              child: GlassEffect(
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: SequentialFadeDemo(
                    username: username,
                    onDone: () {
                      Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(builder: (builder) {
                        return LevelDocumentation();
                      }));
                    },
                  ),
                ),
              ),
            ),
            Positioned(
                bottom: screenHeight * 0.05,
                left: screenWidth * 0.3,
                right: screenWidth * 0.3,
                child: IconButton.outlined(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(builder: (builder) {
                        return LevelDocumentation();
                      }));
                    },
                    icon: Icon(Icons.arrow_forward_rounded,
                        color: Theme.of(context).colorScheme.onSurface)))
          ],
        ),
      ),
    );
  }
}
