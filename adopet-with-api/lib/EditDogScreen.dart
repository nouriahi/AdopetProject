import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// ignore: unused_import
import 'package:dio/dio.dart';
import 'models/Dog.dart';
import 'DogService.dart';

class EditDogScreen extends StatefulWidget {
  final Dog dog;

  EditDogScreen({required this.dog});

  @override
  _EditDogScreenState createState() => _EditDogScreenState();
}

class _EditDogScreenState extends State<EditDogScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController genderController;
  late TextEditingController colorController;
  late TextEditingController weightController;
  late TextEditingController descriptionController;
  File? _selectedImageFile;
  bool _isLoading = false;

  final String baseUrl =
      "http://192.168.120.125:3000/api/dogs"; // Remplacez par votre URL de base

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.dog.name);
    ageController = TextEditingController(text: widget.dog.age.toString());
    genderController = TextEditingController(text: widget.dog.gender);
    colorController = TextEditingController(text: widget.dog.color);
    weightController =
        TextEditingController(text: widget.dog.weight.toString());
    descriptionController = TextEditingController(text: widget.dog.description);
  }

  // Sélectionner une image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = File(pickedFile.path);
      });
    }
  }

  // Soumettre le formulaire
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final dogData = {
        "name": nameController.text,
        "age": int.tryParse(ageController.text) ?? 0,
        "gender": genderController.text,
        "color": colorController.text,
        "weight": double.tryParse(weightController.text) ?? 0.0,
        "description": descriptionController.text,
      };

      try {
        await DogService.editDog(
          id: widget.dog.id,
          data: dogData,
          imageFile: _selectedImageFile,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Dog updated successfully!")),
        );

        Navigator.pop(context, true);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update dog: $error")),
        );
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    genderController.dispose();
    colorController.dispose();
    weightController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Dog'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _selectedImageFile != null
                        ? FileImage(_selectedImageFile!)
                        : NetworkImage(widget.dog.imageUrl) as ImageProvider,
                    child: _selectedImageFile == null
                        ? Icon(Icons.camera_alt, size: 40, color: Colors.white)
                        : null,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the dog\'s name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: ageController,
                  decoration: InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the dog\'s age';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: genderController,
                  decoration: InputDecoration(labelText: 'Gender'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the dog\'s gender';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: colorController,
                  decoration: InputDecoration(labelText: 'Color'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the dog\'s color';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: weightController,
                  decoration: InputDecoration(labelText: 'Weight'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the dog\'s weight';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the dog\'s description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
