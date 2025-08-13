FROM python:3.8-slim-bullseye

# Atualizar sistema e instalar dependências
RUN apt-get update -y && \
    apt-get install -y curl wget unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Instalar AWS CLI v2 manualmente (mais estável)
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws/

# Definir diretório de trabalho
WORKDIR /app

# Copiar requirements primeiro (para cache de layers)
COPY requirements.txt /app/

# Instalar dependências Python
RUN pip install --no-cache-dir -r requirements.txt

# Copiar código da aplicação
COPY . /app

# Expor porta
EXPOSE 8080

# Comando para executar a aplicação
CMD ["python3", "app.py"]