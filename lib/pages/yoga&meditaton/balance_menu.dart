import 'package:dchakra/icons/logo.dart';
import 'package:dchakra/pages/item_detail_info.dart';
import 'package:dchakra/pages/yoga&meditaton/timer_bar.dart';
import 'package:dchakra/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';

enum SessionPhase { pose, rest }

class BalanceMenu extends StatefulWidget {
  final String name;
  final String color;
  final Map<String, dynamic> yogasana;

  const BalanceMenu({
    super.key,
    required this.yogasana,
    required this.name,
    required this.color,
  });

  @override
  State<BalanceMenu> createState() => _BalanceMenuState();
}

class _BalanceMenuState extends State<BalanceMenu> {
  late PageController _pageController;
  final FlutterTts _flutterTts = FlutterTts();

  int _currentPage = 0;
  SessionPhase _phase = SessionPhase.pose;
  bool _sessionRunning = false;

  static const int poseDuration = 60;
  static const int restDuration = 15;

  // ---------------- INIT ----------------

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _flutterTts.setCompletionHandler(() {});

    initTTS().then((_) => startYogaSession());
  }

  Future<void> initTTS() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.45);
  }

  // ---------------- SPEECH ----------------

  void _speakPose() {
    final keys = widget.yogasana.keys.toList();
    final item =
        widget.yogasana[keys[_currentPage]] as Map<String, dynamic>?;

    final steps = item?['steps'] ?? [];

    String text =
        "3, 2, 1, start. The next $poseDuration seconds ${keys[_currentPage]}. ";

    for (final step in steps) {
      text += "$step. ";
    }

    _flutterTts.speak(text);
  }

  void _speakRest() {
    _flutterTts.speak("Take a rest");
  }

  // ---------------- TIMER EVENTS ----------------

  void _onInitialCountdown() {
    if (_phase == SessionPhase.pose) {
      _speakPose();
    } else {
      _speakRest();
    }
  }

  void _onHalfTime() {
    _flutterTts.speak("Half time");
  }

  void _onTimerEnd() {
    if (_phase == SessionPhase.pose) {
      _flutterTts.speak("3, 2, 1, stop");

      // Check if there is a next pose
      if (_currentPage < widget.yogasana.length - 1) {
        setState(() {
          _currentPage++;
          _phase = SessionPhase.rest;
        });

        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutQuart,
        );
      } else {
        // Last pose completed
        _flutterTts.speak("Session complete. Well done.");
        _flutterTts.setCompletionHandler(() {
          Navigator.of(context).pop();
        });
        _sessionRunning = false;
      }
    } else {
      // Rest phase ended, start next pose
      setState(() {
        _phase = SessionPhase.pose;
      });
    }
  }

  // ---------------- FLOW CONTROL ----------------

  void _goToNextPose() async {
    if (_currentPage >= widget.yogasana.length - 1) {
      _flutterTts.speak("Session complete. Well done.");
      _sessionRunning = false;
      Navigator.of(context).pop();
      return;
    }

    if (_phase == SessionPhase.pose) {
      setState(() {
        _currentPage++;
        _phase = SessionPhase.pose;
      });
    } else {
      // currently in Rest, skip rest -> go to Pose
      setState(() {
        _phase = SessionPhase.pose;
      });
    }

    await _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutQuart,
    );
  }

  void _goToPrevPose() async {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
        _phase = SessionPhase.pose;
      });
      await _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutQuart,
      );
    }
  }

  void startYogaSession() {
    if (_sessionRunning) return;

    setState(() {
      _sessionRunning = true;
      _currentPage = 0;
      _phase = SessionPhase.pose;
    });

    _pageController.jumpToPage(0);
  }

  // ---------------- DISPOSE ----------------

  @override
  void dispose() {
    _flutterTts.stop();
    _pageController.dispose();
    super.dispose();
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    final keys = widget.yogasana.keys.toList();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final totalPoses = widget.yogasana.length;

    // Helper to get efficient chakra color
    Color accentColor = getChakraColor(widget.color);

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

          // 2. Decorative Background
          Positioned(
            top: -50,
            right: -100,
            child: Opacity(
              opacity: 0.02,
              child: Transform.rotate(
                angle: -0.2,
                child: const AppLogo(size: 800),
              ),
            ),
          ),

          // 3. Header & Content
          SafeArea(
            child: Column(
              children: [
                // Header Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    children: [
                      // Custom Back Button
                      Container(
                        decoration: BoxDecoration(
                          color: theme.cardColor.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const BackButton(),
                      ),
                      const SizedBox(width: 12),
                      
                      // Title
                      Expanded(
                        child: Text(
                          widget.name,
                          style: GoogleFonts.cinzel(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: theme.textTheme.titleLarge?.color,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      
                      // Progress Indicator (Pose X/Y)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: accentColor.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          "Step ${_currentPage + 1} / $totalPoses",
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? accentColor.withOpacity(0.9) : accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Content Area
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: totalPoses,
                    itemBuilder: (context, index) {
                      final item =
                          widget.yogasana[keys[index]] as Map<String, dynamic>?;
                      final imagePath = item?['image'] ?? 'assets/placeholder.png';

                      return AnimationConfiguration.synchronized(
                        duration: const Duration(milliseconds: 600),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 20),
                                  // Image Card - Restored Glass Container but Transparent Inner Background
                                  Center(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 32),
                                      decoration: BoxDecoration(
                                        color: isDark 
                                            ? Colors.white.withOpacity(0.05) 
                                            : Colors.white.withOpacity(0.40), // Reduced opacity for blend
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(isDark ? 0.1 : 0.3), 
                                          width: 1.5
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: accentColor.withOpacity(0.2),
                                            blurRadius: 30,
                                            offset: const Offset(0, 15),
                                            spreadRadius: -5,
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(20.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: AspectRatio(
                                          aspectRatio: 1.0, 
                                          child: Image.asset(
                                            imagePath,
                                            fit: BoxFit.contain,
                                            // No specific blend needed if image is transparent
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 32),

                                  // Pose Name
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                    child: Text(
                                      keys[index],
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.cinzel(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w600,
                                        color: theme.textTheme.displaySmall?.color,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 24),

                                  // Animated Status Pill
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: _phase == SessionPhase.pose
                                          ? [
                                              accentColor,
                                              accentColor.withOpacity(0.7),
                                            ]
                                          : [
                                              theme.colorScheme.secondary,
                                              theme.colorScheme.secondary.withOpacity(0.7),
                                            ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(50),
                                      boxShadow: [
                                        BoxShadow(
                                          color: (_phase == SessionPhase.pose 
                                              ? accentColor 
                                              : theme.colorScheme.secondary).withOpacity(0.3),
                                          blurRadius: 12,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 300),
                                      transitionBuilder: (Widget child, Animation<double> animation) {
                                        return FadeTransition(opacity: animation, child: child);
                                      },
                                      child: Text(
                                        _phase == SessionPhase.pose ? "HOLD POSE" : "REST NOW",
                                        key: ValueKey(_phase),
                                        style: GoogleFonts.outfit(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 140), // Spacing for bottom timer
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // 4. Floating Timer Controls
          Positioned(
            left: 20,
            right: 20,
            bottom: 30,
            child: Container(
               // Glassmorphism Timer Container
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
              child: CountdownTimer(
                key: ValueKey("$_currentPage-$_phase"),
                maxSeconds:
                    _phase == SessionPhase.pose ? poseDuration : restDuration,
                color: accentColor,
                nextPage: _goToNextPose,
                prevPage: _goToPrevPose,
                onTimerEnd: _onTimerEnd,
                onHalfTime: _onHalfTime,
                onInitialCountdown: _onInitialCountdown,
                onPhaseEnd: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
