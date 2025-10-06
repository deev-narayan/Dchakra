import 'package:dchakra/fade/button_theme.dart';
import 'package:dchakra/icons/logo.dart';
import 'package:dchakra/pages/documentation.dart';
import 'package:flutter/material.dart';
Color getChakraColor(String colorName) {
  switch (colorName.toLowerCase()) {
    case 'red':
      return const Color.fromARGB(55, 244, 67, 54);
    case 'orange':
      return const Color.fromARGB(55, 255, 153, 0);
    case 'yellow':
      return const Color.fromARGB(55, 255, 235, 59);
    case 'green':
      return const Color.fromARGB(55, 76, 175, 79);
    case 'blue':
      return const Color.fromARGB(55, 33, 149, 243);
    case 'indigo':
      return const Color.fromARGB(55, 63, 81, 181);
    case 'violet':
      return const Color.fromARGB(55, 155, 39, 176);
    default:
      return Colors.grey; // fallback color
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
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  width: double.infinity,
                  child: Center(child: Text(name)),
                ),
                Hero(tag: name,child: Image.asset(image)),
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
          bottom: 15,
          left: 0,
          right: 0,
          child: Center(
            child: BtnTheme(text: "Balance It", color: getChakraColor(color),
            child: Documentation()),
          ),
        ),
          ],
        ),
      ),
    );
  }
}
