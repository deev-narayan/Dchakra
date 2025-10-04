import 'package:dchakra/icons/logo.dart';
import 'package:dchakra/pages/documentation.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Stack(
  children: [
    Positioned(
      top: MediaQuery.of(context).size.height * 0.5,
      left: MediaQuery.of(context).size.width * 0.5,
      child: Transform.translate(
        offset: Offset(-611 / 2, -611 / 2),
        child: AppLogo(size: 278,)
      ),
    ),
  ],
),

          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color.fromARGB(0, 241, 241, 241),
                  const Color.fromARGB(100, 0, 0, 0),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return Documentation();
                      },
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  side: BorderSide(
                    color: const Color.fromARGB(94, 151, 144, 83),
                    width: 1,
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(33, 231, 211, 148),
                        const Color.fromARGB(32, 56, 40, 6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Container(
                    height: 50,
                    width: 180,
                    alignment: Alignment.center,
                    child: const Text(
                      'Login with Google',
                      style: TextStyle(
                        color: Color.fromARGB(80, 255, 255, 255),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
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
}
