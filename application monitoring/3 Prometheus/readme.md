
📊 Metrics in Prometheus
Metrics are the fundamental data objects in Prometheus, representing measurements collected from monitored systems. They provide valuable insights into system performance, health, and behavior.

🏷️ Labels
Each metric is enriched with labels—key-value pairs that add dimensionality. Labels help differentiate metrics across various:

Services

Instances

Endpoints

For example, a metric like http_requests_total might have labels such as service="auth", instance="10.0.0.1:9090", and method="POST"—making it easy to filter and analyze specific slices of your data.

## 🔍 Example:
```bash
container_cpu_usage_seconds_total{namespace="kube-system", endpoint="https-metrics"}
```
- `container_cpu_usage_seconds_total` is the metric.
- `{namespace="kube-system", endpoint="https-metrics"}` are the labels.

📊 Metrics in Prometheus
Metrics are the core data objects in Prometheus, capturing measurements from monitored systems. They offer deep insights into system performance, health, and behavior.

🏷️ Labels
Labels are key-value pairs attached to metrics, adding meaningful context. They enable you to distinguish between different dimensions, such as:

Services

Instances

Endpoints

## 💡 Basic Examples of PromQL
- `container_cpu_usage_seconds_total`
    - Return all time series with the metric container_cpu_usage_seconds_total
- `container_cpu_usage_seconds_total{namespace="kube-system",pod=~"kube-proxy.*"}`
    - Return all time series with the metric `container_cpu_usage_seconds_total` and the given `namespace` and `pod` labels.
- `container_cpu_usage_seconds_total{namespace="kube-system",pod=~"kube-proxy.*"}[5m]`
    - Return a whole range of time (in this case 5 minutes up to the query time) for the same vector, making it a range vector.

## ⚙️ Aggregation & Functions in PromQL
- Aggregation in PromQL allows you to combine multiple time series into a single one, based on certain labels.
- **Sum Up All CPU Usage**:
    ```bash
    sum(rate(node_cpu_seconds_total[5m]))
    ```
    - This query aggregates the CPU usage across all nodes.

- **Average Memory Usage per Namespace:**
    ```bash
    avg(container_memory_usage_bytes) by (namespace)
    ```
    - This query provides the average memory usage grouped by namespace.

- **rate() Function:**
    - The rate() function calculates the per-second average rate of increase of the time series in a specified range.
    ```bash
    rate(container_cpu_usage_seconds_total[5m])
    ```
    - This calculates the rate of CPU usage over 5 minutes.
- **increase() Function:**
    - The increase() function returns the increase in a counter over a specified time range.
    ```bash
    increase(kube_pod_container_status_restarts_total[1h])
    ```
    - This gives the total increase in container restarts over the last hour.

- **histogram_quantile() Function:**
    - The histogram_quantile() function calculates quantiles (e.g., 95th percentile) from histogram data.
    ```bash
    histogram_quantile(0.95, sum(rate(apiserver_request_duration_seconds_bucket[5m])) by (le))
    ```
    - This calculates the 95th percentile of Kubernetes API request durations.
