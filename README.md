 Projeto implementa um pipeline completo de MLOps para classificação de imagens médicas de tomografia computadorizada de tórax, distinguindo entre casos normais e adenocarcinoma. O sistema utiliza arquitetura de microserviços em Kubernetes com automação CI/CD e escalabilidade automática.


graph TB
    A[GitHub Repository] --> B[Jenkins CI/CD]
    B --> C[Docker Build]
    C --> D[AWS ECR]
    D --> E[EKS Cluster]
    E --> F[Load Balancer]
    F --> G[Auto Scaling Pods]
    H[DVC Pipeline] --> I[Model Training]
    I --> J[Model Artifacts]
    J --> E

Stack Tecnológica:

Machine Learning & Data

TensorFlow/Keras: Deep Learning framework
DVC (Data Version Control): Pipeline de dados e versionamento
Python 3.10: Linguagem principal
OpenCV: Processamento de imagens

MLOps & Infrastructure

Docker: Containerização da aplicação
Kubernetes (EKS): Orquestração de containers
AWS ECR: Registro de containers
CloudFormation: Infrastructure as Code
Jenkins: CI/CD automation
GitHub Actions: Integração e triggers

Deployment & Scaling

AWS Application Load Balancer: Distribuição de tráfego
Horizontal Pod Autoscaler: Escalabilidade automática
Metrics Server: Monitoramento de recursos
Rolling Updates: Deploy sem downtime