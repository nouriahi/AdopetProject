const express = require('express');
const Dog = require('../models/dog');
const router = express.Router();


// Route pour obtenir tous les chiens
router.get('/', async (req, res) => {
  try {
    const dogs = await Dog.find();  // Trouver tous les chiens dans la base de données
    res.json(dogs);  // Renvoyer les chiens sous forme de JSON
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

// Route pour obtenir un chien par son ID
router.get('/:id', async (req, res) => {
  try {
    const dog = await Dog.findById(req.params.id);  // Trouver le chien par ID
    if (!dog) return res.status(404).json({ message: 'Dog not found' });  // Si pas de chien, renvoyer une erreur
    res.json(dog);  // Si chien trouvé, renvoyer les données
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

// Route pour ajouter un chien
// Route pour ajouter un chien
router.post('/', async (req, res) => {
  const dog = new Dog({
    name: req.body.name,
    breed: req.body.breed,
    age: req.body.age,
    gender: req.body.gender,
    color: req.body.color,
    weight: req.body.weight,
    rating: req.body.rating,
    description: req.body.description,
    imageUrl: req.body.imageUrl,
    like: req.body.like || 0, // Par défaut 0 si non fourni
    dislike: req.body.dislike || 0, // Par défaut 0 si non fourni
  });

  try {
    const newDog = await dog.save();  // Sauvegarder le chien dans la base de données
    res.status(201).json(newDog);  // Renvoyer le chien créé
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});


// Route pour mettre à jour un chien
router.put('/:id', async (req, res) => {
  try {
    const dog = await Dog.findById(req.params.id);
    if (!dog) return res.status(404).json({ message: 'Dog not found' });

    // Mise à jour des champs
    dog.name = req.body.name || dog.name;
    dog.breed = req.body.breed || dog.breed;
    dog.age = req.body.age || dog.age;
    dog.gender = req.body.gender || dog.gender;
    dog.color = req.body.color || dog.color;
    dog.weight = req.body.weight || dog.weight;
    dog.rating = req.body.rating || dog.rating;
    dog.description = req.body.description || dog.description;
    dog.imageUrl = req.body.imageUrl || dog.imageUrl;
    dog.like = req.body.like || dog.like;
    dog.dislike = req.body.dislike || dog.dislike;

    const updatedDog = await dog.save();  // Mettre à jour le chien dans la base de données
    res.json(updatedDog);  // Renvoyer le chien mis à jour
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});


// Suppression d'un chien par son ID
router.delete("/:id", async (req, res) => {
  const { id } = req.params;

  try {
    // Assurez-vous que l'ID est converti en ObjectId
    const dog = await Dog.findByIdAndDelete(id);

    if (!dog) {
      return res.status(404).json({ message: "Dog not found" });
    }

    res.status(200).json({ message: "Dog deleted successfully" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Error deleting dog" });
  }
});

module.exports = router;
