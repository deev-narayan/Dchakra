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

class _MantraChantState extends State<MantraChant> {
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
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
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(
          widget.chakraName,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 55,
            right: -320,
            child: SizedBox(
              height: 650,
              width: 650,
              child: Opacity(opacity: 0.1, child: AppLogo(size: 350)),
            ),
          ),
          Positioned(
            bottom: 120, // Adjusted to avoid overlap with NavBar (height 70)
            left: 20,
            right: 20,
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