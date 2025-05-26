module github.com/GoogleCloudPlatform/kubectl-ai/k8s-bench

go 1.24.0

toolchain go1.24.1

replace github.com/GoogleCloudPlatform/kubectl-ai => ./..

require (
	github.com/GoogleCloudPlatform/kubectl-ai v0.0.0-20250317140348-3b34c8984b9b
	k8s.io/klog/v2 v2.130.1
	sigs.k8s.io/yaml v1.4.0
)

require github.com/go-logr/logr v1.4.2 // indirect
