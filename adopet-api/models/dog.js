const mongoose = require('mongoose');

// Définir le schéma pour un chien
const dogSchema = new mongoose.Schema({
  name: { type: String, required: true },
  breed: { type: String, required: true },
  age: { type: Number, required: true },
  gender: { type: String, required: true },
  color: { type: String, required: true },
  weight: { type: Number, required: true },
  rating: { type: Number, required: true },
  description: { type: String, required: true },
  imageUrl: { type: String, required: true },
  like: { type: Number, default: 0 },    // Ajout du champ like avec valeur par défaut
  dislike: { type: Number, default: 0 },  // Ajout du champ dislike avec valeur par défaut
});

// Créer un modèle basé sur ce schéma
const Dog = mongoose.model('Dog', dogSchema);

module.exports = Dog;
