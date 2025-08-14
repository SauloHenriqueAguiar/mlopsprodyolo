
Pipeline completo de **MLOps** para classificação de imagens médicas de tomografia computadorizada de tórax, distinguindo entre casos normais e adenocarcinoma. O sistema utiliza arquitetura de microserviços em **Kubernetes** com automação **CI/CD** e escalabilidade automática.



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


## Stack Tecnológica:

### Machine Learning & Data:

TensorFlow/Keras: Framework para Deep Learning

DVC (Data Version Control): Versionamento de dados e pipelines

Python 3.10: Linguagem principal do projeto

OpenCV: Pré-processamento de imagens médicas

### MLOps & Infraestrutura:

Docker: Containerização dos componentes

Kubernetes (EKS): Orquestração de containers na AWS

AWS ECR: Registry privado para imagens Docker

CloudFormation: Infraestrutura como código

Jenkins: Automação de pipelines CI/CD

GitHub Actions: Gatilhos e integrações

### Deployment & Escalabilidade:

AWS ALB: Distribuição inteligente de tráfego

Horizontal Pod Autoscaler: Escalamento automático baseado em métricas

Metrics Server: Coleta de métricas de recursos

Rolling Updates: Atualizações contínuas sem downtime
