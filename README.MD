Markdown
# 🎵 Unify - API de Streaming de Música

Este repositório contém o projeto prático e a infraestrutura automatizada do **Unify**, uma API RESTful de streaming de música desenvolvida como avaliação conclusiva para a disciplina de **Cloud Computing** do curso de Bacharelado em Sistemas de Informação do **Centro Universitário para o Desenvolvimento do Alto Vale do Itajaí (UNIDAVI)**.

O objetivo deste projeto é demonstrar a implementação de um fluxo **DevOps completo**, integrando desenvolvimento de software, testes automatizados, Integração Contínua (CI), Infraestrutura como Código (IaC) e automação de deploy em ambiente de nuvem (**Amazon Web Services - AWS**).

---

## 🚀 Visão Geral do Fluxo DevOps

O projeto está estruturado em 4 etapas sequenciais e integradas:

1. **Desenvolvimento & Testes (Etapa 1):** API REST construída em Node.js (Express) com banco de dados simulado (`data.json`) contendo um catálogo de 10 músicas. Garantia de qualidade por meio de testes unitários com Jest e Supertest.
2. **Integração Contínua (Etapa 2):** Automação de testes a cada *push* utilizando o **GitHub Actions**, incluindo a geração automática de relatórios de cobertura de código (*code coverage*).
3. **Infraestrutura como Código (Etapa 3):** Provisionamento declarativo, seguro e idêntico de uma infraestrutura de rede e computação na nuvem AWS utilizando o **Terraform**.
4. **Deploy Automatizado (Etapa 4):** Gerenciamento de configuração e implantação automatizada na instância EC2 através de playbooks do **Ansible**, com resiliência garantida pelo gerenciador de processos **PM2**.

---

## 🛠️ Tecnologias e Ferramentas Utilizadas

* **Runtime:** Node.js (v18+)
* **Framework Web:** Express.js
* **Framework de Testes:** Jest & Supertest
* **Esteira de CI/CD:** GitHub Actions
* **Ferramenta de IaC:** Terraform (v1.5+)
* **Automação de Configuração:** Ansible (v2.10+)
* **Gerenciador de Processos:** PM2 (Process Manager 2)
* **Provedor de Nuvem:** Amazon Web Services (AWS)
* **Sistema Operacional Alvo:** Ubuntu Server 22.04 LTS

---

## 📂 Estrutura de Diretórios Recomendada

O repositório está organizado de forma a separar claramente a aplicação, a esteira de CI, os scripts de infraestrutura e os arquivos de provisionamento de software:

text
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

---

📦 Etapa 1: Execução Local & Testes Unitários
Pré-requisitos
Antes de iniciar, certifique-se de ter instalado em sua máquina local:

Node.js (Versão 18 LTS ou superior recomendada)

Gerenciador de pacotes NPM (instalado nativamente junto com o Node)

1. Instalação de Dependências
Clone este repositório para sua máquina local, acesse o diretório raiz e instale as bibliotecas necessárias:

Bash
git clone https://github.com/Lucas1063/Trabalho-04.git
cd api-unify-streaming
npm install
2. Executando a API Localmente
Para iniciar o servidor HTTP localmente na porta 3000, utilize o comando:

Bash
node server.js
Você verá a confirmação no terminal: Servidor do Unify rodando na porta 3000...

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

Bash
npm test
A suíte validará quatro cenários cruciais:

Retorno de sucesso (HTTP 200) na rota de listagem.

Integridade estrutural do JSON retornado (presença das chaves id, titulo e artista).

Tratamento de exceção com retorno HTTP 404 para músicas inexistentes no catálogo.

Validação autoral focado na rota /status para garantir monitoramento contínuo.

🤖 Etapa 2: Integração Contínua (CI)
A automação de CI está configurada no arquivo .github/workflows/ci.yml. Sempre que um comando git push é efetuado nas ramificações principais (main ou master), o GitHub Actions aciona um runner baseado em Ubuntu Linux que executa os seguintes passos:

Realiza o Checkout do código fonte.

Configura o ambiente isolado com Node.js 18.

Executa a instalação limpa das dependências através do npm install.

Dispara a suíte de testes unitários com o npm test.

Etapa Adicional: Executa o comando npx jest --coverage para mapear e documentar o percentual de linhas de código que estão efetivamente cobertas pelos testes, gerando relatórios de qualidade no console do runner.

📐 Etapa 3: Infraestrutura como Código (Terraform)
A pasta /terraform abstrai e provisiona toda a topologia de rede e computação necessária na AWS de forma automatizada.

Recursos Provisionados:
VPC: Rede privada virtual isolada utilizando o bloco CIDR 10.0.0.0/16.

Subnet Pública: Sub-rede com IPs públicos automáticos mapeada na AZ us-east-1a.

Internet Gateway (IGW) & Route Table: Configuração de tabelas e gateways de roteamento para garantir saída e entrada de tráfego para a internet global.

Security Group: Atua como firewall na camada da instância, liberando estritamente a porta 22 (SSH para gerenciamento do Ansible) e a porta 3000 (Exposição externa da API Unify).

KeyPair: Injeção da chave pública RSA criada localmente para gerenciar o acesso SSH seguro.

Instância EC2: Servidor virtual t2.micro utilizando uma AMI oficial do Ubuntu Server 22.04 LTS.

Como Provisionar:
Certifique-se de que suas credenciais da AWS estejam configuradas via CLI local (aws configure). Nenhuma chave deve ser escrita nos arquivos .tf.

Gere o par de chaves SSH na raiz do projeto antes de iniciar:

Bash
ssh-keygen -t rsa -b 2048 -f unify_key
Navegue até a pasta e execute os comandos de ciclo de vida do Terraform:

Bash
cd terraform
terraform init    # Inicializa os plugins dos provedores
terraform plan    # Exibe o plano descritivo dos recursos a serem criados
terraform apply   # Cria efetivamente a infraestrutura na nuvem da AWS (digite 'yes')
Ao finalizar o processo, o Terraform exibirá no terminal o output ec2_public_ip contendo o IP público gerado para a instância EC2.

🎭 Etapa 4: Configuração & Deploy Automatizado (Ansible)
A configuração interna do servidor e a publicação da API Unify ocorrem de forma 100% automatizada e idempotente na pasta /ansible.

O que o Playbook executa:
Atualiza os repositórios APT e o cache de pacotes do sistema operacional Ubuntu.

Instala as dependências de runtime nativas: nodejs, npm e git.

Instala globalmente o gerenciador de processos PM2.

Realiza o clone/pull do repositório da API diretamente no diretório de execução /home/ubuntu/api_unify.

Executa o npm install no servidor de produção para configurar a API.

Gerencia de forma idempotente a inicialização e o reinício do processo no PM2 sob o escopo "unify-api".

Resiliência: Configura o acoplamento do PM2 ao gerenciador de inicialização do sistema (systemd), salvando o estado atual para que, em caso de reinicialização completa ou queda da instância EC2, a API inicie de forma autônoma sem intervenção manual humana.

Como Executar o Deploy:
Acesse a pasta /ansible.

Abra o arquivo inventory.ini e substitua o IP genérico pelo IP público real retornado no output do Terraform.

Certifique-se de que o caminho apontado para a chave SSH privada (../unify_key) está correto.

Execute o playbook:

Bash
ansible-playbook -i inventory.ini playbook.yml
Ao concluir com sucesso, valide a API rodando na nuvem acessando pelo navegador:
http://IP_PUBLICO_DA_EC2:3000/musicas