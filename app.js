const express = require('express');
const fs = require('fs');
const app = express();

app.use(express.json());


const rawData = fs.readFileSync('data.json');
const musicas = JSON.parse(rawData);


app.get('/status', (req, res) => {
  res.status(200).json({ 
    servico: "Unify Streaming API", 
    status: "online", 
    versao: "1.0.0" 
  });
});


app.get('/musicas', (req, res) => {
  res.status(200).json(musicas);
});


app.get('/musicas/:id', (req, res) => {
  const idBuscado = parseInt(req.params.id);
  const musica = musicas.find(m => m.id === idBuscado);
  
  if (!musica) {
    return res.status(404).json({ erro: "Música não encontrada no catálogo do Unify" });
  }
  
  res.status(200).json(musica);
});


module.exports = app;