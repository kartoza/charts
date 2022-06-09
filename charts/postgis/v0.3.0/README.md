

# postgis

![Version: 0.2.4](https://img.shields.io/badge/Version-0.2.4-informational?style=flat-square) ![AppVersion: 13-3.1](https://img.shields.io/badge/AppVersion-13--3.1-informational?style=flat-square)

Chart for postgis

**Homepage:** <https://postgis.net/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| lucernae | lana.pcfre@gmail.com |  |

## Source Code

* <https://github.com/kartoza/docker-postgis>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| [../../common/v1.0.1](../../common/v1.0.1) | common | 1.0.1 |

# Long Description

This is Kartoza's Postgis Rancher charts

Postgis is an extension of PostgreSQL database with added support for
Spatial Data

# How to Use

For helm:

```bash
helm install release-name kartoza/postgis
```

# Intro

This chart bootstrap a PostgreSQL database with Postgis installed in its
main database.
It behaves like a PostgreSQL database, but with Postgis extension installed
in its database.

# What it can do

The default install uses kartoza/postgis image, which can do the following:

- Generate superuser roles at startup
- Generate new database at startup if volume empty
- Generate one or more database with Postgis installed
- Accept locale and collations settings for the database
- Default TLS enabled
- GDAL Driver installed
- Support out-of-db rasters
- Enable multiple extensions

You can override the image to use your own Postgre Image.

# Common use case

## Using it as a headless service

By default, we created a Headless service. Headless service can only be
accessed within the cluster itself.
The name of the service can be used as the hostname.
If you need to expose this, you can further cascade it using
LoadBalancer or NodePort.

## Using custom certificate in conjunction with cert-manager.io

With cert-manager you can automatically create certificate. First, you need
an issuer and also the certificate request object.
Cert-manager will then create the certificate and store it into a secret.
This should happen before you create the Postgis App.

Use the generated secret by filling out `tls` config options.
Because Postgres works in L3/4 Layer, the generated CA must be accepted by
your OS if you want to connect using self-signed certificate.
If not, then you can just ignore the warning. However some Database client
will check the CA, depending on what is the mode of the connection,
which can be: disable, allow, required, verify-ca, verify-full.

## Executing scripts after the database starts

Sometimes you want to execute certain scripts after the database is ready.
Our default image can do that (and most Postgres image based on official Postgres).

The best way would be to create a ConfigMap with your scripts in it, then
apply it to your Kubernetes Cluster.
Reference:
https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap

Then mount it to the pod using our [extraVolume](#extraVolume) and
[extraVolumeMounts](#extraVolumeMounts) config.
If you mount it in the pod's path: `/docker-entrypoint-initdb.d/` ,
it will be scanned by the image.
The executed scripts are only files with the extensions `.sql` and `.sh`.

Depending on the postgres image you use, you can also mount it to directory
where the entrypoint script will be executed according to that image
implementations.

## Replications

TODO: Describe how replication works with stateful set pods.

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

<a id="existingSecret" class="anchor">existingSecret</a>

</td>
<td>

tpl/string

</td>
<td>

```yaml
existingSecret: |
```

</td>
<td>

Use this if you have predefined secrets object

</td>
</tr>
		<tr>
<td>

<a id="extraConfigMap" class="anchor">extraConfigMap</a>

</td>
<td>

tpl/map

</td>
<td>

```yaml
extraConfigMap: |
  #file_1: "conf content"
```

</td>
<td>

Define this for extra config map

</td>
</tr>
		<tr>
<td>

<a id="extraPodEnv" class="anchor">extraPodEnv</a>

</td>
<td>

tpl/list

</td>
<td>

<details>
<summary>+Expand</summary>

```yaml
extraPodEnv: |
  #- name: KEY_1
  #  value: "VALUE_1"
  #- name: KEY_2
  #  value: "VALUE_2"
  - name: PASSWORD_AUTHENTICATION
    value: "md5"
```

</details>

</td>
<td>

Define this for extra pod environment variables

</td>
</tr>
		<tr>
<td>

<a id="extraPodSpec" class="anchor">extraPodSpec</a>

</td>
<td>

tpl/map

</td>
<td>

<details>
<summary>+Expand</summary>

```yaml
extraPodSpec: |
  ##You can set pod attribute if needed
  #ports:
  #  - containerPort: 5432
  #    name: tcp-port
```

</details>

</td>
<td>

This will be evaluated as pod spec

</td>
</tr>
		<tr>
<td>

<a id="extraSecret" class="anchor">extraSecret</a>

</td>
<td>

tpl/map

</td>
<td>

```yaml
extraSecret: |
  #key_1: value_1
```

</td>
<td>

Define this for extra secrets to be included

</td>
</tr>
		<tr>
<td>

<a id="extraVolume" class="anchor">extraVolume</a>

</td>
<td>

tpl/list

</td>
<td>

<details>
<summary>+Expand</summary>

```yaml
extraVolume: |
  ##You may potentially mount a config map/secret
  #- name: custom-config
  #  configMap:
  #    name: geoserver-config
```

</details>

</td>
<td>

Define this for extra volume (in pair with extraVolumeMounts)

</td>
</tr>
		<tr>
<td>

<a id="extraVolumeMounts" class="anchor">extraVolumeMounts</a>

</td>
<td>

tpl/list

</td>
<td>

<details>
<summary>+Expand</summary>

```yaml
extraVolumeMounts: |
  ##You may potentially mount a config map/secret
  #- name: custom-config
  #  mountPath: /docker-entrypoint.sh
  #  subPath: docker-entrypoint.sh
  #  readOnly: true
```

</details>

</td>
<td>

Define this for extra volume mounts in the pod

</td>
</tr>
		<tr>
<td>

<a id="global.storageClass" class="anchor">global.storageClass</a>

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

Storage class name used to provision PV

</td>
</tr>
		<tr>
<td>

<a id="image" class="anchor">image</a>

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
repository: kartoza/postgis
# -- Image tag
tag: "13-3.1"
# -- (k8s/containers/image/imagePullPolicy) Image pullPolicy
pullPolicy: IfNotPresent
```

</details>

</td>
<td>

Image map

</td>
</tr>
		<tr>
<td>

<a id="image.pullPolicy" class="anchor">image.pullPolicy</a>

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

<a id="image.registry" class="anchor">image.registry</a>

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

<a id="image.repository" class="anchor">image.repository</a>

</td>
<td>

string

</td>
<td>

```json
"kartoza/postgis"
```

</td>
<td>

Image repository

</td>
</tr>
		<tr>
<td>

<a id="image.tag" class="anchor">image.tag</a>

</td>
<td>

string

</td>
<td>

```json
"13-3.1"
```

</td>
<td>

Image tag

</td>
</tr>
		<tr>
<td>

<a id="persistence.accessModes" class="anchor">persistence.accessModes</a>

</td>
<td>

list

</td>
<td>

```json
[
  "ReadWriteOnce"
]
```

</td>
<td>

Default Access Modes

</td>
</tr>
		<tr>
<td>

<a id="persistence.annotations" class="anchor">persistence.annotations</a>

</td>
<td>

map

</td>
<td>

```json
{}
```

</td>
<td>

You can specify extra annotations here

</td>
</tr>
		<tr>
<td>

<a id="persistence.enabled" class="anchor">persistence.enabled</a>

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

Enable persistence. If set to false, the data directory will use ephemeral volume

</td>
</tr>
		<tr>
<td>

<a id="persistence.existingClaim" class="anchor">persistence.existingClaim</a>

</td>
<td>

string

</td>
<td>

```yaml
persistence.existingClaim: |
```

</td>
<td>

A manually managed Persistent Volume and Claim If defined, PVC must be created manually before volume will be bound The value is evaluated as a template, so, for example, the name can depend on .Release or .Chart

</td>
</tr>
		<tr>
<td>

<a id="persistence.mountPath" class="anchor">persistence.mountPath</a>

</td>
<td>

path

</td>
<td>

```json
"/opt/kartoza/postgis/data"
```

</td>
<td>

The path the volume will be mounted at, useful when using different PostgreSQL images.

</td>
</tr>
		<tr>
<td>

<a id="persistence.size" class="anchor">persistence.size</a>

</td>
<td>

string/size

</td>
<td>

```json
"8Gi"
```

</td>
<td>

Size of the PV

</td>
</tr>
		<tr>
<td>

<a id="persistence.storageClass" class="anchor">persistence.storageClass</a>

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

Storage class name used to provision PV

</td>
</tr>
		<tr>
<td>

<a id="persistence.subPath" class="anchor">persistence.subPath</a>

</td>
<td>

string

</td>
<td>

```json
"data"
```

</td>
<td>

The subdirectory of the volume to mount to, useful in dev environments and one PV for multiple services. Default provisioner usually have .lost+found directory, so you might want to use this so the container can have empty volume

</td>
</tr>
		<tr>
<td>

<a id="postgresqlDataDir" class="anchor">postgresqlDataDir</a>

</td>
<td>

path

</td>
<td>

```json
"/opt/kartoza/postgis/data"
```

</td>
<td>

PostgreSQL data dir. Location where you want to store the stateful data

</td>
</tr>
		<tr>
<td>

<a id="postgresqlDatabase" class="anchor">postgresqlDatabase</a>

</td>
<td>

string

</td>
<td>

```json
"gis"
```

</td>
<td>

default generated database name if the image support it, pass a comma-separated list of database name, and it will be exposed in environment variable POSTGRES_DBNAME. The first database will be used to check connection in the probe.

</td>
</tr>
		<tr>
<td>

<a id="postgresqlPassword" class="anchor">postgresqlPassword</a>

</td>
<td>

object/common.secret

</td>
<td>

<details>
<summary>+Expand</summary>

```yaml
# -- (string) Specify this password value. If not, it will be
# autogenerated everytime chart upgraded
value:
valueFrom:
    secretKeyRef:
        name:
        key: postgresql-password
```

</details>

</td>
<td>

Secret structure for postgres super user password Use this for prefilled password

</td>
</tr>
		<tr>
<td>

<a id="postgresqlPassword.value" class="anchor">postgresqlPassword.value</a>

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

Specify this password value. If not, it will be autogenerated everytime chart upgraded

</td>
</tr>
		<tr>
<td>

<a id="postgresqlUsername" class="anchor">postgresqlUsername</a>

</td>
<td>

string

</td>
<td>

```json
"docker"
```

</td>
<td>

postgres super user

</td>
</tr>
		<tr>
<td>

<a id="probe" class="anchor">probe</a>

</td>
<td>

k8s/containers/probe

</td>
<td>

```yaml
probe: |
```

</td>
<td>

Probe can be overridden If set empty, it will use default probe

</td>
</tr>
		<tr>
<td>

<a id="securityContext" class="anchor">securityContext</a>

</td>
<td>

k8s/containers/securityContext

</td>
<td>

<details>
<summary>+Expand</summary>

```yaml
securityContext: |
  ##You have to use fsGroup if you use custom certificate
  #fsGroup: 101  # postgres group
  #runAsUser: 1000  # run as root
  #runAsGroup: 1000  # run as root
```

</details>

</td>
<td>

Define this if you want more control with the security context of the pods

</td>
</tr>
		<tr>
<td>

<a id="service.annotations" class="anchor">service.annotations</a>

</td>
<td>

tpl/map

</td>
<td>

```yaml
service.annotations: |
```

</td>
<td>

Provide any additional annotations which may be required. Evaluated as a template.

</td>
</tr>
		<tr>
<td>

<a id="service.clusterIP" class="anchor">service.clusterIP</a>

</td>
<td>

k8s/service/clusterIP

</td>
<td>

```json
"None"
```

</td>
<td>

Set to None for Headless Service Otherwise set to "" to give a default cluster IP

</td>
</tr>
		<tr>
<td>

<a id="service.labels" class="anchor">service.labels</a>

</td>
<td>

tpl/map

</td>
<td>

```yaml
service.labels: |
```

</td>
<td>

Provide any additional annotations which may be required. Evaluated as a template.

</td>
</tr>
		<tr>
<td>

<a id="service.loadBalancerIP" class="anchor">service.loadBalancerIP</a>

</td>
<td>

k8s/service/loadBalancerIP

</td>
<td>

```json
null
```

</td>
<td>

Set the LoadBalancer service type to internal only. [ref](https://kubernetes.io/docs/concepts/services-networking/service/#internal-load-balancer)

</td>
</tr>
		<tr>
<td>

<a id="service.nodePort" class="anchor">service.nodePort</a>

</td>
<td>

k8s/service/nodePort

</td>
<td>

```json
null
```

</td>
<td>

Specify the nodePort value for the LoadBalancer and NodePort service types. [ref](https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport)

</td>
</tr>
		<tr>
<td>

<a id="service.port" class="anchor">service.port</a>

</td>
<td>

k8s/service/port

</td>
<td>

```json
5432
```

</td>
<td>

Default TCP port

</td>
</tr>
		<tr>
<td>

<a id="service.type" class="anchor">service.type</a>

</td>
<td>

k8s/service/type

</td>
<td>

```json
"ClusterIP"
```

</td>
<td>

PostgresSQL service type

</td>
</tr>
		<tr>
<td>

<a id="test.postgis.containers" class="anchor">test.postgis.containers</a>

</td>
<td>

tpl/array

</td>
<td>

```json
null
```

</td>
<td>

List of containers override for testing

</td>
</tr>
		<tr>
<td>

<a id="tls.ca_file" class="anchor">tls.ca_file</a>

</td>
<td>

string

</td>
<td>

```json
"ca.crt"
```

</td>
<td>

Subpath of the secret CA

</td>
</tr>
		<tr>
<td>

<a id="tls.cert_file" class="anchor">tls.cert_file</a>

</td>
<td>

string

</td>
<td>

```json
"tls.crt"
```

</td>
<td>

Subpath of the secret Cert file

</td>
</tr>
		<tr>
<td>

<a id="tls.enabled" class="anchor">tls.enabled</a>

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

Enable to true if you can specify where the certificate is located. You must also enable securityContext.fsGroup if you want to use tls

</td>
</tr>
		<tr>
<td>

<a id="tls.key_file" class="anchor">tls.key_file</a>

</td>
<td>

string

</td>
<td>

```json
"tls.key"
```

</td>
<td>

Subpath of the secret TLS key

</td>
</tr>
		<tr>
<td>

<a id="tls.secretName" class="anchor">tls.secretName</a>

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

Secret of a Certificate kind that stores the certificate

</td>
</tr>
	</tbody>
</table>

# Helm-Docs Chart Template Version
common-v1.0.1

# Docs Version

v2021.07.24
