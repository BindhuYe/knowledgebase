## Reference : Google Sre Monitoring (Documentation for guidelines)
## There are two types of Monitoring

- Black Box Monitoring
  Testing externally visible behaviour as a user would see it.
- White Box Monitoring
  Monitoring based on metrics exposed by internals of the system, including logs, interfaces like java virtual machine profiling interface or an Http handler that emits internal statistics.

## Golden Principles

1. latency --> time for response, should be always low
2. traffic --> how many users are accessing our system
3. Errors --> 500, 503 these are from server side
4. Saturation --> benchmark, how many users can access with out any errors

#### White-box monitoring

Monitoring based on metrics exposed by the internals of the system, including logs, interfaces like the Java Virtual Machine Profiling Interface, or an HTTP handler that emits internal statistics.

#### Black-box monitoring
Testing externally visible behavior as a user would see it.

#### Dashboard
An application (usually web-based) that provides a summary view of a service’s core metrics. A dashboard may have filters, selectors, and so on, but is prebuilt to expose the metrics most important to its users. The dashboard might also display team information such as ticket queue length, a list of high-priority bugs, the current on-call engineer for a given area of responsibility, or recent pushes.

#### Alert
A notification intended to be read by a human and that is pushed to a system such as a bug or ticket queue, an email alias, or a pager. Respectively, these alerts are classified as tickets, email alerts,22 and pages.

#### Root cause
A defect in a software or human system that, if repaired, instills confidence that this event won’t happen again in the same way. A given incident might have multiple root causes: for example, perhaps it was caused by a combination of insufficient process automation, software that crashed on bogus input, and insufficient testing of the script used to generate the configuration. Each of these factors might stand alone as a root cause, and each should be repaired.

### The Four Golden Signals

#### Latency
The time it takes to service a request. It’s important to distinguish between the latency of successful requests and the latency of failed requests. For example, an HTTP 500 error triggered due to loss of connection to a database or other critical backend might be served very quickly; however, as an HTTP 500 error indicates a failed request, factoring 500s into your overall latency might result in misleading calculations. On the other hand, a slow error is even worse than a fast error! Therefore, it’s important to track error latency, as opposed to just filtering out errors.

#### Traffic
A measure of how much demand is being placed on your system, measured in a high-level system-specific metric. For a web service, this measurement is usually HTTP requests per second, perhaps broken out by the nature of the requests (e.g., static versus dynamic content). For an audio streaming system, this measurement might focus on network I/O rate or concurrent sessions. For a key-value storage system, this measurement might be transactions and retrievals per second.

#### Errors
The rate of requests that fail, either explicitly (e.g., HTTP 500s), implicitly (for example, an HTTP 200 success response, but coupled with the wrong content), or by policy (for example, "If you committed to one-second response times, any request over one second is an error"). Where protocol response codes are insufficient to express all failure conditions, secondary (internal) protocols may be necessary to track partial failure modes. Monitoring these cases can be drastically different: catching HTTP 500s at your load balancer can do a decent job of catching all completely failed requests, while only end-to-end system tests can detect that you’re serving the wrong content.

#### Saturation
How "full" your service is. A measure of your system fraction, emphasizing the resources that are most constrained (e.g., in a memory-constrained system, show memory; in an I/O-constrained system, show I/O). Note that many systems degrade in performance before they achieve 100% utilization, so having a utilization target is essential.
In complex systems, saturation can be supplemented with higher-level load measurement: can your service properly handle double the traffic, handle only 10% more traffic, or handle even less traffic than it currently receives? For very simple services that have no parameters that alter the complexity of the request (e.g., "Give me a nonce" or "I need a globally unique monotonic integer") that rarely change configuration, a static value from a load test might be adequate. As discussed in the previous paragraph, however, most services need to use indirect signals like CPU utilization or network bandwidth that have a known upper bound. Latency increases are often a leading indicator of saturation. Measuring your 99th percentile response time over some small window (e.g., one minute) can give a very early signal of saturation.
Finally, saturation is also concerned with predictions of impending saturation, such as "It looks like your database will fill its hard drive in 4 hours."
If you measure all four golden signals and page a human when one signal is problematic (or, in the case of saturation, nearly problematic), your service will be at least decently covered by monitoring.

## Prometheus
- Prometheus architecture contains master and node components. 
- It basically follows pull model. It has timeseries database
- Server periodically connects to nodes and fetch the metrics. 
- Node Exporter component in the servers are responsible to collect       metrics from underlying server. Node Exporter is the agent here.

Monitoring 
- user
- Prometheus server
- Node(node exporter)

Components inside Prometheus Server
- Http Server(Browser)
- Time Series Database
- Alert Manager
- Service Discovery
- Grafana

Setting up prometheus node monitoring for EKS nodes.  

# Monitoring with ELK

- Incident ticket for tracking: p1, p2, p3, p4
- p1 and p2 are critical as they affect the business
- p3 is on low priority that needs to be handled for e.g. in a day
- p4 is on the lowest priority


## ELK

- Elasticsearch, Logstash and Kibana
- Elasticsearch is a distributed database and used for searching mechanism for e.g. Google Search suggestions
- From Elasticsearch, we have logstash and Kibana
- To view the data that is present in the Elasticsearch database, we use **Kibana** which is a UI that connects to the database
- **Logstash** is used for filtering the data that is coming from agents i.e. from other components.
- For NGiNX, we can use: `/var/log/nginx/access.log` to access the logs generated by NGiNX

### Filebeat

- **Filebeat** can access the log files and forward it to elasticsearch
- Filebeat is also known as **agents**
- Elasticsearch needs high memory and more virtual cpu's, therefore we could use t3.large
- Also, as it stores and analyses the logs we need atleast 30GB of harddisk space
- Elasticsearch server is developed on Java
- Each component in Elasticsearch has its configuration inside `/etc/<component>/<component>.yaml`
- Kibana log files are present at `/var/log/kibana/kibana.log` location
- Kibana dashboard can be accessed using **port 5601**
- Logstash runs on **port 5044**
- On each component which we wish to push the log files to Elasticsearch, should have **filebeat** package installed

### View Logs on Kibana

- Menu -> Management -> Stack Management -> Data -> Index Management
- To view the log file in Kibana, Kibana -> Index Patterns
  - Create Index pattern
  - Name: filebeat*
  - Timestamp field: @timestamp
- Once the index pattern is created:
  - Menu -> Discover
- But the data is in unstructured format and **to apply filters on the unstructured data, we need logstash**
- NGiNX stores the time taken for the whole response to process inside: `$request_time`
- The NGiNX log format can be viewed in: `/etc/nginx/nginx.conf` and can modify according to our need so that only necessary information is sent to Elasticsearch for futher analysis
- Before installing Logstash, we should stop filebeat package on the components so that it will not send data to Elasticsearch
- Once Logstash is installed, we should change the configuration of filebeat inside `/var/log/filebeat/filebeat.yaml` so that it forwards the data to Logstash for processing and filtering and Logstash forwards the data to Elasticsearch as key-value pairs
- We can have lot of filters as Elasticsearch and Logstash are big tools and out-of-which we use `grok` for parsing the unstructured data into fields

### Example filters

```text
55.3.244.1 GET /index.html 15824 0.043

%{IP:client} %{WORD:method} %{URIPATHPARAM:request} %{NUMBER:bytes} %{NUMBER:duration}

# How the data is stored in Elasticseach
client: 55.3.244.1
method: GET
request: /index.html
bytes: 15824
duration: 0.043
```

- We can get the variables such as IP, WORD, URIPATHPARAM, NUMBER etc from the Logstash website
- Prometheus and Grafana are used for metrics export whereas Elk is used logfiles export


