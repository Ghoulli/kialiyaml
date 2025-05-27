#!/bin/bash
echo 'Script made by NQ'

K3S_BINARY="/usr/local/bin/k3s"

if [ -x "$K3S_BINARY" ]; then
	curl -L https://istio.io/downloadIstio | sh -
	cd istio-1.25.1
	export PATH=$PWD/bin:$PATH
	istioctl install -f samples/bookinfo/demo-profile-no-gateways.yaml -y
	kubectl label namespace default istio-injection=enabled
	kubectl get crd gateways.gateway.networking.k8s.io &> /dev/null || \
	{ kubectl kustomize "github.com/kubernetes-sigs/gateway-api/config/crd?ref=v1.2.1" | kubectl apply -f -; }
	kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml
	kubectl apply -f samples/bookinfo/gateway-api/bookinfo-gateway.yaml
	kubectl port-forward svc/bookinfo-gateway-istio 8080:80
	curl https://raw.githubusercontent.com/Ghoulli/kialiyaml/refs/heads/main/kiali.yaml | tee samples/addons/kiali.yaml #Curling a working kiali.yaml file from my own Github repo. Easiest way to fix the issue is to just get rid of the old file and replace it with mine.
	curl https://raw.githubusercontent.com/Ghoulli/kialiyaml/refs/heads/main/grafana.yaml | tee samples/addons/grafana.yaml
	kubectl apply -f samples/addons
	kubectl rollout status deployment/kiali -n istio-system
	istioctl dashboard kiali
else
    echo "K3s is NOT installed, first execute the k3sinstall.sh or install it by hand."
fi
exit
