import 'package:dchakra/icons/logo.dart';
import 'package:dchakra/pages/item_detail_info.dart';
import 'package:dchakra/pages/yoga&meditaton/timer_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class BalanceMenu extends StatefulWidget {
  final String name;
  final String color;
  final Map<String, dynamic> yogasana;  // Updated to Map<String, dynamic>

  const BalanceMenu({
    super.key,
    required this.yogasana,
    required this.name,
    required this.color,
  });

  @override
  _BalanceMenuState createState() => _BalanceMenuState();
}

class _BalanceMenuState extends State<BalanceMenu> {
  late PageController _pageController;
  int _currentPage = 0;
  final FlutterTts _flutterTts = FlutterTts();
  Map? _currentVoice;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    initTTS();
  }

  void initTTS() async {
    try {
      var data = await _flutterTts.getVoices;
      List<Map> voices = List<Map>.from(data);
      voices = voices.where((v) => v["name"].toString().contains("en")).toList();

      if (voices.isNotEmpty) {
        _currentVoice = voices.first;
        setVoice(_currentVoice!);
      }
    } catch (e) {
      // Handle error silently or log it
    }
  }

  void setVoice(Map voice) {
    _flutterTts.setVoice({
      "name": voice["name"],
      "locale": voice["locale"],
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < widget.yogasana.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> keys = widget.yogasana.keys.toList();  // List of yogasana names

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 55,
              height: 650,
              width: 650,
              left: -320,
              child: Opacity(opacity: 0.1, child: SizedBox(child: AppLogo())),
            ),
            Center(child: LinrGrage()),  // Assuming this is a custom widget
            Center(
              child: GlassEffect(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 70,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: BorderDirectional(
                            top: BorderSide(
                              width: 1,
                              color: const Color.fromARGB(21, 255, 255, 255),
                            ),
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.home_rounded),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.calendar_month_rounded),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.settings),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.person),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 10,
              right: 10,
              height: 40,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BackButton(color: Colors.white),
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
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
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: widget.yogasana.length,
                        onPageChanged: (index) {
                          final yogasanaItem = widget.yogasana[keys[index]] as Map<String, dynamic>?;
                          final List<dynamic> steps = yogasanaItem?['steps'] as List<dynamic>? ?? [];
                          String text = "The next sixty seconds ${keys[index]}. ";
                          for (dynamic step in steps) {
                            text += "$step. ";
                          }
                          _flutterTts.speak(text);
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final yogasanaItem = widget.yogasana[keys[index]] as Map<String, dynamic>?;  // Get the inner map
                          final imagePath = yogasanaItem?['image'] as String? ?? 'assets/placeholder.png';  // Safely get the image path
                          
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: Image.asset(
                                  imagePath,  // Now uses the correct image path
                                  height: 340,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.broken_image,
                                      size: 200,
                                      color: Colors.red,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                keys[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${_currentPage + 1} / ${widget.yogasana.length}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Positioned(left: 0, right: 0, bottom: 85, child: CountdownTimer(nextPage: _nextPage, prevPage: _prevPage, color: getChakraColor(widget.color))),
          ],
        ),
      ),
    );
  }
}