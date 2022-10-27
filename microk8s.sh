for node in node1 node2 node3;do
  echo launching $node
  multipass launch -n $node -d 10G -m 2G
  echo install k8s
  multipass exec $node -- bash -c "sudo snap install microk8s --classic"
  multipass exec $node -- bash -c "sudo usermod -a -G microk8s ubuntu"
  multipass exec $node -- bash -c "sudo chown -f -R ubuntu ~/.kube"
done

for node in node2 node3; do
   joincommand=$(multipass exec node1 -- bash -c "microk8s add-node | grep ^microk8s | grep worker")
   echo adding $node
   multipass exec $node -- bash -c "$joincommand"
done

echo enable dns rbac storage
multipass exec node1 -- bash -c "microk8s enable dns rbac hostpath-storage"


echo writing the config file
multipass exec node1 -- bash -c "microk8s config" > ~/.kube/config
unset KUBECONFIG


echo done!
