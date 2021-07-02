

# nextcloud

![Version: 2.0.0](https://img.shields.io/badge/Version-2.0.0-informational?style=flat-square) ![AppVersion: 21.0.2](https://img.shields.io/badge/AppVersion-21.0.2-informational?style=flat-square)

A file sharing server that puts the control and security of your own data back into your hands.

Based on officially deprecated chart from https://github.com/helm/charts.git,
but now heavily customized for Kartoza internal orchestration.

**Homepage:** <https://nextcloud.com/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| lucernae | lana.pcfre@gmail.com |  |

## Source Code

* <https://github.com/nextcloud/docker>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| [../../common/v1.1.0](../../common/v1.1.0) | common | 1.1.0 |
| [../../postgis/v0.2.4](../../postgis/v0.2.4) | postgis | 0.2.4 |
| [https://charts.bitnami.com/bitnami](https://charts.bitnami.com/bitnami) | redis | 14.6.1 |

# Description

[nextcloud](https://nextcloud.com/) is a file sharing server that puts the control and security of your own data back into your hands.

Notes:
This charts are copied and modified over from https://github.com/helm/charts.git so it can be used inside Rancher.

# How to Use

## TL;DR;

For helm:

```bash
helm install --name <release-name> kartoza/nextcloud
```

# Intro

This chart bootstraps a [nextcloud](https://hub.docker.com/_/nextcloud/)
deployment on a [Kubernetes](http://kubernetes.io) cluster using the
[Helm](https://helm.sh) package manager.

It also packages the [Kartoza PostGIS chart](https://github.com/kartoza/charts/tree/main/charts/postgis)
which is required for bootstrapping a postgres deployment for the
database requirements of the nextcloud application.

It uses [Bitnami's Redis](https://bitnami.com/stack/redis/helm) if you
want to setup Nextcloud with Redis cache, sesssion, and file locking.

# Prerequisites

Due to Nextcloud image originally designed for monolithic applications,
we only able to test again specific configurations. It may work beyond that,
but you had to do your own customizations

Currently tested on:
- Kubernetes 1.19+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

# What it can do

The default deployment values install stateless Nextcloud with no persistence
support so you can check around the image.

Example of values can be seen in [ci directories](./ci)

Optional customizations:

- Enable/Disable Postgis RDBMS as backend
- Enable/Disable Redis support for session, cache, and file-locking
- Enable persistence (using your default PV provisioner)
- Enable nginx or apache based image

## Values
<table height="800px">
	<thead>
		<th>Key</th>
		<th>Type</th>
		<th>Default</th>
		<th>Description</th>
	</thead>
	<tbody>
		<tr>
<td>

<a id='annotations' class="anchor">annotations</a>

</td>
<td>

string

</td>
<td>

```json
{}
```

</td>
<td>

Custom chart annotations. Will be added to every resource created by this chart.

</td>
</tr>
		<tr>
<td>

<a id='cronjob.annotations' class="anchor">cronjob.annotations</a>

</td>
<td>

object

</td>
<td>

```json
{}
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='cronjob.curlInsecure' class="anchor">cronjob.curlInsecure</a>

</td>
<td>

bool

</td>
<td>

```json
false
```

</td>
<td>

Set curl's insecure option if you use e.g. self-signed certificates

</td>
</tr>
		<tr>
<td>

<a id='cronjob.enabled' class="anchor">cronjob.enabled</a>

</td>
<td>

bool

</td>
<td>

```json
false
```

</td>
<td>

Set to true to use Kubernetes based cronjob to trigger Nextcloud's webcron.

</td>
</tr>
		<tr>
<td>

<a id='cronjob.extraPodSpec' class="anchor">cronjob.extraPodSpec</a>

</td>
<td>

tpl/object

</td>
<td>

```yaml
cronjob.extraPodSpec: |
  #  nodeSelector:
  #    a.label: value
```

</td>
<td>

This will be evaluated as pod spec

</td>
</tr>
		<tr>
<td>

<a id='cronjob.failedJobsHistoryLimit' class="anchor">cronjob.failedJobsHistoryLimit</a>

</td>
<td>

int

</td>
<td>

```json
5
```

</td>
<td>

CronJob failedJobsHistoryLimit spec

</td>
</tr>
		<tr>
<td>

<a id='cronjob.image' class="anchor">cronjob.image</a>

</td>
<td>

dict

</td>
<td>

```yaml
map[]
```

</td>
<td>

Nexcloud image is used as default but only curl and sh is needed

</td>
</tr>
		<tr>
<td>

<a id='cronjob.nextcloudHost' class="anchor">cronjob.nextcloudHost</a>

</td>
<td>

tpl/string

</td>
<td>

```json
""
```

</td>
<td>

You can set nextcloud host directly if you want to use in-cluster access

</td>
</tr>
		<tr>
<td>

<a id='cronjob.resources' class="anchor">cronjob.resources</a>

</td>
<td>

dict

</td>
<td>

```json
null
```

</td>
<td>

If not set, nextcloud deployment one will be set

We usually recommend not to specify default resources and to leave this as a conscious
choice for the user. This also increases chances charts run on environments with little
resources, such as Minikube. If you do want to specify resources, uncomment the following
lines, adjust them as necessary, and remove the curly braces after 'resources:'.

```yaml
limits:
  cpu: 100m
  memory: 128Mi
requests:
  cpu: 100m
  memory: 128Mi
```

</td>
</tr>
		<tr>
<td>

<a id='cronjob.schedule' class="anchor">cronjob.schedule</a>

</td>
<td>

string

</td>
<td>

```json
"*/15 * * * *"
```

</td>
<td>

Cron schedule.

Every 15 minutes.
Note: Setting this to any any other value than 15 minutes might
cause issues with how nextcloud background jobs are executed

</td>
</tr>
		<tr>
<td>

<a id='cronjob.successfulJobsHistoryLimit' class="anchor">cronjob.successfulJobsHistoryLimit</a>

</td>
<td>

int

</td>
<td>

```json
2
```

</td>
<td>

CronJob successfulJobsHistoryLimit spec

</td>
</tr>
		<tr>
<td>

<a id='externalDatabase.database' class="anchor">externalDatabase.database</a>

</td>
<td>

string

</td>
<td>

```json
"nextcloud"
```

</td>
<td>

**Deprecated** Database name. Will be overriden by [global.databaseName](#global.databaseName)

</td>
</tr>
		<tr>
<td>

<a id='externalDatabase.enabled' class="anchor">externalDatabase.enabled</a>

</td>
<td>

bool

</td>
<td>

```json
false
```

</td>
<td>

Set to true to use external database

</td>
</tr>
		<tr>
<td>

<a id='externalDatabase.existingSecret.enabled' class="anchor">externalDatabase.existingSecret.enabled</a>

</td>
<td>

bool

</td>
<td>

```json
false
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='externalDatabase.host' class="anchor">externalDatabase.host</a>

</td>
<td>

string

</td>
<td>

```json
null
```

</td>
<td>

Database host

</td>
</tr>
		<tr>
<td>

<a id='externalDatabase.password' class="anchor">externalDatabase.password</a>

</td>
<td>

string

</td>
<td>

```json
null
```

</td>
<td>

**Deprecated** Database password. Will be overriden by [global.databasePassword](#global.databasePassword)

</td>
</tr>
		<tr>
<td>

<a id='externalDatabase.type' class="anchor">externalDatabase.type</a>

</td>
<td>

string

</td>
<td>

```json
"postgresql"
```

</td>
<td>

Supported database engines: mysql or postgresql

</td>
</tr>
		<tr>
<td>

<a id='externalDatabase.user' class="anchor">externalDatabase.user</a>

</td>
<td>

string

</td>
<td>

```json
"nextcloud"
```

</td>
<td>

**Deprecated** Database username. Will be overriden by [global.databaseUsername](#global.databaseUsername)

</td>
</tr>
		<tr>
<td>

<a id='extraConfigMap' class="anchor">extraConfigMap</a>

</td>
<td>

tpl/map

</td>
<td>

```yaml
extraConfigMap: |
  # file_1: conf content
```

</td>
<td>

Define this for extra config map to be included in shared-config

</td>
</tr>
		<tr>
<td>

<a id='extraPodSpec' class="anchor">extraPodSpec</a>

</td>
<td>

tpl/object

</td>
<td>

```yaml
extraPodSpec: |
  #  nodeSelector:
  #    a.label: value
```

</td>
<td>

This will be evaluated as pod spec

</td>
</tr>
		<tr>
<td>

<a id='extraPodenv' class="anchor">extraPodenv</a>

</td>
<td>

tpl/array

</td>
<td>

```yaml
extraPodenv: |
```

</td>
<td>

Extra pod env for Nextcloud container

</td>
</tr>
		<tr>
<td>

<a id='extraSecret' class="anchor">extraSecret</a>

</td>
<td>

tpl/map

</td>
<td>

```yaml
extraSecret: |
  #  key_1: value_1
```

</td>
<td>

Define this for extra secrets to be included in shared-secret secret

</td>
</tr>
		<tr>
<td>

<a id='extraVolume' class="anchor">extraVolume</a>

</td>
<td>

tpl/list

</td>
<td>

<details>
<summary>+Expand</summary>

```yaml
extraVolume: |
  # You may potentially mount a config map/secret
  #  - name: external-mounts
  #    persistentVolumeClaim:
  #      name: nfs-volume
```

</details>

</td>
<td>

Define this for extra volume (in pair with extraVolumeMounts)

Extra mounts for the pods. Example shown is for connecting a legacy NFS volume
to NextCloud pods in Kubernetes. This can then be configured in External Storage

</td>
</tr>
		<tr>
<td>

<a id='extraVolumeMounts' class="anchor">extraVolumeMounts</a>

</td>
<td>

tpl/list

</td>
<td>

<details>
<summary>+Expand</summary>

```yaml
extraVolumeMounts: |
  # You may potentially mount a config map/secret
  #  - name: external-mounts
  #    mountPath: /external-data
  #    subPath: subfolder
  #    readOnly: true
```

</details>

</td>
<td>

Define this for extra volume mounts in the pod

</td>
</tr>
		<tr>
<td>

<a id='fullnameOverride' class="anchor">fullnameOverride</a>

</td>
<td>

string

</td>
<td>

```json
""
```

</td>
<td>

You can override full release name

</td>
</tr>
		<tr>
<td>

<a id='global.databaseName' class="anchor">global.databaseName</a>

</td>
<td>

string

</td>
<td>

```json
"nextcloud"
```

</td>
<td>

Global interconnect information. For database name to be used by nextcloud

</td>
</tr>
		<tr>
<td>

<a id='global.databasePassword' class="anchor">global.databasePassword</a>

</td>
<td>

object/common.secret

</td>
<td>

<details>
<summary>+Expand</summary>

```yaml
# -- (string) Global interconnect information. Specify this password value.
# @section
#
# If not, it will be autogenerated everytime chart upgraded.
# If you use external backend, you must provide the value
value:
valueFrom:
    secretKeyRef:
        name:
        key: postgresql-password
```

</details>

</td>
<td>

Secret structure for Database Password

</td>
</tr>
		<tr>
<td>

<a id='global.databasePassword.value' class="anchor">global.databasePassword.value</a>

</td>
<td>

string

</td>
<td>

```json
null
```

</td>
<td>

Global interconnect information. Specify this password value.

If not, it will be autogenerated everytime chart upgraded.
If you use external backend, you must provide the value

</td>
</tr>
		<tr>
<td>

<a id='global.databasePort' class="anchor">global.databasePort</a>

</td>
<td>

int

</td>
<td>

```json
5432
```

</td>
<td>

Global interconnect information. For database port.

By default this chart can generate standard postgres chart.
So you can leave it as default. If you use external backend,
you must provide the value

</td>
</tr>
		<tr>
<td>

<a id='global.databaseUsername' class="anchor">global.databaseUsername</a>

</td>
<td>

string

</td>
<td>

```json
"nextcloud"
```

</td>
<td>

Global interconnect information. For database username backend to connect to. If you use external backend, provide the value

</td>
</tr>
		<tr>
<td>

<a id='global.existingSecret' class="anchor">global.existingSecret</a>

</td>
<td>

tpl/string

</td>
<td>

```yaml
global.existingSecret: |
```

</td>
<td>

Name of existing secret

</td>
</tr>
		<tr>
<td>

<a id='global.fullnameOverride' class="anchor">global.fullnameOverride</a>

</td>
<td>

string

</td>
<td>

```json
""
```

</td>
<td>

You can override full release name

</td>
</tr>
		<tr>
<td>

<a id='global.nameOverride' class="anchor">global.nameOverride</a>

</td>
<td>

string

</td>
<td>

```json
""
```

</td>
<td>

You can override release suffix

</td>
</tr>
		<tr>
<td>

<a id='global.nextcloudAdminPassword' class="anchor">global.nextcloudAdminPassword</a>

</td>
<td>

object/common.secret

</td>
<td>

<details>
<summary>+Expand</summary>

```yaml
# -- (string) Specify this password value. If not, it will be autogenerated everytime chart upgraded.
# @section
#
# It is recommended to create two superuser account.
# One account is the service superuser, as described in the [global.nextcloudAdminUser](#global.nextcloudAdminUser),
# which will have it's password set from here. Other superuser account's
# and password is set when Nextcloud instance is running (thus saved in
# the database backend)
value:
valueFrom:
    secretKeyRef:
        name:
        key: nextcloud-password
```

</details>

</td>
<td>

Secret structure for Admin Password

</td>
</tr>
		<tr>
<td>

<a id='global.nextcloudAdminPassword.value' class="anchor">global.nextcloudAdminPassword.value</a>

</td>
<td>

string

</td>
<td>

```json
null
```

</td>
<td>

Specify this password value. If not, it will be autogenerated everytime chart upgraded.

It is recommended to create two superuser account.
One account is the service superuser, as described in the [global.nextcloudAdminUser](#global.nextcloudAdminUser),
which will have it's password set from here. Other superuser account's
and password is set when Nextcloud instance is running (thus saved in
the database backend)

</td>
</tr>
		<tr>
<td>

<a id='global.nextcloudAdminUser' class="anchor">global.nextcloudAdminUser</a>

</td>
<td>

string

</td>
<td>

```json
"nextcloud-admin"
```

</td>
<td>

Default super user admin username

</td>
</tr>
		<tr>
<td>

<a id='global.redisPassword' class="anchor">global.redisPassword</a>

</td>
<td>

object/common.secret

</td>
<td>

<details>
<summary>+Expand</summary>

```yaml
# -- (string) Specify this password value. If not, it will be autogenerated everytime chart upgraded.
# @section
#
# It is recommended to use autogenerated value
# if you create Redis instance together with this chart. Otherwise,
# you had to specify password of your Redis instance.
value:
valueFrom:
    secretKeyRef:
        name:
        key: redis-password
# -- (string) Global default storage class
# @section
#
# Will affect both Nextcloud and subcharts.
# If defined, storageClassName: <storageClass>
# If set to "-", storageClassName: "", which disables dynamic provisioning
# If undefined (the default) or set to null, no storageClassName spec is
# set, choosing the default provisioner.  (gp2 on AWS, standard on
# GKE, AWS & OpenStack)
storageClass: null
```

</details>

</td>
<td>

Secret structure for Redis Password

</td>
</tr>
		<tr>
<td>

<a id='global.redisPassword.storageClass' class="anchor">global.redisPassword.storageClass</a>

</td>
<td>

string

</td>
<td>

```json
null
```

</td>
<td>

Global default storage class

Will affect both Nextcloud and subcharts.
If defined, storageClassName: <storageClass>
If set to "-", storageClassName: "", which disables dynamic provisioning
If undefined (the default) or set to null, no storageClassName spec is
set, choosing the default provisioner.  (gp2 on AWS, standard on
GKE, AWS & OpenStack)

</td>
</tr>
		<tr>
<td>

<a id='global.redisPassword.value' class="anchor">global.redisPassword.value</a>

</td>
<td>

string

</td>
<td>

```json
null
```

</td>
<td>

Specify this password value. If not, it will be autogenerated everytime chart upgraded.

It is recommended to use autogenerated value
if you create Redis instance together with this chart. Otherwise,
you had to specify password of your Redis instance.

</td>
</tr>
		<tr>
<td>

<a id='global.sharedConfigName' class="anchor">global.sharedConfigName</a>

</td>
<td>

string

</td>
<td>

```json
"nextcloud-shared-config"
```

</td>
<td>

Name of shared config store that will be generated

</td>
</tr>
		<tr>
<td>

<a id='global.sharedSecretName' class="anchor">global.sharedSecretName</a>

</td>
<td>

string

</td>
<td>

```json
"nextcloud-shared-secret"
```

</td>
<td>

Name of shared secret store that will be generated

</td>
</tr>
		<tr>
<td>

<a id='global.smtpPassword' class="anchor">global.smtpPassword</a>

</td>
<td>

object/common.secret

</td>
<td>

<details>
<summary>+Expand</summary>

```yaml
# -- (string) SMTP password credentials to send email from this Nextcloud instance
value:
valueFrom:
    secretKeyRef:
        name:
        key: smtp-password
```

</details>

</td>
<td>

Secret structure for SMTP Password

</td>
</tr>
		<tr>
<td>

<a id='global.smtpPassword.value' class="anchor">global.smtpPassword.value</a>

</td>
<td>

string

</td>
<td>

```json
null
```

</td>
<td>

SMTP password credentials to send email from this Nextcloud instance

</td>
</tr>
		<tr>
<td>

<a id='global.smtpUser' class="anchor">global.smtpUser</a>

</td>
<td>

string

</td>
<td>

```json
null
```

</td>
<td>

SMTP user credentials to send email from this Nextcloud instance

</td>
</tr>
		<tr>
<td>

<a id='hpa' class="anchor">hpa</a>

</td>
<td>

dict

</td>
<td>

<details>
<summary>+Expand</summary>

```json
{
  "cputhreshold": 60,
  "enabled": false,
  "maxPods": 10,
  "minPods": 1
}
```

</details>

</td>
<td>

Enable pod autoscaling using HorizontalPodAutoscaler ref: https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/

</td>
</tr>
		<tr>
<td>

<a id='image' class="anchor">image</a>

</td>
<td>

object/container-image

</td>
<td>

<details>
<summary>+Expand</summary>

```yaml
# -- Image registry
registry: docker.io
# -- Image repository
repository: nextcloud
# -- Image tag
tag: 21.0.2-apache
# -- (k8s/containers/image/imagePullPolicy) Image pullPolicy
pullPolicy: IfNotPresent
# pullSecrets:
#   - myRegistrKeySecretName
```

</details>

</td>
<td>

Image map

Official nextcloud image version
ref: https://hub.docker.com/r/library/nextcloud/tags/

</td>
</tr>
		<tr>
<td>

<a id='image.pullPolicy' class="anchor">image.pullPolicy</a>

</td>
<td>

k8s/containers/image/imagePullPolicy

</td>
<td>

```json
"IfNotPresent"
```

</td>
<td>

Image pullPolicy

</td>
</tr>
		<tr>
<td>

<a id='image.registry' class="anchor">image.registry</a>

</td>
<td>

string

</td>
<td>

```json
"docker.io"
```

</td>
<td>

Image registry

</td>
</tr>
		<tr>
<td>

<a id='image.repository' class="anchor">image.repository</a>

</td>
<td>

string

</td>
<td>

```json
"nextcloud"
```

</td>
<td>

Image repository

</td>
</tr>
		<tr>
<td>

<a id='image.tag' class="anchor">image.tag</a>

</td>
<td>

string

</td>
<td>

```json
"21.0.2-apache"
```

</td>
<td>

Image tag

</td>
</tr>
		<tr>
<td>

<a id='ingress' class="anchor">ingress</a>

</td>
<td>

dict

</td>
<td>

<details>
<summary>+Expand</summary>

```yaml
# -- (bool) Set to true to generate Ingress resource
enabled: false
tls:
    # -- (bool) Set to true to enable HTTPS
    enabled: false
    # -- (string) You must provide a secret name where the TLS cert is stored
    secretName: nextcloud-tls
# -- (tpl/string) Set custom host name. (DNS name convention)
# if empty, will follow [nextcloud.host](#nextcloud.host) value
# @notationType -- tpl
host: ""
# -- (dict) Custom Ingress annotations
# @section
#
# Example:
#
# ```
# nginx.ingress.kubernetes.io/proxy-body-size: 4G
# kubernetes.io/tls-acme: "true"
# certmanager.k8s.io/cluster-issuer: letsencrypt-prod
# nginx.ingress.kubernetes.io/server-snippet: |-
#   server_tokens off;
#   proxy_hide_header X-Powered-By;
#   rewrite ^/.well-known/webfinger /public.php?service=webfinger last;
#   rewrite ^/.well-known/host-meta /public.php?service=host-meta last;
#   rewrite ^/.well-known/host-meta.json /public.php?service=host-meta-json;
#   location = /.well-known/carddav {
#     return 301 $scheme://$host/remote.php/dav;
#   }
#   location = /.well-known/caldav {
#     return 301 $scheme://$host/remote.php/dav;
#   }
#   location = /robots.txt {
#     allow all;
#     log_not_found off;
#     access_log off;
#   }
#   location ~ ^/(?:build|tests|config|lib|3rdparty|templates|data)/ {
#     deny all;
#   }
#   location ~ ^/(?:autotest|occ|issue|indie|db_|console) {
#     deny all;
#   }
# ```
annotations: {}
# -- (dict) Custom Ingress labels
labels: {}
```

</details>

</td>
<td>

Allowing use of ingress controllers

ref: https://kubernetes.io/docs/concepts/services-networking/ingress/

</td>
</tr>
		<tr>
<td>

<a id='ingress.annotations' class="anchor">ingress.annotations</a>

</td>
<td>

dict

</td>
<td>

```json
{}
```

</td>
<td>

Custom Ingress annotations

Example:

```
nginx.ingress.kubernetes.io/proxy-body-size: 4G
kubernetes.io/tls-acme: "true"
certmanager.k8s.io/cluster-issuer: letsencrypt-prod
nginx.ingress.kubernetes.io/server-snippet: |-
  server_tokens off;
  proxy_hide_header X-Powered-By;
  rewrite ^/.well-known/webfinger /public.php?service=webfinger last;
  rewrite ^/.well-known/host-meta /public.php?service=host-meta last;
  rewrite ^/.well-known/host-meta.json /public.php?service=host-meta-json;
  location = /.well-known/carddav {
    return 301 $scheme://$host/remote.php/dav;
  }
  location = /.well-known/caldav {
    return 301 $scheme://$host/remote.php/dav;
  }
  location = /robots.txt {
    allow all;
    log_not_found off;
    access_log off;
  }
  location ~ ^/(?:build|tests|config|lib|3rdparty|templates|data)/ {
    deny all;
  }
  location ~ ^/(?:autotest|occ|issue|indie|db_|console) {
    deny all;
  }
```

</td>
</tr>
		<tr>
<td>

<a id='ingress.enabled' class="anchor">ingress.enabled</a>

</td>
<td>

bool

</td>
<td>

```json
false
```

</td>
<td>

Set to true to generate Ingress resource

</td>
</tr>
		<tr>
<td>

<a id='ingress.host' class="anchor">ingress.host</a>

</td>
<td>

tpl/string

</td>
<td>

```yaml
ingress.host: |
```

</td>
<td>

Set custom host name. (DNS name convention) if empty, will follow [nextcloud.host](#nextcloud.host) value

</td>
</tr>
		<tr>
<td>

<a id='ingress.labels' class="anchor">ingress.labels</a>

</td>
<td>

dict

</td>
<td>

```json
{}
```

</td>
<td>

Custom Ingress labels

</td>
</tr>
		<tr>
<td>

<a id='ingress.tls.enabled' class="anchor">ingress.tls.enabled</a>

</td>
<td>

bool

</td>
<td>

```json
false
```

</td>
<td>

Set to true to enable HTTPS

</td>
</tr>
		<tr>
<td>

<a id='ingress.tls.secretName' class="anchor">ingress.tls.secretName</a>

</td>
<td>

string

</td>
<td>

```json
"nextcloud-tls"
```

</td>
<td>

You must provide a secret name where the TLS cert is stored

</td>
</tr>
		<tr>
<td>

<a id='internalDatabase.enabled' class="anchor">internalDatabase.enabled</a>

</td>
<td>

bool

</td>
<td>

```json
false
```

</td>
<td>

Set to true to use file-based internal database (SQLite). Only use this for testing purposes.

</td>
</tr>
		<tr>
<td>

<a id='internalDatabase.name' class="anchor">internalDatabase.name</a>

</td>
<td>

string

</td>
<td>

```json
"nextcloud"
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='labels' class="anchor">labels</a>

</td>
<td>

string

</td>
<td>

```json
{}
```

</td>
<td>

Custom chart label. Will be added to every resource created by this chart.

</td>
</tr>
		<tr>
<td>

<a id='lifecycle' class="anchor">lifecycle</a>

</td>
<td>

object

</td>
<td>

```json
{}
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='mariadb.db.name' class="anchor">mariadb.db.name</a>

</td>
<td>

string

</td>
<td>

```json
"nextcloud"
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='mariadb.db.password' class="anchor">mariadb.db.password</a>

</td>
<td>

string

</td>
<td>

```json
"changeme"
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='mariadb.db.user' class="anchor">mariadb.db.user</a>

</td>
<td>

string

</td>
<td>

```json
"nextcloud"
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='mariadb.enabled' class="anchor">mariadb.enabled</a>

</td>
<td>

bool

</td>
<td>

```json
false
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='mariadb.persistence.accessMode' class="anchor">mariadb.persistence.accessMode</a>

</td>
<td>

string

</td>
<td>

```json
"ReadWriteOnce"
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='mariadb.persistence.enabled' class="anchor">mariadb.persistence.enabled</a>

</td>
<td>

bool

</td>
<td>

```json
false
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='mariadb.persistence.size' class="anchor">mariadb.persistence.size</a>

</td>
<td>

string

</td>
<td>

```json
"8Gi"
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='metrics.enabled' class="anchor">metrics.enabled</a>

</td>
<td>

bool

</td>
<td>

```json
false
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='metrics.https' class="anchor">metrics.https</a>

</td>
<td>

bool

</td>
<td>

```json
false
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='metrics.image.pullPolicy' class="anchor">metrics.image.pullPolicy</a>

</td>
<td>

string

</td>
<td>

```json
"IfNotPresent"
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='metrics.image.repository' class="anchor">metrics.image.repository</a>

</td>
<td>

string

</td>
<td>

```json
"xperimental/nextcloud-exporter"
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='metrics.image.tag' class="anchor">metrics.image.tag</a>

</td>
<td>

string

</td>
<td>

```json
"v0.3.0"
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='metrics.replicaCount' class="anchor">metrics.replicaCount</a>

</td>
<td>

int

</td>
<td>

```json
1
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='metrics.service.annotations."prometheus.io/port"' class="anchor">metrics.service.annotations."prometheus.io/port"</a>

</td>
<td>

string

</td>
<td>

```json
"9205"
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='metrics.service.annotations."prometheus.io/scrape"' class="anchor">metrics.service.annotations."prometheus.io/scrape"</a>

</td>
<td>

string

</td>
<td>

```json
"true"
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='metrics.service.labels' class="anchor">metrics.service.labels</a>

</td>
<td>

object

</td>
<td>

```json
{}
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='metrics.service.type' class="anchor">metrics.service.type</a>

</td>
<td>

string

</td>
<td>

```json
"ClusterIP"
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='metrics.timeout' class="anchor">metrics.timeout</a>

</td>
<td>

string

</td>
<td>

```json
"5s"
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='nameOverride' class="anchor">nameOverride</a>

</td>
<td>

string

</td>
<td>

```json
""
```

</td>
<td>

You can override release suffix

</td>
</tr>
		<tr>
<td>

<a id='nextcloud.configs' class="anchor">nextcloud.configs</a>

</td>
<td>

dict

</td>
<td>

```json
{}
```

</td>
<td>

Extra config files created in /var/www/html/config/

ref: https://docs.nextcloud.com/server/15/admin_manual/configuration_server/config_sample_php_parameters.html#multiple-config-php-file

Value is a mapping of filename --> file content

For example, to use S3 as primary storage

ref: https://docs.nextcloud.com/server/13/admin_manual/configuration_files/primary_storage.html#simple-storage-service-s3

```yaml
 configs:
   s3.config.php: |-
     <?php
     $CONFIG = array (
       'objectstore' => array(
         'class' => '\\OC\\Files\\ObjectStore\\S3',
         'arguments' => array(
           'bucket'     => 'my-bucket',
           'autocreate' => true,
           'key'        => 'xxx',
           'secret'     => 'xxx',
           'region'     => 'us-east-1',
           'use_ssl'    => true
         )
       )
     );
```

</td>
</tr>
		<tr>
<td>

<a id='nextcloud.datadir' class="anchor">nextcloud.datadir</a>

</td>
<td>

string

</td>
<td>

```json
"/var/www/html/data"
```

</td>
<td>

nextcloud data dir location

</td>
</tr>
		<tr>
<td>

<a id='nextcloud.defaultConfigs' class="anchor">nextcloud.defaultConfigs</a>

</td>
<td>

dict

</td>
<td>

<details>
<summary>+Expand</summary>

```yaml
# -- (bool) To protect /var/www/html/config
.htaccess: true
# -- (bool) Redis default configuration
redis.config.php: true
# -- (bool) Apache configuration for rewrite urls
apache-pretty-urls.config.php: true
# -- (bool) Define APCu as local cache
apcu.config.php: true
# -- (bool) Apps directory configs
apps.config.php: true
# -- (bool)Used for auto configure database
autoconfig.php: true
# -- (bool) SMTP default configuration
smtp.config.php: true
```

</details>

</td>
<td>

Default config files

**IMPORTANT**: Will be used only if you put extra configs, otherwise default will come from nextcloud itself.

Default confgurations can be found here: https://github.com/nextcloud/docker/tree/master/16.0/apache/config

</td>
</tr>
		<tr>
<td>

<a id='nextcloud.defaultConfigs.".htaccess"' class="anchor">nextcloud.defaultConfigs.".htaccess"</a>

</td>
<td>

bool

</td>
<td>

```json
true
```

</td>
<td>

To protect /var/www/html/config

</td>
</tr>
		<tr>
<td>

<a id='nextcloud.defaultConfigs."apache-pretty-urls.config.php"' class="anchor">nextcloud.defaultConfigs."apache-pretty-urls.config.php"</a>

</td>
<td>

bool

</td>
<td>

```json
true
```

</td>
<td>

Apache configuration for rewrite urls

</td>
</tr>
		<tr>
<td>

<a id='nextcloud.defaultConfigs."apcu.config.php"' class="anchor">nextcloud.defaultConfigs."apcu.config.php"</a>

</td>
<td>

bool

</td>
<td>

```json
true
```

</td>
<td>

Define APCu as local cache

</td>
</tr>
		<tr>
<td>

<a id='nextcloud.defaultConfigs."apps.config.php"' class="anchor">nextcloud.defaultConfigs."apps.config.php"</a>

</td>
<td>

bool

</td>
<td>

```json
true
```

</td>
<td>

Apps directory configs

</td>
</tr>
		<tr>
<td>

<a id='nextcloud.defaultConfigs."autoconfig.php"' class="anchor">nextcloud.defaultConfigs."autoconfig.php"</a>

</td>
<td>

bool

</td>
<td>

```json
true
```

</td>
<td>

Used for auto configure database

</td>
</tr>
		<tr>
<td>

<a id='nextcloud.defaultConfigs."redis.config.php"' class="anchor">nextcloud.defaultConfigs."redis.config.php"</a>

</td>
<td>

bool

</td>
<td>

```json
true
```

</td>
<td>

Redis default configuration

</td>
</tr>
		<tr>
<td>

<a id='nextcloud.defaultConfigs."smtp.config.php"' class="anchor">nextcloud.defaultConfigs."smtp.config.php"</a>

</td>
<td>

bool

</td>
<td>

```json
true
```

</td>
<td>

SMTP default configuration

</td>
</tr>
		<tr>
<td>

<a id='nextcloud.host' class="anchor">nextcloud.host</a>

</td>
<td>

string

</td>
<td>

```json
"nextcloud.kube.home"
```

</td>
<td>

Nextcloud's trusted hostname.

Has to be set for production instance
because it connects to Ingress name, trusted proxy domain, and URL name.

</td>
</tr>
		<tr>
<td>

<a id='nextcloud.mail.domain' class="anchor">nextcloud.mail.domain</a>

</td>
<td>

string

</td>
<td>

```json
"domain.com"
```

</td>
<td>

nextcloud mail domain

</td>
</tr>
		<tr>
<td>

<a id='nextcloud.mail.enabled' class="anchor">nextcloud.mail.enabled</a>

</td>
<td>

bool

</td>
<td>

```json
false
```

</td>
<td>

Set to true to enable mail settings

</td>
</tr>
		<tr>
<td>

<a id='nextcloud.mail.fromAddress' class="anchor">nextcloud.mail.fromAddress</a>

</td>
<td>

string

</td>
<td>

```json
"user"
```

</td>
<td>

nextcloud mail send from field

</td>
</tr>
		<tr>
<td>

<a id='nextcloud.mail.smtp.authtype' class="anchor">nextcloud.mail.smtp.authtype</a>

</td>
<td>

string

</td>
<td>

```json
"LOGIN"
```

</td>
<td>

SMTP authentication method

</td>
</tr>
		<tr>
<td>

<a id='nextcloud.mail.smtp.host' class="anchor">nextcloud.mail.smtp.host</a>

</td>
<td>

string

</td>
<td>

```json
"domain.com"
```

</td>
<td>

SMTP Hostname

</td>
</tr>
		<tr>
<td>

<a id='nextcloud.mail.smtp.name' class="anchor">nextcloud.mail.smtp.name</a>

</td>
<td>

string

</td>
<td>

```json
"user"
```

</td>
<td>

**Deprecated** SMTP username. Will be overridden by [global.smtpUser](#global.smtpUser)

</td>
</tr>
		<tr>
<td>

<a id='nextcloud.mail.smtp.password' class="anchor">nextcloud.mail.smtp.password</a>

</td>
<td>

string

</td>
<td>

```json
"pass"
```

</td>
<td>

**Deprecated** SMTP password. Will be overridden by [global.smtpPassword](#global.smtpPassword)

</td>
</tr>
		<tr>
<td>

<a id='nextcloud.mail.smtp.port' class="anchor">nextcloud.mail.smtp.port</a>

</td>
<td>

int

</td>
<td>

```json
465
```

</td>
<td>

SMTP port

</td>
</tr>
		<tr>
<td>

<a id='nextcloud.mail.smtp.secure' class="anchor">nextcloud.mail.smtp.secure</a>

</td>
<td>

string

</td>
<td>

```json
"ssl"
```

</td>
<td>

SMTP protocol connection

</td>
</tr>
		<tr>
<td>

<a id='nextcloud.password' class="anchor">nextcloud.password</a>

</td>
<td>

string

</td>
<td>

```json
"changeme"
```

</td>
<td>

**Deprecated**. Will be overridden by [global.nextcloudAdminPassword](#global.nextcloudAdminPassword)

</td>
</tr>
		<tr>
<td>

<a id='nextcloud.persistence.subPath' class="anchor">nextcloud.persistence.subPath</a>

</td>
<td>

string

</td>
<td>

```json
null
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='nextcloud.phpConfigs' class="anchor">nextcloud.phpConfigs</a>

</td>
<td>

dict

</td>
<td>

```json
{}
```

</td>
<td>

PHP Configuration files

Will be injected in /usr/local/etc/php/conf.d
Value is a mapping of filename --> file content
To make sure your PHP conf is overriding the default, create a filename
with last alphabetical order, like "z-php.ini"

</td>
</tr>
		<tr>
<td>

<a id='nextcloud.strategy.type' class="anchor">nextcloud.strategy.type</a>

</td>
<td>

string

</td>
<td>

```json
"Recreate"
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='nextcloud.tableprefix' class="anchor">nextcloud.tableprefix</a>

</td>
<td>

string

</td>
<td>

```json
null
```

</td>
<td>

nextcloud db table prefix

</td>
</tr>
		<tr>
<td>

<a id='nextcloud.update' class="anchor">nextcloud.update</a>

</td>
<td>

int

</td>
<td>

```json
0
```

</td>
<td>

Trigger update if custom command is used

</td>
</tr>
		<tr>
<td>

<a id='nextcloud.username' class="anchor">nextcloud.username</a>

</td>
<td>

string

</td>
<td>

```json
"admin"
```

</td>
<td>

**Deprecated**. Will be overridden by [global.nextcloudAdminUser](#global.nextcloudAdminUser)

</td>
</tr>
		<tr>
<td>

<a id='nginx.config.custom' class="anchor">nginx.config.custom</a>

</td>
<td>

tpl/string

</td>
<td>

```json
""
```

</td>
<td>

Use this key to put your own nginx configuration

</td>
</tr>
		<tr>
<td>

<a id='nginx.config.default' class="anchor">nginx.config.default</a>

</td>
<td>

bool

</td>
<td>

```json
true
```

</td>
<td>

This generates the default nginx config as per the nextcloud documentation

</td>
</tr>
		<tr>
<td>

<a id='nginx.enabled' class="anchor">nginx.enabled</a>

</td>
<td>

bool

</td>
<td>

```json
false
```

</td>
<td>

Enable nginx server. You need to set an fpm version of the image for nextcloud if you want to use nginx!

</td>
</tr>
		<tr>
<td>

<a id='nginx.image' class="anchor">nginx.image</a>

</td>
<td>

object/container-image

</td>
<td>

<details>
<summary>+Expand</summary>

```yaml
repository: nginx
tag: alpine
pullPolicy: IfNotPresent
```

</details>

</td>
<td>

Image map for nginx

</td>
</tr>
		<tr>
<td>

<a id='nginx.resources' class="anchor">nginx.resources</a>

</td>
<td>

object

</td>
<td>

```json
{}
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='persistence' class="anchor">persistence</a>

</td>
<td>

dict

</td>
<td>

<details>
<summary>+Expand</summary>

```yaml
# -- (bool) Set to true to use persistence. By default it is using
# the default storage class.
# By default Nextcloud Data is in /var/www/html inside the container
enabled: false
annotations: {}
# -- (string) nextcloud data Persistent Volume Storage Class
# @section
#
# If defined, storageClassName: <storageClass>
#
# If set to "-", storageClassName: "", which disables dynamic provisioning
#
# If undefined (the default) or set to null, no storageClassName spec is
# set, choosing the default provisioner.  (gp2 on AWS, standard on
# GKE, AWS & OpenStack)
storageClass: null
# -- (tpl/string) A manually managed Persistent Volume and Claim
# Requires persistence.enabled: true
# If defined, PVC must be created manually before volume will be bound
existingClaim: null
accessMode: ReadWriteOnce
size: 8Gi
```

</details>

</td>
<td>

Enable persistence using Persistent Volume Claims ref: http://kubernetes.io/docs/user-guide/persistent-volumes/

</td>
</tr>
		<tr>
<td>

<a id='persistence.enabled' class="anchor">persistence.enabled</a>

</td>
<td>

bool

</td>
<td>

```json
false
```

</td>
<td>

Set to true to use persistence. By default it is using the default storage class. By default Nextcloud Data is in /var/www/html inside the container

</td>
</tr>
		<tr>
<td>

<a id='persistence.existingClaim' class="anchor">persistence.existingClaim</a>

</td>
<td>

tpl/string

</td>
<td>

```json
null
```

</td>
<td>

A manually managed Persistent Volume and Claim Requires persistence.enabled: true If defined, PVC must be created manually before volume will be bound

</td>
</tr>
		<tr>
<td>

<a id='persistence.storageClass' class="anchor">persistence.storageClass</a>

</td>
<td>

string

</td>
<td>

```json
null
```

</td>
<td>

nextcloud data Persistent Volume Storage Class

If defined, storageClassName: <storageClass>

If set to "-", storageClassName: "", which disables dynamic provisioning

If undefined (the default) or set to null, no storageClassName spec is
set, choosing the default provisioner.  (gp2 on AWS, standard on
GKE, AWS & OpenStack)

</td>
</tr>
		<tr>
<td>

<a id='podAnnotations' class="anchor">podAnnotations</a>

</td>
<td>

tpl/string

</td>
<td>

```yaml
podAnnotations: |
```

</td>
<td>

Custom pod annotations. Will be added to every pod created by this chart

</td>
</tr>
		<tr>
<td>

<a id='podLabels' class="anchor">podLabels</a>

</td>
<td>

tpl/string

</td>
<td>

```yaml
podLabels: |
```

</td>
<td>

Custom pod label. Will be added to every pod created by this chart

</td>
</tr>
		<tr>
<td>

<a id='postgis.enabled' class="anchor">postgis.enabled</a>

</td>
<td>

bool

</td>
<td>

```json
false
```

</td>
<td>

Enable postgis as database backend by default. Set to false if using different external backend.

</td>
</tr>
		<tr>
<td>

<a id='postgis.existingSecret' class="anchor">postgis.existingSecret</a>

</td>
<td>

tpl/string

</td>
<td>

```yaml
postgis.existingSecret: |
```

</td>
<td>

Existing secret to be used

</td>
</tr>
		<tr>
<td>

<a id='postgis.extraConfigMap' class="anchor">postgis.extraConfigMap</a>

</td>
<td>

tpl/object

</td>
<td>

<details>
<summary>+Expand</summary>

```yaml
postgis.extraConfigMap: |
  nextcloud-db.sh: |
    #!/usr/bin/env bash
    DATABASE="{{ .Values.global.databaseName }}"
    # password comes from environment variables, so it can be retrieved from secret
    DATABASE_USER="{{ .Values.global.databaseUsername }}"
    # create database
    su postgres -c "createdb ${DATABASE}"
    # create role
    cat << EOF | su postgres -c "psql"
    CREATE ROLE ${DATABASE_USER};
    EOF
    # modify permissions
    cat << EOF | su postgres -c "psql -d ${DATABASE}"
    -- Create role
    ALTER ROLE ${DATABASE_USER} LOGIN PASSWORD '${DATABASE_PASSWORD}';
    ALTER DATABASE ${DATABASE} OWNER TO ${DATABASE_USER};
    GRANT ALL PRIVILEGES ON DATABASE ${DATABASE} TO ${DATABASE_USER};
    EOF
```

</details>

</td>
<td>

Extra config map for postgis to be included. Can be used to pregenerate database and roles for first setup

</td>
</tr>
		<tr>
<td>

<a id='postgis.extraPodEnv' class="anchor">postgis.extraPodEnv</a>

</td>
<td>

tpl/array

</td>
<td>

<details>
<summary>+Expand</summary>

```yaml
postgis.extraPodEnv: |
  - name: DATABASE_PASSWORD
    valueFrom:
      secretKeyRef:
        name: {{ include "common.sharedSecretName" . | quote }}
        key: {{ .Values.global.databasePassword.valueFrom.secretKeyRef.key }}
```

</details>

</td>
<td>

Extra pod env for postgis We expose database password in case we need to pregenerate it

</td>
</tr>
		<tr>
<td>

<a id='postgis.extraVolume' class="anchor">postgis.extraVolume</a>

</td>
<td>

tpl/array

</td>
<td>

<details>
<summary>+Expand</summary>

```yaml
postgis.extraVolume: |
  - name: config-volume
    configMap:
      name: {{ template "common.fullname" . }}
      defaultMode: 0755
```

</details>

</td>
<td>

Extra volume declaration for postgis We use extra volume to mount postgis configmap to pregenerate database

</td>
</tr>
		<tr>
<td>

<a id='postgis.extraVolumeMounts' class="anchor">postgis.extraVolumeMounts</a>

</td>
<td>

tpl/array

</td>
<td>

<details>
<summary>+Expand</summary>

```yaml
postgis.extraVolumeMounts: |
  - mountPath: /docker-entrypoint-initdb.d/nextcloud-db.sh
    subPath: nextcloud-db.sh
    name: config-volume
```

</details>

</td>
<td>

Extra volume mounts for postgis We use extra volume mounts postgis configmap to pregenerate database

</td>
</tr>
		<tr>
<td>

<a id='postgis.nameOverride' class="anchor">postgis.nameOverride</a>

</td>
<td>

string

</td>
<td>

```json
"postgis"
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='postgis.postgresqlDatabase' class="anchor">postgis.postgresqlDatabase</a>

</td>
<td>

string

</td>
<td>

```json
"nextcloud"
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='postgis.postgresqlPassword' class="anchor">postgis.postgresqlPassword</a>

</td>
<td>

object/common.secret

</td>
<td>

```yaml
value:
```

</td>
<td>

Postgres super user password. It can be different than [global.databasePassword](#global.databasePassword)

</td>
</tr>
		<tr>
<td>

<a id='postgis.postgresqlUsername' class="anchor">postgis.postgresqlUsername</a>

</td>
<td>

string

</td>
<td>

```json
"superuser"
```

</td>
<td>

Postgres super user account. It can be different than [global.databaseUsername](#global.databaseUsername)

</td>
</tr>
		<tr>
<td>

<a id='probe' class="anchor">probe</a>

</td>
<td>

tpl/string

</td>
<td>

```yaml
probe: |
```

</td>
<td>

Liveness and readiness probe values

Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes
Can also be overridden from [extraPodSpec](#extraPodSpec)

```yaml
livenessProbe:
  initialDelaySeconds: 30
  periodSeconds: 15
  timeoutSeconds: 5
  failureThreshold: 3
  successThreshold: 1
readinessProbe:
  initialDelaySeconds: 30
  periodSeconds: 15
  timeoutSeconds: 5
  failureThreshold: 3
  successThreshold: 1
```

</td>
</tr>
		<tr>
<td>

<a id='redis.auth.existingSecret' class="anchor">redis.auth.existingSecret</a>

</td>
<td>

string

</td>
<td>

```json
"nextcloud-shared-secret"
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='redis.auth.existingSecretPasswordKey' class="anchor">redis.auth.existingSecretPasswordKey</a>

</td>
<td>

string

</td>
<td>

```json
"redis-password"
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='redis.enabled' class="anchor">redis.enabled</a>

</td>
<td>

bool

</td>
<td>

```json
false
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='redis.usePassword' class="anchor">redis.usePassword</a>

</td>
<td>

bool

</td>
<td>

```json
false
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='replicaCount' class="anchor">replicaCount</a>

</td>
<td>

int

</td>
<td>

```json
1
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='resources' class="anchor">resources</a>

</td>
<td>

dict

</td>
<td>

```yaml
map[]
```

</td>
<td>

Resource allocation

We usually recommend not to specify default resources and to leave this as a conscious
choice for the user. This also increases chances charts run on environments with little
resources, such as Minikube. If you do want to specify resources, uncomment the following
lines, adjust them as necessary, and remove the curly braces after 'resources:'.

```yaml
limits:
  cpu: 100m
  memory: 128Mi
requests:
  cpu: 100m
  memory: 128Mi
```

</td>
</tr>
		<tr>
<td>

<a id='securityContext' class="anchor">securityContext</a>

</td>
<td>

tpl/string

</td>
<td>

<details>
<summary>+Expand</summary>

```yaml
securityContext: |
  {{- if .Values.nginx.enabled }}
  # Will mount configuration files as www-data (id: 82) for nextcloud
  fsGroup: 82
  {{- else }}
  # Will mount configuration files as www-data (id: 33) for nextcloud
  fsGroup: 33
  {{- end }}
```

</details>

</td>
<td>

Custom security context because it depends on which http server is used.

</td>
</tr>
		<tr>
<td>

<a id='service.loadBalancerIP' class="anchor">service.loadBalancerIP</a>

</td>
<td>

string

</td>
<td>

```json
"nil"
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='service.nodePort' class="anchor">service.nodePort</a>

</td>
<td>

string

</td>
<td>

```json
"nil"
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='service.port' class="anchor">service.port</a>

</td>
<td>

int

</td>
<td>

```json
8080
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='service.type' class="anchor">service.type</a>

</td>
<td>

string

</td>
<td>

```json
"ClusterIP"
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='test.nextcloud.containers' class="anchor">test.nextcloud.containers</a>

</td>
<td>

string

</td>
<td>

```json
""
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='test.nextcloud.host' class="anchor">test.nextcloud.host</a>

</td>
<td>

string

</td>
<td>

```json
""
```

</td>
<td>

</td>
</tr>
		<tr>
<td>

<a id='test.nextcloud.insecureHost' class="anchor">test.nextcloud.insecureHost</a>

</td>
<td>

bool

</td>
<td>

```json
true
```

</td>
<td>

</td>
</tr>
	</tbody>
</table>

# Helm-Docs Chart Template Version
common-v1.1.0
