import 'package:dchakra/icons/logo.dart';
import 'package:flutter/material.dart';

class Documentation extends StatelessWidget {
  const Documentation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 30,
              right: -42,
              child: SizedBox(
                height: 200,
                width: 200,
                child: AppLogo(size: 100),
              ),
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
            Center(child: AppLogo(size: 0)),
            Center(child: SizedBox(height: 400,width: 150,),),
            Center(child: Text("Documentation here")),
          ],
        ),
      ),
    );
  }
}
