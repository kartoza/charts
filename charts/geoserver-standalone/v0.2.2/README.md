# GeoServer

This is Kartoza's GeoServer Chart

GeoServer is an open source server for sharing geospatial data.


# How to Use

For helm:

```bash
helm install release-name kartoza/geoserver-standalone
```

# Intro

This chart bootstrap a GeoServer installation.
Most GeoServer packages are shipped with Jetty or Tomcat Server to be directly used in production instance.
On top of that you can cascade with Nginx or Apache if you need more control over the routing mechanism.

# What it can do

The default install uses kartoza/geoserver image, which can do the following:

- Default TLS enabled
- Generate new datadir at startup if volume empty
- Some plugins are shipped

Full list of options can be seen in: https://github.com/kartoza/docker-geoserver/

# Parameters

| Parameter | Description |
|---|---|
| image.registry | Docker image registry |
| image.repository | Docker image repository |
| image.tag | Docker image tag |
| image.digest | Apache image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag |
| image.pullPolicy | Docker image pull policy |
| global.imageRegistry | Global Docker image registry |
| global.imagePullSecrets | Global Docker registry secret names as an array |
| nameOverride | String to partially override common.names.fullname |
| fullnameOverride | String to fully override common.names.fullname |
| replicas | Number of replicas of the Geoserver deployment |
| geoserverUser | GeoServer super user name |
| geoserverPassword | GeoServer password for super user. If you fill it, it will then stored in k8s secret. |
| annotations | Pod annotations |
| labels | Extra labels for Apache pods |
| affinity | Affinity for pod assignment |
| nodeSelector | Node labels for pod assignment |
| tolerations | Tolerations for pod assignment |
| existingSecret | [tpl string] The name of the secret to get the geoserver password |
| extraPodEnv | [tpl string] Provide extra environment that will be passed into pods. Useful for non default image. |
| extraSecret | [tpl string] Provide extra secret that will be included in the pods. Useful for non default image. |
| configMaps | [tpl string] Provide extra config map that will be included in the pods. Useful for non default image. |
| extraVolumeMounts | [tpl string] Provide extra volume mounts declaration that will be included in the pods. Useful if you want to mount extra things. |
| extraVolume | [tpl string] Configuration pair with extraVolumeMounts. Declare which volume to mount in the pods. |
| strategy.type | specifies the strategy used to replace old Pods by new ones |
| persistence.enabled | For geoserverDataDir volume. Default to true. If set, it will make a volume claim. |
| persistence.existingClaim | For geoserverDataDir volume. Default to false. If set, it will use an existing claim name provided. |
| persistence.mountPath | For geoserverDataDir volume. The path where the volume will be in the pods. Make sure that it corresponds to your geoserverDataDir key |
| persistence.subPath | For geoserverDataDir volume. The path inside the the volume to mount to. Useful if you want to reuse the same volume but mount the subpath for different services.  |
| persistence.size | For geoserverDataDir volume. Size of the volume |
| persistence.accessModes | For geoserverDataDir volume. K8s Access mode of the volume. |
| persistentVolumeClaimRetentionPolicy |  describes the lifecycle of persistent volume claims created from volumeClaimTemplates |
| service.type | The type of kubernetes service to be created. Leave it be for Headless service |
| service.loadBalancerIP | Only used if you use LoadBalancer service.type |
| service.externalIPs | External IPs to use for the service |
| service.nodePort | Node port for the service |
| service.port | External port to use/expose |
| rbac.enabled | Enable Role and rolebinding for priveledged PSP |
| serviceAccount.create | Wether to create a serviceaccount or use an existing one |
| serviceAccount.annotations | Serviceaccount annotations |
| serviceAccount.name | The name of the sevice account that the deployment will use |
| resources.limits | The resources limits for the container |
| resources.requests | The requested resources for the container |
| autoscaling.enabled | Enable Horizontal POD autoscaling |
| autoscaling.minReplicas | Minimum number of replicas |
| autoscaling.maxReplicas | Maximum number of replicas |
| autoscaling.targetCPUUtilizationPercentage | Target CPU utilization percentage |
| autoscaling.targetMemoryUtilizationPercentage | Target Memory utilization percentage |
| podSecurityContext | Optional security context for the Geoserver Pod |
| containerSecurityContext | Optional security context for the Geoserver Container |
| ingress.enabled | Switch to true to enable ingress resource |
| ingress.host | The host name/site name the ingress will serve |
| ingress.tls.enabled | Set it to true to enable HTTPS |
| ingress.className | IngressClass that will be be used to implement the Ingress |
| ingress.annotations | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations |
| ingress.tls.secretName | Providing this will activate HTTPS ingress based on the provided certificate |
| customProbes | An override options for pod probe/health check |
| postgis.enabled | Switch to true to enable postgis else you can use externaldb |
| postgis.auth.username | The username of the postgis database |
| postgis.auth.database | The name of the postgis database |
| postgis.auth.password | The password of the postgis database |
| postgis.auth.existingSecret | [tpl string] The name of the secret to get the postgis auth |
| externalDatabase.host | External Database server host |
| externalDatabase.port | External Database server port |
| externalDatabase.user | External Database username |
| externalDatabase.password | External Database password |
| externalDatabase.database | External Database name |
| externalDatabase.url | External Database url. This should be in the format postgis://user:pass@host:port/dbname |