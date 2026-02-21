import 'package:dchakra/icons/logo.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:dchakra/navbar.dart' show botmNavBar;
import 'package:dchakra/pages/yoga&meditaton/timer_bar.dart';
import 'package:flutter/material.dart';

class MantraChant extends StatefulWidget {
  final String chakraName;
  final Color getClr;
  const MantraChant(
      {super.key, required this.chakraName, required this.getClr});

  @override
  State<MantraChant> createState() => _MantraChantState();
}

class _MantraChantState extends State<MantraChant> with WidgetsBindingObserver {
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Register observer
    initTTS();
  }

  Future<void> initTTS() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.45);
  }

  void _onTimerEnd() {
    _flutterTts.speak("Meditation complete. Namaste.");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Meditation complete. Namaste.")),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Unregister observer
    _flutterTts.stop();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _flutterTts.stop(); // Stop TTS on background
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(
          widget.chakraName,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: (screenWidth * 0.055).clamp(18.0, 24.0),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned(
            top: screenHeight * 0.1,
            right: -screenWidth * 0.5,
            child: SizedBox(
              height: screenHeight * 0.8,
              width: screenHeight * 0.8,
              child: Opacity(opacity: 0.1, child: AppLogo(size: screenWidth * 0.6)),
            ),
          ),
          Positioned(
            bottom: (screenHeight * 0.15).clamp(120.0, 200.0), // Adjusted to avoid overlap with NavBar
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: CountdownTimer(
                color: widget.getClr,
                maxSeconds: 300,
                nextPage: () {},
                prevPage: () {},
                onTimerEnd: _onTimerEnd,
              ),
            ),
          ),
            botmNavBar(context),
        ],
      ),
    );
  }
}