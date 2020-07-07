# GeoServer

This is Kartoza's GeoServer Rancher charts

GeoServer is an open source server for sharing geospatial data.


# How to Use

For helm:

```bash
helm install release-name kartoza/geoserver
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
| image.pullPolicy | Docker image pull policy |
| geoserverDataDir | The directory of GeoServer Data Dir inside the pod |
| geowebcacheCacheDir | GeoServer have GeoWebCache support built in. This will be the location of the cache dir |
| geoserverUser | GeoServer super user name |
| geoserverPassword | GeoServer password for super user. If you fill it, it will then stored in k8s secret. |
| existingSecret | [tpl string] The name of the secret to get the geoserver password |
| extraPodEnv | [tpl string] Provide extra environment that will be passed into pods. Useful for non default image. |
| extraSecret | [tpl string] Provide extra secret that will be included in the pods. Useful for non default image. |
| extraConfigMap: | [tpl string] Provide extra config map that will be included in the pods. Useful for non default image. |
| extraVolumeMounts | [tpl string] Provide extra volume mounts declaration that will be included in the pods. Useful if you want to mount extra things. |
| extraVolume | [tpl string] Configuration pair with extraVolumeMounts. Declare which volume to mount in the pods. |
| persistence.geoserverDataDir.enabled | For geoserverDataDir volume. Default to true. If set, it will make a volume claim. |
| persistence.geoserverDataDir.existingClaim | For geoserverDataDir volume. Default to false. If set, it will use an existing claim name provided. |
| persistence.geoserverDataDir.mountPath | For geoserverDataDir volume. The path where the volume will be in the pods. Make sure that it corresponds to your geoserverDataDir key |
| persistence.geoserverDataDir.subPath | For geoserverDataDir volume. The path inside the the volume to mount to. Useful if you want to reuse the same volume but mount the subpath for different services.  |
| persistence.geoserverDataDir.size | For geoserverDataDir volume. Size of the volume |
| persistence.geoserverDataDir.accessModes | For geoserverDataDir volume. K8s Access mode of the volume. |
| persistence.geowebcacheCacheDir.enabled | For geowebcacheCacheDir volume. Default to true. If set, it will make a volume claim. |
| persistence.geowebcacheCacheDir.existingClaim | For geowebcacheCacheDir volume. Default to false. If set, it will use an existing claim name provided. |
| persistence.geowebcacheCacheDir.mountPath | For geowebcacheCacheDir volume. The path where the volume will be in the pods. Make sure that it corresponds to your geowebcacheCacheDir key |
| persistence.geowebcacheCacheDir.subPath | For geowebcacheCacheDir volume. The path inside the the volume to mount to. Useful if you want to reuse the same volume but mount the subpath for different services.  |
| persistence.geowebcacheCacheDir.size | For geowebcacheCacheDir volume. Size of the volume |
| persistence.geowebcacheCacheDir.accessModes | For geoserverDataDir volume. K8s Access mode of the volume. |
| service.type | The type of kubernetes service to be created. Leave it be for Headless service |
| service.loadBalancerIP | Only used if you use LoadBalancer service.type |
| service.externalIPs | External IPs to use for the service |
| service.port | External port to use/expose |
| ingress.enabled | Switch to true to enable ingress resource |
| ingress.host | The host name/site name the ingress will serve |
| ingress.tls.enabled | Set it to true to enable HTTPS |
| ingress.tls.secretName | Providing this will activate HTTPS ingress based on the provided certificate |
| probe | An override options for pod probe/health check |
