import 'package:dchakra/icons/chakra_list.dart';
import 'package:dchakra/icons/logo.dart';
import 'package:dchakra/navbar.dart';
import 'package:flutter/material.dart';

class LevelDocumentation extends StatelessWidget {
  const LevelDocumentation({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Positioned(
                top: 55,
                height: 650,
                width: 650,
                // left: -320,
                child: Opacity(opacity: 0.4, child: SizedBox(child: AppLogo())),
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
                      top: 15,
                      left: 0,
                      right: 0,
                      child: SizedBox(
                        height: 55,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            "Chakra Progress Tracker",
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                    botmNavBar(context),
                    Positioned(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 85, 0, 71),
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

