import 'package:dchakra/icons/logo.dart';
import 'package:flutter/material.dart';

class ItemDetailInfo extends StatelessWidget {
  final String name;
  final String image;
  final String color;
  final String element;
  final String location;
  final String function;
  final String mantra;

  const ItemDetailInfo({
    super.key,
    required this.name,
    required this.image,
    required this.color,
    required this.element,
    required this.location,
    required this.function,
    required this.mantra,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(child: LinrGrage()),
            Positioned(
              top: 10,
              child: SizedBox(width: double.infinity,height: 40,child: Center(child: Text(name))),
            ),
            Positioned(child: Center(
              child: Image.asset(image),
            ))
          ],
        ),
      ),
    );
  }
}
