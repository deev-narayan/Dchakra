import 'package:dchakra/icons/chakra_list.dart';
import 'package:dchakra/icons/logo.dart';
import 'package:dchakra/navbar.dart';
import 'package:dchakra/theme.dart';
import 'package:flutter/material.dart';
import 'package:dchakra/notifiers.dart';
import 'package:google_fonts/google_fonts.dart';

class LevelDocumentation extends StatefulWidget {
  const LevelDocumentation({super.key});

  @override
  State<LevelDocumentation> createState() => _LevelDocumentationState();
}

class _LevelDocumentationState extends State<LevelDocumentation> {
  @override
  void initState() {
    super.initState();
    selectedIndexNotifier.value = 0; // Preset to Home
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // 1. Background Gradient
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark ? AppTheme.darkGradient : AppTheme.lightGradient,
              ),
            ),
          ),

          // 2. Background Logo (Decorative)
          Positioned(
            top: -100,
            right: -150,
            child: Opacity(
              opacity: 0.15, // Subtle background element
              child: Transform.rotate(
                angle: 0.5,
                child: const AppLogo(size: 500),
              ),
            ),
          ),

          // 3. Main Content
          SafeArea(
            bottom: false, // Let content flow behind bottom nav if needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Journey",
                        style: GoogleFonts.cinzel(
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Chakra Levels",
                        style: GoogleFonts.cinzel( // Using Cinzel for a mystical feel
                          color: theme.textTheme.titleLarge?.color,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),

                // List Content
                Expanded(
                  child: Container(
                     // Add glass effect container for list area if desired, 
                     // or keep it clean. Let's try clean first, but maybe wrapping the list
                     // for valid padding.
                     padding: const EdgeInsets.only(bottom: 80), // Space for bottom nav
                     child: const ContainList(),
                  ),
                ),
              ],
            ),
          ),

          // 4. Bottom Navigation Bar
          // Ensure this stays on top
          botmNavBar(context),
        ],
      ),
    );
  }
}
