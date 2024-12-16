import 'package:flutter/material.dart';
import 'models/Dog.dart';

class DogDetailScreen extends StatelessWidget {
  final Dog dog;

  DogDetailScreen({required this.dog});

  @override
  Widget build(BuildContext context) {
    // Vérifiez que l'URL est correctement formée
    String imageUrl = dog.imageUrl.isNotEmpty
        ? "http://192.168.120.125:3000${dog.imageUrl}"
        : '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          dog.name.isNotEmpty ? dog.name : "Unknown Dog",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section de l'image du chien
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.blue.shade50,
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl, // Utilisation de l'URL complète
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        }
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(Icons.broken_image,
                              size: 100, color: Colors.grey),
                        );
                      },
                    )
                  : Center(
                      child: Icon(Icons.image, size: 100, color: Colors.grey),
                    ),
            ),
            SizedBox(height: 16),

            // Section des détails du chien
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre du chien
                  Text(
                    dog.name.isNotEmpty ? dog.name : "Unknown Dog",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  // Détails principaux (âge, sexe, couleur)
                  Text(
                    '${dog.age} yrs | ${dog.gender}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    dog.color.isNotEmpty ? dog.color : "Unknown",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                  SizedBox(height: 16),

                  // Section "About Me"
                  Text(
                    'About Me',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    dog.description.isNotEmpty
                        ? dog.description
                        : "No description available.",
                    style: TextStyle(color: Colors.grey.shade600, height: 1.5),
                  ),
                  SizedBox(height: 16),

                  // Section Quick Info (Age, Weight, Color)
                  InfoRow(title: "Age", value: "${dog.age} yrs"),
                  InfoRow(
                      title: "Color",
                      value: dog.color.isNotEmpty ? dog.color : "Unknown"),
                  InfoRow(title: "Weight", value: "${dog.weight} kg"),
                ],
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// Widget pour afficher chaque information dans une ligne
class InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const InfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}
