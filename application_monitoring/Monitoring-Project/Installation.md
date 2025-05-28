Promethues installation

## To download promotheus package
- https://github.com/prometheus/prometheus/releases/download/v2.51.0-rc.0/prometheus

- https://prometheus.io/download/
- download this is /opt directory
- extract using tar -xf <file_url>
- Rename the extracted File
- create systemctl service inside /etc/systemd/system/<url>
- Refer prometheus.service/Promethues.sh/prometheus.yaml
- systemctl start prometheus
- systemctl status prometheus
- systemctl enable prometheus

- To check the port
- netstat-lntp


- Prometheus port Number : 9000
- Prometheus can also monitor its own server.
- It Scrapes local host metrics  every 15 seconds.
- cat prometheus.yml (you will get the configuration file)
- Change configuration file so that we can add additional job to connect prometheus with target nodes. You can add as many nodes as  requieed. Add provate Ip address of nodes under jobs.
- Promtheus need to know the target node so we create job for nodes inside prometheus congiguration file.


Now install nodes for prometheus server, Install node exporter in node and connect server and agents.

## To download Node Exporter
- https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
- download this is /opt directory
- extract using tar -xf <file_url>
- Rename the extracted File
- create systemctl service inside /etc/systemd/system/<url>
- Refer node_exporter.service/node_exporter.sh
- systemctl daemon-reload
- systemctl start node_exporter
- systemctl status node_exporter
- systemctl enable node_exporter

- To check the port
- netstat-lntp

- node_exporter port Number : 9100
- node_exporter provides the scraped data to prometheus server every 15 seconds.
- To check the memory/space use : node_memory_MemAvailable_bytes (In the same way we can get as many metrics as we want)


## To install grfana 
- wget -q -O gpg.key https://rpm.grafana.com/gpg.key
- sudo rpm --import gpg.key

- vim /etc/yum.repos.d/grafana.repo

[grafana]
name=grafana
baseurl=https://rpm.grafana.com
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://rpm.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt


- sudo dnf install grafana -y
- systemctl daemon-reload
- systemctl start grafana-server
- systemctl enable grafana-server


- We use grafana for visualization.
- We install grafana inside prometheus server.
- Grafana server is a simple web application.
- Port number of grafana server : 3000
- Go to Connections - Add Prometheus as input to fetch data 
                    Add new data source
                    Configure with Prometheus server url
- Go to Dashboard   -  We can create dashboard as per our requirement
                     Add visualization(select prometheus)
                     Select code in the interface and get the required metrics using commands.
                     We can configure the interface as per our requirement/
- We can use Alert Manager to simplify our tasks.
- Grafana component refers Http server(local host)
- users hits grafana , grafana gets the request from http server.
- We also have open source dashboards such as:
    - Node Exporter Pull - copy id and import inside prometheus.

## Sevice Discovery
- Inside Cloud environments prometheus finds the nodes automatically and adds scrape list using service discovery.
- Underlying nodes should always have node exporter installed and started.

- Prometheus ec2 service discovery
- Change the prometheus configuration file following all the conditions.
- set up prometheus server and install  node exportes in nodes.
- Create systemctl service. (add node exporter servive).
- We need to do dynamic scraping for enabling node monitoring by using service discovery.
- Add tag to nodes. Then relabel it inside service discovery job. Tag - key:value Monitoring:true , we can list all the tags. We will get the whole relabled information. Prometheus will fetch the node dynamically.
- Give permssions creating role for ec2 instnace and add policy . Role name: PrometheusEc2Describe , Policy: Inside Policy choose - Describe Instances. Attach policies inside permissions. Use the role and add the IAM role to prometheus server. 
- Create a job inside prometheus config file:

 job_name: "ec2_sd"
    ec2_sd_configs:
    - region: us-east-1
      port: 9100
      filters:
        - name: tag:Monitoring
          values:
            - true
    relabel_configs:
      - source_labels: [__meta_ec2_instance_id]
        target_label: instance_id
      - source_labels: [__meta_ec2_private_ip]
        target_label: private_ip
      - source_labels: [__meta_ec2_tag_Name]
        target_label: name

## Alert Manager
- Alert will be raised when the node is down value is 0 
  so the condition will be if value is <1 raise alert.
- Under rules inside prometheus configuration file which is prometheus.yml we need to configure the alert manager.
 - "alert-rules/*.yaml"
- We can configure as many rules as we want editing the config file and placing the rule.
- There are two tasks of Alert Manager : Raise the Alert, Manage the Alert.
- Install Alert Manager and configure it inside prometheus.
- Configure as such that email alerts will be send to the email. Verify email in Amazon ses.
- Inside smtp setting retrieve stmp credentials we will get username and password.
- Port number of alert manager: 9093/9094.

## ELK
- Elasticsearch, Logstash and Kibana
  Elastic search - A repository which stores logs. It is a db related application.
  Kibana - visulization tool for Elastic Search.
  Logstash - Used for filtering the logs before storing into elasticsearch

## There are two types of metrics
- counter
- gauge
Example : Vehicle speed is guage
          Number of kms utilized by vehicle : counter

### ELK Monitoring

Monitoring is very important part of DevOps, because whatever the work we did is reflected in monitoring. We have to proactively monitor the systems and get alerts immediately when something goes wrong so that business will not go down.

Let's take 2 cases.
* We are not doing any monitoring, if something goes wrong we can wait for someone to report our system is down.
* We are doing proactive monitoring, instead waiting for someone to report we can predict the errors, failures and raise alerts so that business will not go down.

#### Elasticsearch

Elasticsearch is a distributed search and analytics engine designed with horizontal scalability, real-time search, and data storage. It uses are
* log and event data analysis
* full-text search
* business intelligence

Elastic search port number : 9200

#### Kibana

Kibana is a data visualization that often used with Elasticsearch. It is UI and Elasticsearch is DB.

Kibana port number : 5601

#### Logstash

Logstash is a data collection and processing tool. It takes the input from different sources, filter into our required format and outputs to elasticsearch.

#### Filebeat

A collection agent that can access the logs and continuously push them to Logstash.

### Installation

1. Install Java
```
yum install java-11-openjdk-devel -y

```
2. Add the repo

```
vim /etc/yum.repos.d/elasticsearch.repo
```

```
[elasticsearch]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
```

2. Install elasticsearch

```
yum install elasticsearch -y
```

3. Open the elastic config file and make sure we uncomment
```
vim /etc/elasticsearch/elasticsearch.yml
```

* http.port: 9200
* Give network host as 
network.host: 0.0.0.0
* Enter a line under discovery section
```
discovery.type: single-node
```

4. Restart elasticsearch

```
systemctl restart elasticsearch
```

5. Test Elastic search
```
curl localhost:9200
```

**Sample Output:**
```
{
  "name" : "ip-172-31-23-26.ec2.internal",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "S5rDTZXASMWuu60v1i6HrQ",
  "version" : {
    "number" : "7.17.13",
    "build_flavor" : "default",
    "build_type" : "rpm",
    "build_hash" : "2b211dbb8bfdecaf7f5b44d356bdfe54b1050c13",
    "build_date" : "2023-08-31T17:33:19.958690787Z",
    "build_snapshot" : false,
    "lucene_version" : "8.11.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```
6. Enable elasticsearch
```
systemctl enable elasticsearch
```
#### Kibana

1. Install kibana

```
yum install kibana -y
```

2. Open the kibana config
```
vim /etc/kibana/kibana.yml
```
3. Uncomment
* server.port: 5601
* server.host: "0.0.0.0" keep the value as 0.0.0.0 so that we can open kibana from internet.
* elasticsearch.hosts: ["http://localhost:9200"]

3. Start and Enable kibana

```
systemctl restart kibana
```

```
systemctl enable kibana
```

#### Logstash

1. Install logstash

```
yum install logstash -y
```

2. Configure logstash input and output

```
vim /etc/logstash/conf.d/logstash.conf
```

```
input {
  beats {
    port => 5044
  }
}

output {
  elasticsearch {
    hosts => ["http://localhost:9200"]
    index => "%{[@metadata][beat]}-%{[@metadata][version]}"
  }
}

```

3. Start and Enable logstash

```
systemctl restart logstash
```

```
systemctl enable logstash
```

#### Filebeat

1. Add the repo

```
vim /etc/yum.repos.d/elasticsearch.repo
```

```
[elasticsearch]
name=Elasticsearch repository for 7.x packages
baseurl=https://artifacts.elastic.co/packages/7.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
```

2. Install filebeat

```
yum install filebeat -y
```

3. Open the filebeat config

```
vim /etc/filebeat/filebeat.yml
```

- Set `enabled: true` under filebeat.inputs
- Under paths: modify the log path to `/var/log/nginx/access.log`
- Specify the elasticsearch IP address for the host variable under output.elasticsearch section

4. Start filebeat service

```
systemctl start filebeat
```

- We can check whether the connection is established or not using `tail -f /var/log/messages` file

#### Grok filter

**nginx log**
```
'$remote_addr [$time_local] $request $status $body_bytes_sent "$http_referer" $request_time'
```

**Sample Value**
```
49.37.170.160 [15/Dec/2023:00:51:38 +0000] GET /api/catalogue/categories HTTP/1.1 404 571 "http://54.242.20.135/" 0.000
```

**Sample Grok**
```
%{IP:client_ip} \[%{HTTPDATE:timestamp}\] %{WORD:http_method} %{URIPATH:request_path} %{NOTSPACE:http_version} %{NUMBER:status:int} %{NUMBER:response_size:int} \"%{URI:referrer}\" %{NUMBER:response_time:float}
```

**Sample Logstash**
```
input {
  beats {
    port => 5044
  }
}
filter {
      grok {
        match => { "message" => "%{IP:client_ip} \[%{HTTPDATE:timestamp}\] %{WORD:http_method} %{URIPATH:request_path} %{NOTSPACE:http_version} %{NUMBER:status:int} %{NUMBER:response_size:int} \"%{URI:referrer}\" %{NUMBER:response_time:float}" }
      }
}
output {
  elasticsearch {
    hosts => ["http://localhost:9200"]
    index => "%{[@metadata][beat]}-%{[@metadata][version]}"
  }
}
```