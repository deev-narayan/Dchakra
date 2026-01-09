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

      setState(() {
        _phase = SessionPhase.rest;
      });
    } else {
      _goToNextPose();
    }
  }

  // ---------------- FLOW CONTROL ----------------

  void _goToNextPose() async {
    if (_currentPage >= widget.yogasana.length - 1) {
      _flutterTts.speak("Session complete. Well done.");
      _sessionRunning = false;
      return;
    }

    setState(() {
      _currentPage++;
      _phase = SessionPhase.pose;
    });

    await _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
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
              height: 40,
              child: Row(
                children: [
                  const BackButton(color: Colors.white),
                  Text(
                    widget.name,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ],
              ),
            ),

            Positioned(
              top: 40,
              left: 0,
              right: 0,
              height: 650,
              child: Column(
                children: [
                  SizedBox(
                    height: 440,
                    child: PageView.builder(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.yogasana.length,
                      itemBuilder: (context, index) {
                        final item =
                            widget.yogasana[keys[index]] as Map<String, dynamic>?;
                        final imagePath =
                            item?['image'] ?? 'assets/placeholder.png';

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: const Color.fromARGB(228, 255, 255, 255),
                              ),
                              child: Image.asset(
                                imagePath,
                                height: 340,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              keys[index],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _phase == SessionPhase.pose
                                  ? "Hold Pose"
                                  : "Rest",
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            ///  TIMER CONTROLS EVERYTHING
            Positioned(
              left: 0,
              right: 0,
              bottom: 85,
              child: CountdownTimer(
                key: ValueKey("$_currentPage-$_phase"),
                maxSeconds:
                    _phase == SessionPhase.pose ? poseDuration : restDuration,
                color: getChakraColor(widget.color),
                nextPage: () {},
                prevPage: () {},
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
