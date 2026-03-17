<div align="center">

# 🚀 DevOps Test Project

[![Python](https://img.shields.io/badge/Python-3.11-3776AB?style=flat-square&logo=python&logoColor=white)](https://www.python.org/)
[![Flask](https://img.shields.io/badge/Flask-2.x-000000?style=flat-square&logo=flask&logoColor=white)](https://flask.palletsprojects.com/)
[![Docker](https://img.shields.io/badge/Docker-Containerized-2496ED?style=flat-square&logo=docker&logoColor=white)](https://www.docker.com/)
[![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?style=flat-square&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-CI%2FCD-2088FF?style=flat-square&logo=github-actions&logoColor=white)](https://github.com/features/actions)
[![Prometheus](https://img.shields.io/badge/Prometheus-Metrics-E6522C?style=flat-square&logo=prometheus&logoColor=white)](https://prometheus.io/)

<p align="center">
  <strong>Demonstração completa de práticas modernas de DevOps</strong><br/>
  Containerização · Infraestrutura como Código · CI/CD · Observabilidade
</p>

</div>

---

## 📋 Índice

- [Visão Geral](#-visão-geral)
- [Execução Rápida](#-execução-rápida)
- [Arquitetura](#-arquitetura)
- [Aplicação & Endpoints](#-aplicação--endpoints)
- [Observabilidade](#-observabilidade)
- [Containerização](#-containerização)
- [Infraestrutura como Código (Terraform)](#-infraestrutura-como-código-terraform)
- [Pipeline CI/CD](#-pipeline-cicd)
- [Segurança](#-segurança)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Tecnologias Utilizadas](#-tecnologias-utilizadas)

---

## 🔭 Visão Geral

Este repositório demonstra um fluxo completo de práticas DevOps modernas, indo do código até o ambiente de execução com automação total. O objetivo é implantar uma API Python simples com Flask, seguindo boas práticas de engenharia de infraestrutura.

**O que está incluído:**

- ⚙️ Aplicação Python com Flask
- 🐳 Containerização com Docker (boas práticas de segurança)
- 🏗️ Infraestrutura como Código com Terraform + Provider Docker
- 🔄 Pipeline CI/CD automatizado via GitHub Actions
- 📊 Observabilidade com health checks, métricas Prometheus e logs estruturados

NOTA: Os runners do GitHub Actions são ambientes efêmeros e isolados, portanto, o aplicativo não é acessível externamente. Para acesso via navegador, seria necessário um ambiente de produção real.
O resultado positivo do teste é demonstrado na chamada http://localhost:8080 no momento da execução da pipeline.

---

## Execução Rápida

```bash
git clone <repo>
cd terraform
terraform init
terraform apply

curl localhost:8080
```

---

## 🏛️ Arquitetura

O fluxo de deploy segue o seguinte modelo:

```
Push do Desenvolvedor
        │
        ▼
  Repositório GitHub
        │
        ▼
  GitHub Actions Pipeline
        │
        ├── Checkout do código
        ├── Build da imagem Docker
        ├── Criação de Container de Teste
        ├── Chamada na aplicação para validação
        ├── Remoção do Container de Teste
        ├── Setup Terraform
        ├── Terraform Init
        └── Terraform Apply
                │
                ▼
        Validação da aplicação provisionada pelo Terraform
                │
                ▼
        Aplicação Flask em execução 🚀
```

---

## 🌐 Aplicação & Endpoints

API simples desenvolvida com **Flask**, expondo os seguintes endpoints:

### `GET /` — Endpoint Principal

```json
{
  "message": "DevOps Test Running"
}
```

### `GET /health` — Health Check (Liveness)

Verifica se o **processo da aplicação está ativo**. Utilizado por orquestradores como Kubernetes para determinar se o container precisa ser reiniciado.

```json
{
  "status": "alive"
}
```

### `GET /ready` — Readiness Check

Indica se a aplicação está **pronta para receber tráfego**. Utilizado por balanceadores de carga e Kubernetes para controlar o roteamento de requisições.

```json
{
  "status": "ready"
}
```

> 💡 O padrão Liveness + Readiness é amplamente adotado em ambientes Kubernetes e cloud-native.

### `GET /metrics` — Métricas Prometheus

Expõe métricas no formato compatível com Prometheus:

```
http_requests_total{endpoint="/",method="GET"} 1.0
```

Compatível com ferramentas como **Prometheus**, **Grafana**, **Datadog** e **NewRelic**.

---

## 📡 Observabilidade

Este projeto implementa fundamentos de observabilidade alinhados com práticas modernas:

### 1. Logs Estruturados

As requisições são registradas em **formato JSON**, facilitando a integração com plataformas de log centralizado:

```json
{
  "timestamp": "2026-03-16T18:30:12",
  "level": "INFO",
  "method": "GET",
  "endpoint": "/health",
  "status": 200,
  "remote_addr": "172.17.0.1"
}
```

Compatível com: **ELK / Elastic Stack**, **Grafana Loki**, **Datadog**, plataformas de cloud logging (AWS CloudWatch, GCP Logging, etc.)

### 2. Métricas

Métricas Prometheus expostas via `/metrics`, permitindo monitoramento de:

- Volume de requisições por endpoint e método HTTP
- Comportamento e performance do serviço
- Latência das requisições por endpoint e método HTTP (Histogram)

### 3. Health Checks

| Endpoint  | Finalidade                                        |
|-----------|---------------------------------------------------|
| `/health` | Verifica se o **processo está vivo** (Liveness)   |
| `/ready`  | Verifica se a aplicação está **pronta** (Readiness)|

---

## 🐳 Containerização

A aplicação é empacotada em um **container Docker** seguindo boas práticas de segurança:

| Prática                         | Descrição                                          |
|---------------------------------|----------------------------------------------------|
| ✅ Imagem base mínima            | `python:3.11-slim` para reduzir superfície de ataque |
| ✅ `.dockerignore`               | Exclusão de arquivos desnecessários da imagem      |
| ✅ Healthcheck do container      | Verificação automática de saúde                    |
| ✅ Usuário não-root              | Execução sem privilégios elevados                  |

### Build e execução

```bash
# Build da imagem
docker build -t devops-test .

# Executar o container
docker run -p 8080:8080 devops-test
```

Acesse a aplicação em: **http://localhost:8080**

---

## 🏗️ Infraestrutura como Código (Terraform)

A infraestrutura é provisionada com **Terraform** usando o provider Docker. O Terraform é responsável por:

- Construir a imagem Docker
- Criar e configurar o container
- Expor a porta da aplicação

### Executar o Terraform

```bash
cd terraform
terraform init
terraform apply
```

Após o deploy, verifique a aplicação:

```bash
curl localhost:8080
# Resposta esperada: {"message": "DevOps Test Running"}
```

### Gerenciamento do State

> ⚠️ Em ambientes de **produção**, o `terraform.tfstate` **não deve ser armazenado localmente**. Utilize um backend remoto:

| Provider       | Serviço                     |
|----------------|-----------------------------|
| AWS            | S3                          |
| Azure          | Azure Storage               |
| Google Cloud   | GCS                         |
| HashiCorp      | Terraform Cloud             |

**Exemplo com AWS S3:**

```hcl
terraform {
  backend "s3" {
    bucket = "terraform-state-devops-test"
    key    = "devops-test/terraform.tfstate"
    region = "us-east-1"
  }
}
```

> ℹ️ Neste projeto, o state local foi utilizado para simplificar a execução do teste.

---

## 🔄 Pipeline CI/CD

A pipeline poderá ser executada via **GitHub Actions**, acionada automaticamente a cada push na branch `main`, ou manualmente sem a necessidade de novo commit.

### Etapas do Pipeline

```
1. Checkout do repositório
2. Build da Imagem
3. Verificação de saúde da aplicação
4. Terraform Init
5. Terraform Plan
6. Terraform Apply
```

---

## 🔒 Segurança

O container segue as seguintes boas práticas de segurança:

- **Usuário não-root**: a aplicação é executada com um usuário sem privilégios, reduzindo o impacto de uma possível exploração.
- **Imagem base mínima**: `python:3.11-slim` reduz drasticamente a quantidade de pacotes e binários disponíveis no container.
- **`.dockerignore`**: evita que arquivos sensíveis (chaves, `.env`, artefatos de build) sejam copiados para dentro da imagem.

Essas práticas combinadas **reduzem a superfície de ataque** da aplicação containerizada.

---

## 📁 Estrutura do Projeto

```
devops-test/
│
├── app/
│   ├── app.py                  # Aplicação Flask
│   └── requirements.txt        # Dependências Python
│
├── terraform/
│   └── main.tf                 # Infraestrutura como código
│
├── .github/
│   └── workflows/
│       └── pipeline.yml        # Pipeline CI/CD
│
├── Dockerfile                  # Definição do container
├── .dockerignore               # Exclusões do build Docker
└── README.md
```

---

## 🛠️ Tecnologias Utilizadas

| Tecnologia        | Versão / Detalhes          | Finalidade                         |
|-------------------|----------------------------|------------------------------------|
| Python            | 3.11                       | Linguagem da aplicação             |
| Flask             | 3.x                        | Framework web                      |
| Docker            | Imagem `python:3.11-slim`  | Containerização                    |
| Terraform         | Provider Docker            | Infraestrutura como código         |
| GitHub Actions    | —                          | CI/CD                              |
| Prometheus Client | —                          | Exposição de métricas              |

---

<div align="center">

**Este projeto demonstra um ciclo completo de DevOps moderno:**
containerização · infraestrutura como código · CI/CD automatizado · observabilidade · segurança de containers

</div>
