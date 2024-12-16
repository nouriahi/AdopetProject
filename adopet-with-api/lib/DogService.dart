import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'models/Dog.dart';
import 'package:dio/dio.dart';

class DogService {
  static const String baseUrl = "http://192.168.120.125:3000/api/dogs";

  static Future<List<Dog>> fetchDogs() async {
    final response = await http.get(Uri.parse(baseUrl));
    print(response.body);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Dog.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load dogs");
    }
  }

  static Future<void> addDog(Map<String, dynamic> dogData) async {
    var dio = Dio();

    try {
      Response response = await dio.post(
        '$baseUrl',
        data: dogData,
      );

      if (response.statusCode == 200) {
        print("Dog added successfully!");
      } else {
        print("Failed to add dog. Status code: ${response.statusCode}");
        throw Exception("Failed to add dog");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Failed to add dog: $e");
    }
  }

  static Future<void> editDog({
    required String id,
    required Map<String, dynamic> data,
    File? imageFile,
  }) async {
    var dio = Dio();
    try {
      FormData formData = FormData.fromMap(data);

      if (imageFile != null) {
        formData.files.add(
          MapEntry(
            "image",
            await MultipartFile.fromFile(imageFile.path),
          ),
        );
      }

      final response = await dio.put(
        "$baseUrl/$id",
        data: formData,
      );

      print("Backend response data: ${response.data}");

      if (response.statusCode != 200) {
        throw Exception(
            "Failed to update dog. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in editDog: $e");
      throw Exception("Failed to update dog: $e");
    }
  }

  static Future<void> deleteDog(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete dog");
    }
  }

  // Méthode pour mettre à jour les likes d'un chien
  static Future<void> updateLikes(String dogId, int newLikes) async {
    final url = Uri.parse('$baseUrl/$dogId.likes');
    final response = await http.patch(
      url,
      body: json.encode({'likes': newLikes}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update likes');
    }
  }

  // Méthode pour mettre à jour les dislikes d'un chien
  static Future<void> updateDislikes(String dogId, int newDislikes) async {
    final url = Uri.parse('$baseUrl/$dogId.dislikes');
    final response = await http.patch(
      url,
      body: json.encode({'dislikes': newDislikes}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update dislikes');
    }
  }
}
