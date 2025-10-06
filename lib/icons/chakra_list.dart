import 'dart:convert';
import 'package:dchakra/pages/item_detail_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

String jsonPath = "assets/data/list_chakra_details.json";

class ContainList extends StatefulWidget {
  const ContainList({super.key});

  @override
  State<ContainList> createState() => _ContainListState();
}

class _ContainListState extends State<ContainList> {
  List<dynamic> chakraData = [];

  @override
  void initState() {
    super.initState();
    loadChakraData();
  }

  Future<void> loadChakraData() async {
    final String jsonString = await rootBundle.loadString(jsonPath);
    final List<dynamic> data = json.decode(jsonString);
    setState(() {
      chakraData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (chakraData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      children: chakraData.map((item) {
        return ChakraList(
          name: item['name'],
          image: item['image'],
          color: item['color'],
          element: item['element'],
          location: item['location'],
          function: item['function'],
          mantra: item['mantra'],
        );
      }).toList(),
    );
  }
}

class ChakraList extends StatelessWidget {
  final String name;
  final String image;
  final String color;
  final String element;
  final String location;
  final String function;
  final String mantra;

  const ChakraList({
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
    return Card(
      color: Colors.transparent,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(0, 248, 223, 140),
              const Color.fromARGB(83, 0, 0, 0),
            ],
            end: Alignment.topLeft,
            begin: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(45),
          border: Border.all(
            width: 1,
            color: const Color.fromARGB(34, 255, 255, 255),
          ),
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(45),
            ),
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return ItemDetailInfo(
                    name: name,
                    image: image,
                    color: color.toString(),
                    element: element,
                    location: location,
                    function: function,
                    mantra: mantra,
                  );
                },
              ),
            );
          },
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: Hero(
                  tag: name,
                  child: Image.asset(
                    image,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
