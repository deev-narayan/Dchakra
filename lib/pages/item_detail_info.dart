import 'package:dchakra/fade/button_theme.dart';
import 'package:dchakra/icons/logo.dart';
import 'package:dchakra/pages/level_documentation.dart';
import 'package:dchakra/pages/yoga&meditaton/balance_menu.dart';
import 'package:dchakra/pages/yoga&meditaton/mantra_chant.dart';
import 'package:flutter/material.dart';

Color getChakraColor(String colorName) {
  switch (colorName.toLowerCase()) {
    case 'red':       // Root Chakra
      return const Color.fromARGB(255, 183, 28, 28); // Deep Red
    case 'orange':    // Sacral Chakra
      return const Color.fromARGB(255, 255, 87, 34); // Bright Orange
    case 'yellow':    // Solar Plexus Chakra
      return const Color.fromARGB(255, 255, 193, 7); // Sunny Yellow
    case 'green':     // Heart Chakra
      return const Color.fromARGB(255, 76, 175, 80); // Vibrant Green
    case 'blue':      // Throat Chakra
      return const Color.fromARGB(255, 33, 150, 243); // Calm Blue
    case 'indigo':    // Third Eye Chakra
      return const Color.fromARGB(255, 63, 81, 181); // Deep Indigo
    case 'violet':    // Crown Chakra
      return const Color.fromARGB(255, 156, 39, 176); // Elegant Violet
    default:
      return Colors.grey; // fallback neutral color
  }
}

class ItemDetailInfo extends StatelessWidget {
  final String name;
  final String image;
  final String color;
  final String element;
  final String location;
  final String function;
  final String mantra;
  final Map<String, Map<String, dynamic>> yogasana;

  const ItemDetailInfo({
    super.key,
    required this.name,
    required this.image,
    required this.color,
    required this.element,
    required this.location,
    required this.function,
    required this.mantra,
    required this.yogasana,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(child: LinrGrage()),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  width: double.infinity,
                  child: Row(
                    children: [
                      BackButton(),
                      Center(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 300,child: Hero(tag: name, child: Image.asset(image))),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        width: double.infinity,
                        child: Row(
                          children: [
                            const Text(
                              "Element : ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(element),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        width: double.infinity,
                        child: Row(
                          children: [
                            const Text(
                              "Location : ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(child: Text(location)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Function : ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(child: Text(function)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        width: double.infinity,
                        child: Row(
                          children: [
                            const Text(
                              "Mantra : ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(mantra),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        width: double.infinity,
                        child: Row(
                          children: [
                            const Text(
                              "Color : ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(color),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 90,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: BtnTheme(
                      text: "Yogasana",
                      color: getChakraColor(color),
                      child: BalanceMenu(yogasana: yogasana,name: name,color: color,),
                    ),
                  ),
                  Center(
                    child: BtnTheme(
                      text: "Meditate",
                      color: getChakraColor(color),
                      child: MantraChant(chakraName: name,getClr: getChakraColor(color),),
                    ),
                  ),
                ],
              ),
            ),
            botmNavBar()
          ],
        ),
      ),
    );
  }
}
