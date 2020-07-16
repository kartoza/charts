# QGIS Server

This is Kartoza's QGIS Server Rancher charts

QGIS Server is a mapping backend server using core QGIS Desktop code.


# How to Use

For helm:

```bash
helm install release-name kartoza/qgis-server
```

# Intro

This chart bootstrap a QGIS Server installation.

# Parameters

| Parameter | Description |
|---|---|
| image.registry | Docker image registry |
| image.repository | Docker image repository |
| image.tag | Docker image tag |
| image.pullPolicy | Docker image pull policy |
| qgisServerProjectDir | The directory of QGIS Server where the project can be located inside the pod |
| qgisServerProjectFile | Use project.qgs by default. Specify other full path to QGIS Server project |
| qgisServerLogLevel | QGIS Server Log Level |
| qgisServerBaseOWSURL | The root URL that QGIS Server will be using |
| extraPodEnv | [tpl string] Provide extra environment that will be passed into pods. Useful for non default image. |
| extraPodSpec | [tpl string] Provide extra pod spec |
| extraContainers | [tpl string] Provide extra containers in pod for sidekick |
| extraSecret | [tpl string] Provide extra secret that will be included in the pods. Useful for non default image. |
| extraConfigMap: | [tpl string] Provide extra config map that will be included in the pods. Useful for non default image. |
| extraVolumeMounts | [tpl string] Provide extra volume mounts declaration that will be included in the pods. Useful if you want to mount extra things. |
| extraVolume | [tpl string] Configuration pair with extraVolumeMounts. Declare which volume to mount in the pods. |
| persistence.qgisServerProjectDir.enabled | For qgisServerProjectDir volume. Default to true. If set, it will make a volume claim. |
| persistence.qgisServerProjectDir.existingClaim | For qgisServerProjectDir volume. Default to false. If set, it will use an existing claim name provided. |
| persistence.qgisServerProjectDir.mountPath | For qgisServerProjectDir volume. The path where the volume will be in the pods. Make sure that it corresponds to your qgisServerProjectDir key |
| persistence.qgisServerProjectDir.subPath | For qgisServerProjectDir volume. The path inside the the volume to mount to. Useful if you want to reuse the same volume but mount the subpath for different services.  |
| persistence.qgisServerProjectDir.size | For qgisServerProjectDir volume. Size of the volume |
| persistence.qgisServerProjectDir.accessModes | For qgisServerProjectDir volume. K8s Access mode of the volume. |
| service.type | The type of kubernetes service to be created. Leave it be for Headless service |
| service.loadBalancerIP | Only used if you use LoadBalancer service.type |
| service.externalIPs | External IPs to use for the service |
| service.port | External port to use/expose |
| ingress.enabled | Switch to true to enable ingress resource |
| ingress.host | The host name/site name the ingress will serve |
| ingress.tls.enabled | Set it to true to enable HTTPS |
| ingress.tls.secretName | Providing this will activate HTTPS ingress based on the provided certificate |
| probe | An override options for pod probe/health check |


# Copying file into the container

In fresh deployment, you can copy the QGIS Project Files into the deployment by 
using a ConfigMap. You can first create a ConfigMap from a file so it can be stored in your cluster.
Then load the ConfigMap using extraVolume and extraVolumeMounts options.
You can also specify qgisServerProjectDir and qgisServerProjectFile respectively.

If you didn't provide initial QGIS Project File, a default empty project will be created.
This is just an empty QGIS Project. You need to copy your own QGIS Project once the pod is running.
There are several ways to do that:

1. You can use kubectl to copy the QGIS Project files into the pod.
In general the command will be:

```bash
kubectl cp <qgis project file location> <qgisserver-pod-name>:<destination qgis project file in the pod> 
```

2. You can use extraContainers option to add sidekick to your pod.
For example you can add container that retrieve your qgis project from somewhere via wget or curl.
Or you can add container that allow SSH so you can go into the pod and copy the file into the volumes.



