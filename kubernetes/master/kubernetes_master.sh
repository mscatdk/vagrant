#!/bin/bash

sudo apt-get update && apt-get install -y apt-transport-https

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update

sudo apt-get install -y docker.io

sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni

#Using flannel, as that is what is used for Raspberry Pi on HypriotOS
sudo kubeadm init --pod-network-cidr 10.244.0.0/16 > /srv/data/init_master_log.out

sudo tail -n1 /srv/data/init_master_log.out | sed -e 's/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/10.11.12.6/g' > /srv/data/init_node.sh

sudo cp /etc/kubernetes/kubelet.conf temp_kubelet.conf

sudo sed -e 's/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/10.11.12.6/g' temp_kubelet.conf > kubelet.conf

sudo cp kubelet.conf /etc/kubernetes

sudo cp /etc/kubernetes/admin.conf temp_admin.conf

sudo sed -e 's/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/10.11.12.6/g' temp_admin.conf > admin.conf

sudo cp admin.conf /etc/kubernetes

sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml