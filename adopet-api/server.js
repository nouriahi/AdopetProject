const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bodyParser = require('body-parser');
const dogsRouter = require('./routes/dogs');  // Importer le routeur des chiens

const app = express();
const port = 3000;

// Middleware
app.use(cors());  // Permet les requêtes depuis des domaines différents (CORS)
app.use(bodyParser.json());  // Parse les requêtes JSON

// Connexion à MongoDB
mongoose.connect('mongodb://localhost/adopet', {
  useNewUrlParser: true,
  useUnifiedTopology: true
})
.then(() => console.log('Connected to MongoDB'))
.catch((err) => console.error('Error connecting to MongoDB:', err));

// Utilisation des routes des chiens
app.use('/api/dogs', dogsRouter);

// Lancer le serveur
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
