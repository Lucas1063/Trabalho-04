const app = require('./app');
const PORTA = 3000;

app.listen(PORTA, () => {
  console.log(`Servidor do Unify rodando na porta ${PORTA}...`);
});