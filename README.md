# GitHub Actions Runner em Container (Ubuntu 20.04)

Este repositório contém tudo o que você precisa para rodar um **GitHub Actions Runner** em um container Docker baseado no **Ubuntu 20.04**.  
O container está pré-configurado com várias dependências úteis como Python, Git, SQL Server (sqlcmd), PowerShell e outras bibliotecas.

> Ideal para quem deseja executar workflows do GitHub Actions em ambiente self-hosted, com fácil deploy via Docker Compose.

---

## Como funciona?

Este projeto monta uma imagem Docker com o agente de execução do GitHub Actions, que pode ser usado para rodar seus jobs localmente, em servidores privados ou na nuvem, sem depender dos runners hospedados pelo GitHub.

---

## Estrutura do Projeto

- **Dockerfile**: Cria a imagem do runner com todas as dependências instaladas.
- **start.sh**: Script de inicialização que registra o runner no repositório.
- **docker-compose.yml**: Facilita o deploy com as variáveis de ambiente necessárias.

---

## Pré-requisitos

- Docker
- Docker Compose
- Um repositório no GitHub
- Um [token de acesso pessoal (PAT)](https://github.com/settings/tokens) com permissões para registrar runners (`repo`, `admin:repo_hook`)

---

## Configuração

Você pode configurar o runner de duas formas:

### 1. Usando Docker Compose

1. Clone este repositório:

```bash
git clone https://github.com/seu-usuario/github-actions-runner-container.git
cd github-actions-runner-container
```

2. Edite o arquivo `docker-compose.yml` e preencha as variáveis de ambiente:

```yaml
environment:
  - PERSONAL_REPOSITORY=seu-usuario/seu-repositorio
  - PERSONAL_TOKEN=ghp_seutokenaqui
  - RUNNER_NAME=meu-runner
```

3. Suba o serviço com:

```bash
docker-compose up -d
```

---

### 2. Passando variáveis diretamente com Docker CLI

Você também pode construir e rodar a imagem diretamente com:

```bash
docker build -t local/github-runner:latest .
```

E iniciar o container:

```bash
docker run -d \
  --name runner \
  --network host \
  -e PERSONAL_REPOSITORY=seu-usuario/seu-repositorio \
  -e PERSONAL_TOKEN=ghp_seutokenaqui \
  -e RUNNER_NAME=meu-runner \
  local/github-runner:latest
```

---

## Softwares Pré-instalados

* Ubuntu 20.04
* Git
* Python 3, Pip, venv
* SQL Server CLI (sqlcmd)
* PowerShell
* build-essential, libssl-dev, libffi-dev
* curl, jq, etc.

---

## Remover o runner

Se desejar remover o runner do seu repositório:

1. Delete o container:

```bash
docker rm -f runner
```

2. Acesse as configurações do seu repositório no GitHub > Actions > Runners e remova o runner manualmente, caso necessário.

---

## Problemas Comuns

* **Token inválido**: Gere um novo token no GitHub com as permissões corretas.
* **Runner não aparece no GitHub**: Verifique se o container está rodando corretamente e se o repositório está correto.


