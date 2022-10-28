#!/usr/bin/env bash
# Create 3 nodes in a loop
for node in node1 node2 node3;do
  echo launching $node
  # each node gets 10GB of storage and 2GB of RAM
  multipass launch -n $node -d 10G -m 2G
  echo install k8s
  multipass exec $node -- bash -c "sudo snap install microk8s --classic"
  multipass exec $node -- bash -c "sudo usermod -a -G microk8s ubuntu"
  multipass exec $node -- bash -c "sudo chown -f -R ubuntu ~/.kube"
done

# we need to join nodes 2 and 3 into the cluster
for node in node2 node3; do
   joincommand=$(multipass exec node1 -- bash -c "microk8s add-node | grep ^microk8s | grep worker")
   echo adding $node
   multipass exec $node -- bash -c "$joincommand"
done

# our cluster will need DNS, RBAC, and local storage to function properly
echo enable dns rbac storage
multipass exec node1 -- bash -c "microk8s enable dns rbac hostpath-storage"

# export the kubeconfig and remove the old env variable
echo writing the config file
multipass exec node1 -- bash -c "microk8s config" > ~/.kube/config
unset KUBECONFIG

echo done!
