for node in node1 node2 node3;do
  echo launching $node
  multipass launch -n $node
done

# Init cluster on node1
echo init cluster
multipass exec node1 -- bash -c "curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE=\"644\" INSTALL_K3S_EXEC=\"--flannel-backend=none --cluster-cidr=192.168.0.0/16 --disable-network-policy --disable=traefik\" sh -"

# Get node1's IP
IP=$(multipass info node1 | grep IPv4 | awk '{print $2}')
echo master node ip is $IP

# Get Token used to join nodes
TOKEN=$(multipass exec node1 sudo cat /var/lib/rancher/k3s/server/node-token)

for node in node2 node3; do
	echo joining $node
	multipass exec $node -- bash -c "curl -sfL https://get.k3s.io | K3S_URL=\"https://$IP:6443\" K3S_TOKEN=\"$TOKEN\" sh -"
	echo ...joined!
done

# Get cluster's configuration
echo writing out cluster config yaml
multipass exec node1 sudo cat /etc/rancher/k3s/k3s.yaml > k3s.yaml

# Set node1's external IP in the configuration file
sed -i "s/127.0.0.1/$IP/" k3s.yaml

# We'r all set
echo
echo "K3s cluster is ready !"
echo
echo "Run the following command to set the current context:"
echo "$ export KUBECONFIG=$PWD/k3s.yaml"
echo
echo "and start to use the cluster:"
echo  "$ kubectl get nodes"
echo
