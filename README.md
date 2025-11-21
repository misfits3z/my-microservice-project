# 🧩 MY-MICROSERVICE-PROJECT

## 📘 Опис проєкту

Цей Terraform-проєкт автоматизує створення базової інфраструктури AWS для мікросервісного середовища.  
Він включає:

- **S3 backend** — для збереження Terraform state файлу з використанням DynamoDB для блокування.  
- **VPC** — створення власної віртуальної приватної мережі з публічними та приватними підмережами.  
- **ECR** — репозиторій для зберігання Docker-образів сервісів із автоматичним скануванням безпеки.

---

## 📂 Структура проєкту


### 📁 Project Structure

```txt
MY-MICROSERVICE-PROJECT/
│
├── main.tf
├── backend.tf
├── outputs.tf
│
├── modules/
│   ├── s3-backend/
│   │   ├── s3.tf
│   │   ├── dynamodb.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── vpc/
│   │   ├── vpc.tf
│   │   ├── routes.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── ecr/
│   │   ├── ecr.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── eks/
│   │   ├── eks.tf
│   │   ├── aws_ebs_csi_driver.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── rds/
│   │   ├── rds.tf
│   │   ├── aurora.tf
│   │   ├── shared.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── jenkins/
│   │   ├── jenkins.tf
│   │   ├── providers.tf
│   │   ├── variables.tf
│   │   ├── values.yaml
│   │   └── outputs.tf
│   │
│   └── argo_cd/
│       ├── argo_cd.tf
│       ├── providers.tf
│       ├── variables.tf
│       ├── values.yaml
│       ├── outputs.tf
│       └── charts/
│           ├── Chart.yaml
│           ├── values.yaml
│           └── templates/
│               ├── application.yaml
│               └── repository.yaml
│
├── charts/
│   └── django-app/
│       ├── templates/
│       │   ├── deployment.yaml
│       │   ├── service.yaml
│       │   ├── configmap.yaml
│       │   └── hpa.yaml
│       ├── Chart.yaml
│       └── values.yaml
│
└── Django/
    ├── app/
    ├── Dockerfile
    ├── Jenkinsfile
    ├── requirements.txt
    ├── docker-compose.yaml
    └── nginx/
        └── nginx.conf
```



---

## ⚙️ Використання Terraform

Перед запуском переконайтесь, що ви авторизовані в AWS CLI:
```bash
aws configure

1️⃣ Ініціалізація проєкту

terraform init

2️⃣ Перевірка плану розгортання

terraform plan

3️⃣ Застосування конфігурації

terraform apply

4️⃣ Знищення інфраструктури

terraform destroy

🧱 Модулі

🔹 s3-backend

Модуль створює:

S3 bucket для зберігання terraform.tfstate

DynamoDB таблицю для блокування state-файлів (запобігає конфліктам при одночасних оновленнях)

Outputs:

bucket_name — назва S3 бакету

dynamodb_table — назва таблиці DynamoDB

🔹 vpc

Модуль створює:

VPC із визначеним CIDR-блоком

2 публічні та 2 приватні підмережі

Інтернет-шлюз (Internet Gateway)

Таблиці маршрутизації

Outputs:

vpc_id — ідентифікатор створеної VPC

public_subnets — список публічних підмереж

private_subnets — список приватних підмереж

🔹 ecr

Модуль створює:

ECR репозиторій для зберігання Docker-образів

Увімкнене автоматичне сканування образів на вразливості

Політику доступу, що дозволяє push/pull для авторизованих користувачів AWS

Outputs:

repository_url — повна URL-адреса ECR-репозиторію

Приклад підключення модулів у main.tf

module "s3_backend" {
  source = "./modules/s3-backend"
  bucket_name = "my-terraform-state"
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
}

module "ecr" {
  source = "./modules/ecr"
  repository_name = "my-microservice-repo"
}

🔹 Отримання пароля ArgoCD
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 --decode

🔹 Відкрити UI ArgoCD
kubectl -n argocd port-forward svc/argocd-server 8080:80

Як перевірити Jenkins Job
📌 Jenkins встановлюється Terraform-ом через Helm

Адреса Jenkins повертається в terraform output (або через kubectl get svc -n jenkins).

📌 Jenkins Pipeline виконує:

Забирає код з гілки "name"

Checkout гілки "name" (де лежить Dockerfile)

Виконує Kaniko build → створює Docker image

Пушить образ у ECR

Оновлює тег у файлі:

charts/django-app/values.yaml

Комітить і пушить у гілку

Argo CD підхоплює зміни й оновлює кластер

📌 Як перевірити Job

Відкрити Jenkins Dashboard

Знайти Pipelines → натиснути вашу Job

Запустити:

Build Now

Переглянути stages:

Checkout infra

1. Checkout app

2. Login to ECR

3. Build & Push Kaniko image

4. Update Helm chart

5. Commit & Push changes

Після успішного виконання → перевірити, що в репозиторії змінився тег:

charts/django-app/values.yaml

Як побачити результат в Argo CD?

📌 Відкрити UI ArgoCD:

kubectl -n argocd port-forward svc/argocd-server 8080:80

В браузері:

http://localhost:8080

📌 У Dashboard ви побачите Application django-app

Статуси:

* Healthy — деплой успішний

* Synced — кластер оновлений відповідно до Helm chart

* OutOfSync — були зміни в Git, ArgoCD ще не оновив

ArgoCD автоматично:

* застосовує новий Docker image

* оновлює Deployment

* створює або оновлює Service / ConfigMap

* піднімає AWS LoadBalancer


rds

The module allows you to create:

    Aurora Cluster (PostgreSQL or MySQL)
    Regular RDS instance (PostgreSQL or MySQL)

Example of use

module "rds" {
  source = "./modules/rds"

  name       = "myapp-db"
  use_aurora = true

  engine                 = "aurora-postgresql"
  engine_version         = "14.11"
  instance_class         = "db.r6g.large"
  parameter_group_family = "aurora-postgresql14"

  aurora_instance_count = 2

  db_name  = "myapp"
  username = "postgres"
  password = "SuperSecretPass123!"
  port     = 5432

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  allowed_cidr_blocks = [
    "10.0.0.0/16"
  ]

  tags = {
    Environment = "dev"
    Project     = "myapp"
  }
}


============== Prometheus & Grafana =====================

Prometheus & Grafana були налаштовані через Helm, але в тестовому AWS-середовищі з 1 worker-node pod-и залишаються Pending через обмежені ресурси.
У продакшн-оточенні з 2+ нодами вони розгортаються коректно.

✅ Установка Prometheus

kubectl create namespace monitoring
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install prometheus prometheus-community/prometheus \
  -n monitoring

Далі:

kubectl get pods -n monitoring

✅ Установка Grafana

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm install grafana grafana/grafana \
  -n monitoring

Далі:

kubectl get pods -n monitoring

⭐ Grafana логін:

kubectl get secret grafana -n monitoring -o jsonpath="{.data.admin-password}" | base64 --decode

⭐ Port-forward для доступу:

Prometheus:

kubectl port-forward -n monitoring svc/prometheus-server 9090:80

Grafana:

kubectl port-forward -n monitoring svc/grafana 3000:80

