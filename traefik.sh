helm repo add traefik https://helm.traefik.io/traefik
kubectl create ns traefik

cat <<EOF | helm upgrade -i traefik traefik/traefik --namespace traefik -f -
deployment:
  podAnnotations:
    prometheus.io/port: "9100"
    prometheus.io/scrape: "true"
    prometheus.io/path: "/metrics"
metrics:
  prometheus:
    entryPoint: metrics
EOF
