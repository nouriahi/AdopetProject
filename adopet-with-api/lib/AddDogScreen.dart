import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AddDogScreen extends StatefulWidget {
  @override
  _AddDogScreenState createState() => _AddDogScreenState();
}

class _AddDogScreenState extends State<AddDogScreen> {
  // Contrôleurs pour les champs du formulaire
  final TextEditingController nameController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  // URL de base de l'API
  final String baseUrl =
      'http://192.168.120.125:3000/api'; // Remplacez par votre URL

  // Fonction pour ajouter un chien
  Future<void> addDog(Map<String, dynamic> dogData) async {
    var dio = Dio();
    dio.options.headers = {
      'Content-Type': 'application/json',
    };

    try {
      print("Envoi des données: ${dogData.toString()}");
      Response response = await dio.post(
        '$baseUrl/dogs',
        data: dogData,
      );

      if (response.statusCode == 200) {
        print("Chien ajouté avec succès !");
      } else {
        print("Erreur lors de l'ajout du chien : ${response.statusCode}");
        print("Réponse du serveur : ${response.data}");
        throw Exception("Failed to add dog");
      }
    } catch (e) {
      print("Erreur : $e");
      throw Exception("Erreur lors de l'ajout du chien : $e");
    }
  }

  // Fonction pour soumettre le formulaire
  void _submitForm() {
    if (nameController.text.isEmpty ||
        breedController.text.isEmpty ||
        ageController.text.isEmpty ||
        genderController.text.isEmpty ||
        colorController.text.isEmpty ||
        weightController.text.isEmpty ||
        ratingController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        imageUrlController.text.isEmpty) {
      // Afficher un message d'erreur si certains champs sont vides
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please fill in all fields!')));
      return;
    }

    // Créer un map avec les données du chien
    final dogData = {
      "name": nameController.text,
      "breed": breedController.text,
      "age": double.tryParse(ageController.text) ?? 0.0,
      "gender": genderController.text,
      "color": colorController.text,
      "weight": double.tryParse(weightController.text) ?? 0.0,
      "rating": double.tryParse(ratingController.text) ?? 0.0,
      "description": descriptionController.text,
      "imageUrl": imageUrlController.text,
    };

    // Appeler la fonction addDog pour envoyer les données au backend
    addDog(dogData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Dog'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Formulaire d'ajout de chien
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: breedController,
                decoration: InputDecoration(labelText: 'Breed'),
              ),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Age'),
              ),
              TextField(
                controller: genderController,
                decoration: InputDecoration(labelText: 'Gender'),
              ),
              TextField(
                controller: colorController,
                decoration: InputDecoration(labelText: 'Color'),
              ),
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Weight'),
              ),
              TextField(
                controller: ratingController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Rating'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Dog'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
