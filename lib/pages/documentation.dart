import 'package:dchakra/fade/fade_ani_chain.dart';
import 'package:dchakra/icons/logo.dart';
import 'package:dchakra/pages/level_documentation.dart';
import 'package:flutter/material.dart';

class Documentation extends StatelessWidget {
  final String username;

  const Documentation({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 55,
              right: -320,
              child: SizedBox(
                height: 650,
                width: 650,
                child: Opacity(opacity: 0.4, child: AppLogo(size: 350)),
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
                bottom: 40,
                left: 120,
                right: 120,
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
