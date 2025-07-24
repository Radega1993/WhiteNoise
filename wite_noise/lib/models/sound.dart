class Sound {
  final String id;
  final String name;
  final String imagePath;
  final String audioPath;
  final String category;
  final double defaultVolume;
  final bool isLooping;

  Sound({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.audioPath,
    required this.category,
    this.defaultVolume = 0.5,
    this.isLooping = true,
  });

  Sound copyWith({
    String? id,
    String? name,
    String? imagePath,
    String? audioPath,
    String? category,
    double? defaultVolume,
    bool? isLooping,
  }) {
    return Sound(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      audioPath: audioPath ?? this.audioPath,
      category: category ?? this.category,
      defaultVolume: defaultVolume ?? this.defaultVolume,
      isLooping: isLooping ?? this.isLooping,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'audioPath': audioPath,
      'category': category,
      'defaultVolume': defaultVolume,
      'isLooping': isLooping,
    };
  }

  factory Sound.fromJson(Map<String, dynamic> json) {
    return Sound(
      id: json['id'],
      name: json['name'],
      imagePath: json['imagePath'],
      audioPath: json['audioPath'],
      category: json['category'],
      defaultVolume: json['defaultVolume']?.toDouble() ?? 0.5,
      isLooping: json['isLooping'] ?? true,
    );
  }
} 