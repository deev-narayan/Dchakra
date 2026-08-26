// Typed models for chakra JSON in assets/data/list_chakra_details.json

class YogaPose {
  final String name;
  final String image;
  final List<String> steps;

  const YogaPose({
    required this.name,
    required this.image,
    required this.steps,
  });

  factory YogaPose.fromMap(String name, Map<String, dynamic> map) {
    final rawSteps = map['steps'];
    return YogaPose(
      name: name,
      image: map['image'] as String? ?? '',
      steps: rawSteps is List
          ? rawSteps.map((e) => e.toString()).toList()
          : const [],
    );
  }
}

class Chakra {
  final String name;
  final String color;
  final String element;
  final String location;
  final String function;
  final String mantra;
  final String image;
  final String lottie;
  final String music;
  final List<YogaPose> poses;

  const Chakra({
    required this.name,
    required this.color,
    required this.element,
    required this.location,
    required this.function,
    required this.mantra,
    required this.image,
    required this.lottie,
    required this.music,
    required this.poses,
  });

  factory Chakra.fromJson(Map<String, dynamic> json) {
    final rawYogasana = json['yogasana'];
    final poses = <YogaPose>[];

    if (rawYogasana is Map<String, dynamic>) {
      for (final entry in rawYogasana.entries) {
        if (entry.value is Map<String, dynamic>) {
          poses.add(
            YogaPose.fromMap(entry.key, entry.value as Map<String, dynamic>),
          );
        }
      }
    }

    return Chakra(
      name: json['name'] as String? ?? 'Unknown',
      color: json['color'] as String? ?? '',
      element: json['element'] as String? ?? '',
      location: json['location'] as String? ?? '',
      function: json['function'] as String? ?? '',
      mantra: json['mantra'] as String? ?? '',
      image: json['image'] as String? ?? '',
      lottie: json['lottie'] as String? ?? '',
      music: json['music'] as String? ?? '',
      poses: poses,
    );
  }

  /// Shape expected by the yoga session page (pose name → image/steps).
  Map<String, Map<String, dynamic>> get yogasanaMap {
    return {
      for (final pose in poses)
        pose.name: {
          'image': pose.image,
          'steps': pose.steps,
        },
    };
  }
}
