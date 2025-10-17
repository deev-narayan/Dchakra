import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback prevPage;
  final Color color;
  const CountdownTimer({super.key, required this.nextPage, required this.prevPage, required this.color});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  static const maxseconds = 59;
  int seconds = maxseconds;
  bool isRunning = false;
  Timer? timer;

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if(seconds ==0){
          widget.nextPage();
          resetTimer();
        }
        if (seconds > 0) {
          seconds--;
        } else {
          timer?.cancel();
          isRunning = false;
        }
      });
    });
    setState(() {
      isRunning = true;
    });
  }

  void stopTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      seconds = maxseconds;
      isRunning = false;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double fullWidth = 320;
    double height = 80;
    double progress = 1 - (seconds / maxseconds);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            seconds < 10 ? "00:0$seconds" : "00:$seconds",
            style: TextStyle(fontSize: 70, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(height: 15),
        Container(
          color: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Stack(
              children: [
                // Main container background
                Container(
                  width: fullWidth,
                  height: height,
                  color: const Color.fromARGB(14, 255, 255, 255),
                ),
                // Progress bar inside container (width only!)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    width: fullWidth * progress,
                    height: height,
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(25),
                        right: Radius.circular(progress == 1 ? 25 : 2),
                      ),
                    ),
                  ),
                ),
                // Button row
                SizedBox(
                  width: fullWidth,
                  height: height,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: const Color.fromARGB(255, 255, 255, 255)),
                        onPressed: (){
                          widget.prevPage();
                          resetTimer();
                        },
                      ),
                      IconButton(
                        icon: Icon(isRunning ? Icons.pause : Icons.play_arrow,
                            color: const Color.fromARGB(255, 255, 255, 255)),
                        onPressed: () {
                          if (isRunning) {
                            stopTimer();
                          } else {
                            startTimer();
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios, color: const Color.fromARGB(255, 255, 255, 255)),
                        onPressed: (){
                          widget.nextPage();
                          resetTimer();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
