# ETCD Backup and Restore

## Installing etcdctl
```
https://etcd.io/docs/v3.4/install/
```
or run below script
```
ETCD_VER=v3.4.25

# choose either URL
GOOGLE_URL=https://storage.googleapis.com/etcd
GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
DOWNLOAD_URL=${GOOGLE_URL}

rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
rm -rf /tmp/etcd-download-test && mkdir -p /tmp/etcd-download-test

curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd-download-test --strip-components=1
rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz

cp /tmp/etcd-download-test/etcdctl /usr/local/bin
```


## Using ETCDCTL

```
etcdctl -h
```   

### Backup
Backup the database. set `ETCDCTL_API` to 3 to make sure the client uses ETCD v3 APIs
```
ETCDCTL_API=3 etcdctl snapshot backup -h
```
**etcdctl** requires details such as ETCD endpoint, CA cert, server cert and keys. We can easily find out these from its manifest file at `/etc/kubernetes/manifests/etcd.yaml` or by describing etcd pod in `kube-system` namespace 
```
kubectl describe pod etcd-master-node -n kube-system
```
```
ETCDCTL_API=3 etcdctl \
    --endpoints=https://[127.0.0.1]:2379 \
    --cacert=/etc/kubernetes/pki/etcd/ca.crt \
    --cert=/etc/kubernetes/pki/etcd/server.crt \
    --key=/etc/kubernetes/pki/etcd/server.key \
    snapshot save /tmp/etcd-snapshot.db
```
Backup ETCD certificates and keys
```
tar -zcvf etcd.tar.gz /etc/kubernetes/pki/etcd
```

### Get status of backup
```
ETCDCTL_API=3 etcdctl --write-out=table snapshot status /tmp/etcd-snapshot.db
```

### Restore from the backup
Delete the data directory of etcd. Find the location of data dir from its manifest at `/etc/kubernetes/manifests/etcd.yaml` in case if the cluster is setup with Kubeadm.
```
rm -rf /var/lib/etcd
```
Restore the data by selecting the data dir with `--data-dir` flag
```
ETCDCTL_API=3 etcdctl snapshot restore /tmp/etcd-snapshot.db \
    --endpoints=https://[127.0.0.1]:2379 \
    --cacert=/etc/kubernetes/pki/etcd/ca.crt \
    --cert=/etc/kubernetes/pki/etcd/server.crt \
    --key=/etc/kubernetes/pki/etcd/server.key \
    --data-dir=/var/lib/etcd
```

## Links
```
https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/
```
