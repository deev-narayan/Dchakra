import 'dart:convert';
import 'package:dchakra/pages/item_detail_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:dchakra/icons/logo.dart';
import 'dart:developer' as developer;

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
    try {
      final String jsonString = await rootBundle.loadString(jsonPath);
      final List<dynamic> data = json.decode(jsonString);
      setState(() {
        chakraData = data;
      });
    } catch (e) {
      developer.log('Error loading JSON: $e'); // Log any errors
    }
  }

  @override
  Widget build(BuildContext context) {
    if (chakraData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      children: chakraData.map((item) {
        Map<String, Map<String, dynamic>> yogasanaMap =
            {}; // Default empty map
        if (item['yogasana'] != null &&
            item['yogasana'] is Map<String, dynamic>) {
          try {
            Map<String, dynamic> rawYogasana = item['yogasana'];
            yogasanaMap = rawYogasana.cast<String, Map<String, dynamic>>();
          } catch (e) {
            developer.log('Error casting yogasana for ${item['name']}: $e');
          }
        }

        return ChakraList(
          name: item['name'] as String? ?? 'Unknown',
          image: item['image'] as String? ?? '',
          color: item['color'] as String? ?? '',
          element: item['element'] as String? ?? '',
          location: item['location'] as String? ?? '',
          function: item['function'] as String? ?? '',
          mantra: item['mantra'] as String? ?? '',
          yogasana: yogasanaMap, // Now safely passed
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
  final Map<String, Map<String, dynamic>> yogasana;

  const ChakraList({
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
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: GlassEffect(
        radius: 20,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return ItemDetailInfo(
                    name: name,
                    image: image,
                    color: color,
                    element: element,
                    location: location,
                    function: function,
                    mantra: mantra,
                    yogasana: yogasana,
                  );
                },
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  width: 1,
                  color: getChakraColor(color).withValues(alpha: 0.5)),
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        getChakraColor(color).withValues(alpha: 0.1),
                        Colors.black.withValues(alpha: 0.2),
                      ]
                    : [
                        getChakraColor(color).withValues(alpha: 0.1),
                        Colors.white.withValues(alpha: 0.5),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Hero(
                  tag: name,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: getChakraColor(color)
                              .withValues(alpha: 0.6),
                          blurRadius: 15,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: theme.scaffoldBackgroundColor,
                      backgroundImage: AssetImage(image),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Element: $element",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color
                              ?.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: theme.iconTheme.color?.withOpacity(0.5),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}