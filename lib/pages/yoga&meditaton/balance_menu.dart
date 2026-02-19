import 'package:dchakra/icons/logo.dart';
import 'package:dchakra/pages/item_detail_info.dart';
import 'package:dchakra/pages/yoga&meditaton/timer_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

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
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        // Last pose completed
        _flutterTts.speak("Session complete. Well done.");
        _flutterTts.setCompletionHandler(() {
          Navigator.of(context).pop();
        });
        _sessionRunning = false;
        // Handle session completion (e.g., navigate back or show summary)
        // For now, maybe just stop? Or go back?
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
    // Manual skip functionality
    if (_currentPage >= widget.yogasana.length - 1) {
      _flutterTts.speak("Session complete. Well done.");
      _sessionRunning = false;
      Navigator.of(context).pop();
      return;
    }

    if (_phase == SessionPhase.pose) {
      // Skip pose -> go to rest of next pose? Or just go to next pose directly?
      // Usually 'Next' button implies "I'm done with this, give me the next thing".
      // If currently in Pose, user might want to skip to Rest (of next item) or skip Rest entirely?
      // Let's assume manual 'Next' skips to the Next Pose (Pose Phase) to be fast.
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
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
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
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 55,
              height: 650,
              width: 650,
              left: -320,
              child: Opacity(opacity: 0.1, child: AppLogo()),
            ),
            Positioned(
              top: 0,
              left: 10,
              right: 10,
              height: 60,
              child: Row(
                children: [
                  const BackButton(),
                  Text(
                    widget.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              bottom: 100,
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.yogasana.length,
                itemBuilder: (context, index) {
                  final item =
                      widget.yogasana[keys[index]] as Map<String, dynamic>?;
                  final imagePath = item?['image'] ?? 'assets/placeholder.png';

                  return Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: theme.cardColor, // Added background color
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.shadowColor.withOpacity(0.2),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.asset(
                                imagePath,
                                height: 340,
                                width: double.infinity, // Ensure it fills width
                                fit: BoxFit.contain, // Changed from cover to contain
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            keys[index],
                            style: theme.textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _phase == SessionPhase.pose ? "Hold Pose" : "Rest",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            ///  TIMER CONTROLS EVERYTHING
            Positioned(
              left: 0,
              right: 0,
              bottom: 40,
              child: CountdownTimer(
                key: ValueKey("$_currentPage-$_phase"),
                maxSeconds:
                    _phase == SessionPhase.pose ? poseDuration : restDuration,
                color: getChakraColor(widget.color),
                nextPage: _goToNextPose,
                prevPage: _goToPrevPose,
                onTimerEnd: _onTimerEnd,
                onHalfTime: _onHalfTime,
                onInitialCountdown: _onInitialCountdown,
                onPhaseEnd: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
