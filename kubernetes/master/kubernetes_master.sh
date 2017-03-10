#!/bin/bash

sudo apt-get update && apt-get install -y apt-transport-https

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update

sudo apt-get install -y docker.io

sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni

sudo kubeadm init --pod-network-cidr 10.244.0.0/16 --api-advertise-addresses=10.11.12.6 > /srv/data/init_master_log.out

sudo tail -n1 /srv/data/init_master_log.out > /srv/data/init_node.sh

sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml