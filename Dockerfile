FROM ubuntu:20.04

ARG RUNNER_VERSION="2.324.0"
ARG DEBIAN_FRONTEND=noninteractive

# Criar usuário
RUN useradd -m docker

# Atualizar e instalar dependências em uma única camada
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    curl jq git build-essential libssl-dev libffi-dev gnupg \
    python3 python3-venv python3-dev python3-pip \
    wget apt-transport-https software-properties-common \
    ca-certificates && \
    python3 -m pip install --upgrade pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Instalar SQL Server Tools
ENV ACCEPT_EULA=Y
RUN curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc && \
    curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | tee /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && apt-get install -y --no-install-recommends mssql-tools18 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV PATH="$PATH:/opt/mssql-tools18/bin"

# Instalar PowerShell
RUN wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt-get update && apt-get install -y --no-install-recommends powershell && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Baixar e extrair GitHub Actions Runner
WORKDIR /home/docker/actions-runner
RUN curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    rm actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    chown -R docker /home/docker/actions-runner && \
    ./bin/installdependencies.sh

# Copiar script de inicialização
COPY start.sh /home/docker/start.sh
RUN chmod +x /home/docker/start.sh && chown docker /home/docker/start.sh

USER docker
WORKDIR /home/docker/actions-runner
ENTRYPOINT ["../start.sh"]
