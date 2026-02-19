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
                 scale: 1.0,
               ),
             ),
          ),

          // 3. Main Content
          SafeArea(
            child: AnimationLimiter(
              child: Center(
                child: SingleChildScrollView(
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
                                    color: Colors.black.withOpacity(1.0),
                                    blurRadius: 60,
                                    spreadRadius: -110,
                                  )
                                ]
                              ),
                              child: const Hero(
                                  tag: 'appLogoHero', 
                                  child: AppLogo(size: 280)
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 40),

                        // --- Brand Title ---
                        Text(
                          "Dchakra",
                          style: GoogleFonts.cinzel(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: theme.textTheme.displayLarge?.color,
                            letterSpacing: 2.0,
                          ),
                        ),
                        
                        const SizedBox(height: 12),

                        // --- Tagline ---
                        Text(
                          "Balance Your Energy",
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 3.0,
                            color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                          ),
                        ),

                        const SizedBox(height: 80),

                        // --- Sign In Button ---
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: _buildPremiumGoogleButton(context, theme, isDark),
                        ),
                        
                        const SizedBox(height: 40),
                      ],
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

  Widget _buildPremiumGoogleButton(BuildContext context, ThemeData theme, bool isDark) {
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
          height: 60,
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
            borderRadius: BorderRadius.circular(30),
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
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/google.png', height: 26),
                ),
                const SizedBox(width: 3),
                Text(
                  "Sign in with Google",
                  style: GoogleFonts.outfit(
                    fontSize: 17,
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
