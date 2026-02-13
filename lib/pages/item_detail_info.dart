import 'package:dchakra/fade/button_theme.dart';
import 'package:dchakra/icons/logo.dart';
import 'package:dchakra/pages/level_documentation.dart';
import 'package:dchakra/pages/yoga&meditaton/balance_menu.dart';
import 'package:dchakra/pages/yoga&meditaton/mantra_chant.dart';
import 'package:dchakra/navbar.dart';
import 'package:flutter/material.dart';

Color getChakraColor(String colorName) {
  switch (colorName.toLowerCase()) {
    case 'red': // Root Chakra
      return const Color.fromARGB(255, 183, 28, 28); // Deep Red
    case 'orange': // Sacral Chakra
      return const Color.fromARGB(255, 255, 87, 34); // Bright Orange
    case 'yellow': // Solar Plexus Chakra
      return const Color.fromARGB(255, 255, 193, 7); // Sunny Yellow
    case 'green': // Heart Chakra
      return const Color.fromARGB(255, 76, 175, 80); // Vibrant Green
    case 'blue': // Throat Chakra
      return const Color.fromARGB(255, 33, 150, 243); // Calm Blue
    case 'indigo': // Third Eye Chakra
      return const Color.fromARGB(255, 63, 81, 181); // Deep Indigo
    case 'violet': // Crown Chakra
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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Center(child: LinrGrage()),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  child: Row(
                    children: [
                      const BackButton(),
                      Center(
                        child: Text(
                          name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    height: 300,
                    child: Hero(tag: name, child: Image.asset(image))),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(context, "Element", element),
                      _buildInfoRow(context, "Location", location),
                      _buildInfoRow(context, "Function", function),
                      _buildInfoRow(context, "Mantra", mantra),
                      _buildInfoRow(context, "Color", color),
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
                      child: BalanceMenu(
                        yogasana: yogasana,
                        name: name,
                        color: color,
                      ),
                    ),
                  ),
                  Center(
                    child: BtnTheme(
                      text: "Meditate",
                      color: getChakraColor(color),
                      child: MantraChant(
                        chakraName: name,
                        getClr: getChakraColor(color),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            botmNavBar(context)
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label : ",
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
