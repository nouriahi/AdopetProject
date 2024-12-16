import 'package:flutter/material.dart';
import 'DogService.dart';
import 'DogDetailScreen.dart';
import 'AddDogScreen.dart';
import 'EditDogScreen.dart';
import 'models/Dog.dart';

class DogListScreen extends StatefulWidget {
  @override
  _DogListScreenState createState() => _DogListScreenState();
}

class _DogListScreenState extends State<DogListScreen> {
  late Future<List<Dog>> futureDogs;
  List<Dog> dogs = []; // Stocke les données des chiens localement
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDogs();
  }

  // Méthode pour charger la liste des chiens depuis le backend
  void fetchDogs() async {
    try {
      final fetchedDogs = await DogService.fetchDogs();
      setState(() {
        dogs = fetchedDogs;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch dogs: $error')),
      );
    }
  }

  // Méthode pour mettre à jour un chien dans la liste localement
  void _updateDogList(Dog updatedDog) {
    setState(() {
      final index = dogs.indexWhere((dog) => dog.id == updatedDog.id);
      if (index != -1) {
        dogs[index] = updatedDog;
      }
    });
  }

  // Méthode pour gérer l'ajout de likes
  void _updateLikes(String dogId, int index) async {
    try {
      // Envoi de la mise à jour à l'API
      await DogService.updateLikes(dogId, dogs[index].like + 1);

      // Mise à jour locale
      setState(() {
        dogs[index].like++; // Mise à jour locale du like
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update likes: $error')),
      );
    }
  }

  // Méthode pour gérer l'ajout de dislikes
  void _updateDislikes(String dogId, int index) async {
    try {
      // Envoi de la mise à jour à l'API
      await DogService.updateDislikes(dogId, dogs[index].dislike + 1);

      // Mise à jour locale
      setState(() {
        dogs[index].dislike++; // Mise à jour locale du dislike
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update dislikes: $error')),
      );
    }
  }

  // Méthode pour supprimer un chien
  void _deleteDog(String id) async {
    try {
      await DogService.deleteDog(id);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Dog deleted successfully!')));
      setState(() {
        dogs.removeWhere((dog) => dog.id == id);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete dog: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adopet'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddDogScreen()),
              ).then((_) => fetchDogs()); // Recharger la liste après ajout
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : dogs.isEmpty
              ? Center(child: Text('No dogs available'))
              : ListView.builder(
                  itemCount: dogs.length,
                  itemBuilder: (context, index) {
                    final dog = dogs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(dog.imageUrl),
                            onBackgroundImageError: (_, __) {
                              print(
                                  "Erreur lors du chargement de l'image : ${dog.imageUrl}");
                            },
                          ),
                          title: Text(
                            dog.name,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${dog.age} yrs | ${dog.gender}',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.thumb_up,
                                    color:
                                        const Color.fromARGB(255, 11, 153, 3)),
                                onPressed: () => _updateLikes(dog.id, index),
                              ),
                              Text('${dog.like}',
                                  style: TextStyle(fontSize: 16)),
                              IconButton(
                                icon: Icon(Icons.thumb_down, color: Colors.red),
                                onPressed: () => _updateDislikes(dog.id, index),
                              ),
                              Text('${dog.dislike}',
                                  style: TextStyle(fontSize: 16)),
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () async {
                                  // Naviguer vers EditDogScreen et mettre à jour la liste après modification
                                  final updatedDog = await Navigator.push<Dog>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditDogScreen(dog: dog),
                                    ),
                                  );

                                  if (updatedDog != null) {
                                    _updateDogList(
                                        updatedDog); // Mise à jour locale
                                  }
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _deleteDog(dog.id);
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DogDetailScreen(dog: dog),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
