# Cluster Dependencies

You can choose whatever k8s distro you like, but make sure it have the following requirements:

 - Ingress. So, port 80 and 443 is used for this Ingress Controller
 - LoadBalancer
 - Dynamic Persistent Volume Provisioner
 - Internal or External DNS setup

If it's just a barebone k8s distro (metal or self-hosted solution), then this article will help
set up the above requirements.

## Ingress

To setup Ingress, we need Ingress Controller. There are many choices, but this section will 
describe how to setup Nginx Ingress Controller as a default option.

Nginx Ingress Controller works by running an nginx proxy in all of the available nodes. 
So, make sure port 80 and 443 is not currently being used in those nodes.

If you are using KinD, then you need to create cluster with port forward because the nodes 
were running as a container, so you need a way to forward port 80/443 from the nodes to your
actual machine. In Linux, because you can access the network directly, you can just access it 
via the node IP.

To install Nginx Ingress Controller, we use Helm CLI.

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
```

Then install the chart, preferably, in a new namespace called `ingress-nginx`.

```bash
kubectl create namespace ingress-nginx
helm -n ingress-nginx install ingress-nginx ingress-nginx/ingress-nginx
```

References: https://kubernetes.github.io/ingress-nginx/deploy/#using-helm

## LoadBalancer

TODO: possibly add MetalLB setup here

## Dynamic Persistent Volume Provisioner

We need a quick and simple volume provisioner.

Our first option is to use Longhorn as the default provisioner.
To install Longhorn, you need to install open-iscsi in your worker nodes.
With Longhorn you have the ability of sending a backup of your volume into 
an s3 compatible server, like MinIO.

### Installing Longhorn

For debian based nodes, you can install open-isci like this

```bash
apt -y update
apt -y install open-iscsi
```

Then, you can proceed to install Longhorn
Add Longhorn helm repo

```bash
helm repo add longhorn https://charts.longhorn.io
helm repo update
```

Install Longhorn in a namespace called longhorn-system

```bash
kubectl create namespace longhorn-system
helm -n longhorn-system install longhorn longhorn/longhorn
```

References: https://longhorn.io/docs/1.1.1/deploy/install/install-with-helm/


To access Longhorn web UI via k8s service port-forward, do this on an open terminal.
Set a new shell variable `HOST_PORT` with your intended port in the machine.

```bash
kubectl -n longhorn-system port-forward svc/longhorn-frontend $HOST_PORT:80
```

You can then access the UI from your browser in http://localhost:HOST_PORT. 
If `HOST_PORT` is set to 8080, then the address becomes http://localhost:8080

For testing purposes, usually we only need 1 Longhorn replicas.
Create this storage class and set it to default.

```bash
kubectl apply -f docs/testing-environment-setup/configs/longhorn-storage-class.yaml
# For checkout-less usage, use the following cmmand
# kubectl apply -f https://raw.githubusercontent.com/kartoza/charts/main/docs/testing-environment-setup/configs/longhorn-storage-class.yaml
```

Make sure that longhorn-default is your default storageclass.
Check the output of this command:

```bash
kubectl get storageclass
```

There should be only one entry with `(default)` mark, and it should `longhorn-default`.
If this is not the case, mark the other storageclass as non-default.
Assuming your storage class is called standard:

```bash
kubectl patch storageclass standard -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
```

## Installing local-path provisioner (alternative)

In the case that you can't install Longhorn for some reason, then you need to install alternative bare-metal provisioner.
You can use Rancher's local path provisioner for this: https://github.com/rancher/local-path-provisioner

```bash
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
```

References: https://github.com/rancher/local-path-provisioner

Make sure that local-path is your default storageclass.
Check the output of this command:

```bash
kubectl get storageclass
```

There should be only one entry with `(default)` mark, and it should `local-path`.
If this is not the case, mark the other storageclass as non-default.
Assuming your storage class is called standard:

```bash
kubectl patch storageclass standard -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
```


## Installing NFS Provisioner

Either Longhorn or Local-Path provisioner can work as default storage class for ReadWriteOnce Persistent Volume.

We still need dynamic provisioner to simulate ReadWriteMany Persistent Volume. We are going to use NFS Provisioner:

```bash
helm repo add stable https://charts.helm.sh/stable
helm repo update
```

Note:
The helm chart stable repo contains many chart, so it might take a while to fetch an update.

What we are going to do now, is create a Persistent Volume generated by Longhorn or Local-Path provisioner.
We use this PV as the NFS share server storage with specific associated Storage Class called `nfs`.
Then, if we create a new PV with storage class `nfs`, it will be created inside this NFS share, and attached 
to the pod via NFS client.

We have default helm values settings as a reference [here](configs/nfs-provisioner-values.yaml).
You might want to change the storage size of the backing PV to what's available in your machine.
By default it's using 20GiB in reserve.

```bash
kubectl create namespace nfs-provisioner
helm -n nfs-provisioner install nfs-provisioner stable/nfs-server-provisioner -f docs/testing-environment-setup/configs/nfs-provisioner-values.yaml
# for checkout-less helm install, use the following command
# helm -n nfs-provisioner install nfs-provisioner stable/nfs-server-provisioner -f https://raw.githubusercontent.com/kartoza/charts/master/docs/testing-environment-setup/configs/nfs-provisioner-values.yaml
```

References: https://github.com/helm/charts/tree/master/stable/nfs-server-provisioner

## External/Internal DNS provisioner

TODO: We can use internal CoreDNS, or dnsmasq, or pihole, or a simple /etc/hosts. But the setup depends on host machine.