const request = require('supertest');
const app = require('./app');

describe('Testes da API - Unify Streaming', () => {
  

  it('Deve retornar HTTP 200 ao buscar todas as músicas', async () => {
    const resposta = await request(app).get('/musicas');
    expect(resposta.statusCode).toEqual(200);
  });

  
  it('Deve retornar uma lista de objetos contendo id, titulo e artista', async () => {
    const resposta = await request(app).get('/musicas');
    expect(Array.isArray(resposta.body)).toBeTruthy();
    

    const primeiraMusica = resposta.body[0];
    expect(primeiraMusica).toHaveProperty('id');
    expect(primeiraMusica).toHaveProperty('titulo');
    expect(primeiraMusica).toHaveProperty('artista');
  });

  it('Deve retornar HTTP 404 ao buscar um ID de música que não existe', async () => {
    const resposta = await request(app).get('/musicas/9999');
    expect(resposta.statusCode).toEqual(404);
    expect(resposta.body.erro).toBe("Música não encontrada no catálogo do Unify");
  });

  it('Deve retornar status online na rota /status', async () => {
    const resposta = await request(app).get('/status');
    expect(resposta.statusCode).toEqual(200);
    expect(resposta.body.status).toBe("online");
    expect(resposta.body.servico).toBe("Unify Streaming API");
  });

});