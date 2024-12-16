class Dog {
  final String id; // Correspond à '_id' dans Node.js
  final String name; // Correspond à 'name' dans Node.js
  final String breed; // Correspond à 'breed' dans Node.js
  final double age; // Correspond à 'age' dans Node.js
  final String gender; // Correspond à 'gender' dans Node.js
  final String color; // Correspond à 'color' dans Node.js
  final double weight; // Correspond à 'weight' dans Node.js
  final double rating; // Correspond à 'rating' dans Node.js
  final String description; // Correspond à 'description' dans Node.js
  final String imageUrl; // Correspond à 'imageUrl' dans Node.js
  late final int like; // Correspond à 'like' dans Node.js
  late final int dislike; // Correspond à 'dislike' dans Node.js

  Dog({
    required this.id,
    required this.name,
    required this.breed,
    required this.age,
    required this.gender,
    required this.color,
    required this.weight,
    required this.rating,
    required this.description,
    required this.imageUrl,
    this.like = 0,
    this.dislike = 0,
  });

  // Conversion du JSON vers un objet Dart
  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(
      id: json['_id'], // Correspond à '_id' dans Node.js
      name: json['name'],
      breed: json['breed'], // Correspond à 'breed' dans Node.js
      age: json['age']
          .toDouble(), // Assurez-vous que l'âge est un nombre flottant
      gender: json['gender'],
      color: json['color'],
      weight: json['weight']
          .toDouble(), // Assurez-vous que le poids est un nombre flottant
      rating: json['rating']
          .toDouble(), // Assurez-vous que le rating est un nombre flottant
      description:
          json['description'], // Correspond à 'description' dans Node.js
      imageUrl: json['imageUrl'], // Correspond à 'imageUrl' dans Node.js
      like: json['like'] ?? 0, // Si le champ 'like' est nul, on lui assigne 0
      dislike: json['dislike'] ??
          0, // Si le champ 'dislike' est nul, on lui assigne 0
    );
  }

  // Conversion de l'objet Dart vers JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'breed': breed, // Correspond à 'breed' dans Node.js
      'age': age,
      'gender': gender,
      'color': color,
      'weight': weight,
      'rating': rating,
      'description': description, // Correspond à 'description' dans Node.js
      'imageUrl': imageUrl, // Correspond à 'imageUrl' dans Node.js
      'like': like,
      'dislike': dislike,
    };
  }
}
