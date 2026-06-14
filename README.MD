🎵 Unify - API de Streaming de Música
Este repositório contém o projeto prático e a infraestrutura automatizada do Unify, uma API RESTful de streaming de música desenvolvida como avaliação conclusiva para a disciplina de Cloud Computing do curso de Bacharelado em Sistemas de Informação do Centro Universitário para o Desenvolvimento do Alto Vale do Itajaí (UNIDAVI).

O objetivo deste projeto é demonstrar a implementação de um fluxo DevOps completo, integrando desenvolvimento de software, testes automatizados, Integração Contínua (CI), Infraestrutura como Código (IaC) e automação de deploy em ambiente de nuvem (Amazon Web Services - AWS).

🚀 Visão Geral do Fluxo DevOps
O projeto está estruturado em 4 etapas sequenciais e integradas:

Desenvolvimento & Testes (Etapa 1): API REST construída em Node.js (Express) com banco de dados simulado (data.json) contendo um catálogo de 10 músicas. Garantia de qualidade por meio de testes unitários com Jest e Supertest.

Integração Contínua (Etapa 2): Automação de testes a cada push utilizando o GitHub Actions, incluindo a geração automática de relatórios de cobertura de código (code coverage).

Infraestrutura como Código (Etapa 3): Provisionamento declarativo, seguro e idêntico de uma infraestrutura de rede e computação na nuvem AWS utilizando o Terraform.

Deploy Automatizado (Etapa 4): Gerenciamento de configuração e implantação automatizada na instância EC2 através de playbooks do Ansible, com resiliência garantida pelo gerenciador de processos PM2.

🛠️ Tecnologias e Ferramentas Utilizadas
Runtime: Node.js (v18+)

Framework Web: Express.js

Framework de Testes: Jest & Supertest

Esteira de CI/CD: GitHub Actions

Ferramenta de IaC: Terraform (v1.5+)

Automação de Configuração: Ansible (v2.10+)

Gerenciador de Processos: PM2 (Process Manager 2)

Provedor de Nuvem: Amazon Web Services (AWS)

Sistema Operacional Alvo: Ubuntu Server 22.04 LTS

📂 Estrutura de Diretórios Recomendada
O repositório está organizado de forma a separar claramente a aplicação, a esteira de CI, os scripts de infraestrutura e os arquivos de provisionamento de software:

Trabalho-04/
├── .github/
│   └── workflows/
│       └── ci.yml             # Pipeline de Integração Contínua (GitHub Actions)
├── ansible/
│   ├── inventory.ini          # Inventário de servidores alvos (IPs da EC2)
│   └── playbook.yml           # Automação de pacotes, deploy da API e PM2
├── terraform/
│   ├── main.tf                # Definição dos recursos AWS (VPC, SG, EC2, etc.)
│   ├── providers.tf           # Configuração do provedor AWS e versões
│   ├── variables.tf           # Variáveis tipadas e parametrizadas do projeto
│   └── outputs.tf             # Outputs do Terraform (Exposição do IP Público)
├── app.js                     # Configuração de rotas da API Express (Separado para testes)
├── app.test.js                # Arquivo contendo a suíte de 4 testes unitários
├── data.json                  # Banco de dados fictício (Catálogo do Unify com 10 registros)
├── server.js                  # Inicializador do servidor web (Porta 3000)
├── package.json               # Gerenciador de dependências e scripts do Node.js
└── README.md                  # Documentação completa do projeto

📦 Etapa 1: Execução Local & Testes Unitários
Pré-requisitos
Antes de iniciar, certifique-se de ter instalado em sua máquina local:

Node.js (Versão 18 LTS ou superior recomendada)

NPM (Gerenciador de pacotes, instalado nativamente junto com o Node)

1. Instalação de Dependências
Clone este repositório para sua máquina local, acesse o diretório raiz e instale as bibliotecas necessárias:

git clone https://github.com/Lucas1063/Trabalho-04.git
cd Trabalho-04
npm install
2. Executando a API Localmente
Para iniciar o servidor HTTP localmente na porta 3000, utilize o comando:

node server.js
Você verá a seguinte confirmação no terminal: Servidor do Unify rodando na porta 3000...

3. Rotas Disponíveis para Testes
A API disponibiliza três endpoints principais que podem ser validados via navegador ou clientes HTTP (Postman/Insomnia):

Status da API: GET http://localhost:3000/status

Retorno esperado: Código HTTP 200 contendo o status operacional da aplicação e versão.

Listagem do Catálogo: GET http://localhost:3000/musicas

Retorno esperado: Código HTTP 200 listando o array completo com as 10 músicas extraídas do arquivo data.json.

Busca por ID: GET http://localhost:3000/musicas/1

Retorno esperado: Código HTTP 200 retornando os detalhes da música com o respectivo ID numérico. Caso o ID não exista (ex: /musicas/999), a API retornará o Código HTTP 404 acompanhado de uma mensagem descritiva de erro.

4. Executando a Suíte de Testes Unitários
Os testes foram projetados utilizando o Jest e Supertest para simular requisições HTTP sem travar as portas de rede. Para rodar a verificação de qualidade, execute:

npm test
A suíte validará quatro cenários cruciais:

Retorno de sucesso (HTTP 200) na rota de listagem.

Integridade estrutural do JSON retornado (presença das chaves id, titulo e artista).

Tratamento de exceção com retorno HTTP 404 para músicas inexistentes no catálogo.

Validação autoral focada na rota /status para garantir monitoramento contínuo.