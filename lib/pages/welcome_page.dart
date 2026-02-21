import 'package:dchakra/auth/auth_service.dart';
import 'package:dchakra/icons/logo.dart';
import 'package:dchakra/pages/documentation.dart';
import 'package:dchakra/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  // Button state
  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;


    final logoSize = (screenWidth * 0.4).clamp(150.0, 220.0); 
    final titleFontSize = (screenWidth * 0.12).clamp(32.0, 56.0);
    final taglineFontSize = (screenWidth * 0.045).clamp(14.0, 20.0);
    final buttonPadding = (screenWidth * 0.1).clamp(20.0, 60.0);
    final buttonHeight = (screenHeight * 0.07).clamp(50.0, 65.0);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // 1. Premium Background Gradient
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
          
          // 2. Subtle Background Pattern/Overlay
          Positioned.fill(
             child: Opacity(
               opacity: 0.02,
               child: Image.asset(
                 'assets/images/dchakra.png',
                 repeat: ImageRepeat.noRepeat,
                 fit: BoxFit.cover,
               ),
             ),
          ),

          // 3. Main Content
          SafeArea(
            child: AnimationLimiter(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 800),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: widget,
                          ),
                        ),
                        children: [
                          // --- Animated Logo ---
                          Center(
                            child: AnimatedBuilder(
                              animation: _scaleAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _scaleAnimation.value,
                                  child: child,
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 60,
                                      spreadRadius: -30,
                                    )
                                  ]
                                ),
                                child: Hero(
                                    tag: 'appLogoHero', 
                                    child: AppLogo(size: logoSize)
                                ),
                              ),
                            ),
                          ),
                          
                          SizedBox(height: screenHeight * 0.04),

                          // --- Brand Title ---
                          Text(
                            "Dchakra",
                            style: GoogleFonts.cinzel(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.displayLarge?.color,
                              letterSpacing: 2.0,
                            ),
                          ),
                          
                          SizedBox(height: screenHeight * 0.01),

                          // --- Tagline ---
                          Text(
                            "Balance Your Energy",
                            style: GoogleFonts.outfit(
                              fontSize: taglineFontSize,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 3.0,
                              color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.08),

                          // --- Sign In Button ---
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: buttonPadding),
                            child: _buildPremiumGoogleButton(
                              context, 
                              theme, 
                              isDark, 
                              screenWidth,
                              buttonHeight,
                            ),
                          ),
                          
                          SizedBox(height: screenHeight * 0.04),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumGoogleButton(
    BuildContext context, 
    ThemeData theme, 
    bool isDark, 
    double screenWidth,
    double height,
  ) {
    final buttonTextFontSize = (screenWidth * 0.042).clamp(14.0, 18.0);
    final iconSize = (height * 0.45).clamp(20.0, 28.0);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isButtonPressed = true),
      onTapUp: (_) => setState(() => _isButtonPressed = false),
      onTapCancel: () => setState(() => _isButtonPressed = false),
      onTap: () async {
        final authService = AuthService();
        final userCredential = await authService.signInWithGoogle();

        if (userCredential != null && context.mounted) {
          final name = userCredential.user!.displayName!;
          final userName = name;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Documentation(username: userName,),
            ),
          );
        }
      },
      child: AnimatedScale(
        scale: _isButtonPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            // Gradient Border Effect
            gradient: LinearGradient(
              colors: [
                const Color(0xFF6750A4), // Primary Purple
                const Color(0xFFE94E77), // Pink Accent
                const Color(0xFF33CCFF), // Blue Accent
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(height / 2),
            boxShadow: [
              // Premium Glow
              BoxShadow(
                color: const Color(0xFF6750A4).withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(2.5), // Width of the gradient border
          child: Container(
            decoration: BoxDecoration(
              // Inner Background
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(height / 2 - 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/google.png', height: iconSize),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  "Sign in with Google",
                  style: GoogleFonts.outfit(
                    fontSize: buttonTextFontSize,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
