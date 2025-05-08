🔍 Monitoring: Metrics vs. Monitoring
Metrics are data points that measure what’s happening. Examples include:

Steps walked per day

Heart rate

Outside temperature

Monitoring is the continuous process of observing these metrics over time to:

Understand normal behavior

Spot changes

Detect and respond to problems

For example, monitoring your daily step count helps track fitness goals, while keeping an eye on your heart rate ensures it stays healthy.

🚀 Prometheus
Prometheus is an open-source monitoring and alerting toolkit, originally developed by SoundCloud. It is well known for:

📊 Robust data model

🔎 Powerful query language (PromQL)

🚨 Alerting on time-series data

Prometheus supports both bare-metal servers and container environments like Kubernetes.

🏠 Prometheus Architecture
Prometheus features a modular, scalable architecture designed for flexibility. Its core components include:

Prometheus Server: Collects and stores time-series data

Client Libraries: Help applications expose metrics

Push Gateway: For short-lived jobs

Alertmanager: Manages alerts and notifications

Exporters: Collect metrics from third-party systems

Web UI & PromQL: For querying and visualizing data

![Prometheus Architecture](images/prometheus-architecture.gif)

🔥 Prometheus Server
The Prometheus Server is the core of the monitoring system. It:

Scrapes metrics from configured targets

Stores them in its Time Series Database (TSDB)

Serves queries via its HTTP API

Key Components:

Retrieval: Scrapes metrics from endpoints using static configs or dynamic service discovery.

TSDB: Efficiently stores high-volume time-series data.

HTTP Server: Exposes APIs for querying data with PromQL and accessing metadata.

Storage: Persists data locally (HDD/SSD) in a format optimized for time-series data.

🌐 Service Discovery
Service Discovery keeps track of the services Prometheus should monitor, crucial in dynamic environments like Kubernetes.

Key Components:

Kubernetes: Automatically discovers services, pods, and nodes using the Kubernetes API.

File SD: Reads static target configurations from files for more static environments.

📤 Pushgateway
The Pushgateway allows metrics from short-lived jobs or apps that can’t be scraped directly to be collected.

Use Case:
Ideal for batch jobs that run briefly and would otherwise miss metric collection.

🚨 Alertmanager
Alertmanager manages alerts from Prometheus. It handles:

Deduplication

Grouping

Routing to channels like PagerDuty, email, Slack

🧲 Exporters
Exporters collect metrics from third-party systems and expose them in a Prometheus-compatible format.

Common Exporters:

Node Exporter: Hardware metrics

MySQL Exporter: Database metrics

Many other application-specific exporters

🖥️ Prometheus Web UI
The Prometheus Web UI allows you to:

Explore metrics

Run ad-hoc PromQL queries

Visualize results directly

📊 Grafana
Grafana integrates with Prometheus to provide powerful, customizable dashboards and visualizations of your metrics data.

🔌 API Clients
API clients interact with Prometheus via its HTTP API to:

Fetch data

Query metrics

Integrate with other systems

# 🛠️  Installation & Configurations
## 📦 Step 1: Create EKS Cluster

### Prerequisites
- Download and Install AWS Cli - Please Refer [this]("https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html") link.
- Setup and configure AWS CLI using the `aws configure` command.
- Install and configure eksctl using the steps mentioned [here]("https://eksctl.io/installation/").
- Install and configure kubectl as mentioned [here]("https://kubernetes.io/docs/tasks/tools/").


```bash
eksctl create cluster --name=observability \
                      --region=us-east-1 \
                      --zones=us-east-1a,us-east-1b \
                      --without-nodegroup
```
```bash
eksctl utils associate-iam-oidc-provider \
    --region us-east-1 \
    --cluster observability \
    --approve
```
```bash
eksctl create nodegroup --cluster=observability \
                        --region=us-east-1 \
                        --name=observability-ng-private \
                        --node-type=t3.medium \
                        --nodes-min=2 \
                        --nodes-max=3 \
                        --node-volume-size=20 \
                        --managed \
                        --asg-access \
                        --external-dns-access \
                        --full-ecr-access \
                        --appmesh-access \
                        --alb-ingress-access \
                        --node-private-networking

# Update ./kube/config file
aws eks update-kubeconfig --name observability
```

### 🧰 Step 2: Install kube-prometheus-stack
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

### 🚀 Step 3: Deploy the chart into a new namespace "monitoring"
```bash
kubectl create ns monitoring
```
```bash
cd day-2

helm install monitoring prometheus-community/kube-prometheus-stack \
-n monitoring \
-f ./custom_kube_prometheus_stack.yml
```

### ✅ Step 4: Verify the Installation
```bash
kubectl get all -n monitoring
```
- **Prometheus UI**:
```bash
kubectl port-forward service/prometheus-operated -n monitoring 9090:9090
```

**NOTE:** If you are using an EC2 Instance or Cloud VM, you need to pass `--address 0.0.0.0` to the above command. Then you can access the UI on <instance-ip:port>

- **Grafana UI**: password is `prom-operator`
```bash
kubectl port-forward service/monitoring-grafana -n monitoring 8080:80
```
- **Alertmanager UI**:
```bash
kubectl port-forward service/alertmanager-operated -n monitoring 9093:9093
```

### 🧼 Step 5: Clean UP
- **Uninstall helm chart**:
```bash
helm uninstall monitoring --namespace monitoring
```
- **Delete namespace**:
```bash
kubectl delete ns monitoring
```
- **Delete Cluster & everything else**:
```bash
eksctl delete cluster --name observability
```
