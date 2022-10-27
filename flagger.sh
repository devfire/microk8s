helm repo add flagger https://flagger.app

helm upgrade -i flagger flagger/flagger \
--namespace traefik \
--set prometheus.install=true \
--set meshProvider=traefik
