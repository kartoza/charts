

# postgis

![Version: 0.2.2](https://img.shields.io/badge/Version-0.2.2-informational?style=flat-square) ![AppVersion: 13-3](https://img.shields.io/badge/AppVersion-13--3-informational?style=flat-square)

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
<table height="400px">
	<thead>
		<th>Key</th>
		<th>Type</th>
		<th>Default</th>
		<th>Description</th>
	</thead>
	<tbody>
		<tr>
			<td><a id="existingSecret">existingSecret</a></td>
			<td>tpl/string</td>
			<td><pre lang="gotpl">
existingSecret: |
 
</pre></td>
			<td>Use this if you have predefined secrets object</td>
		</tr>
		<tr>
			<td><a id="extraConfigMap">extraConfigMap</a></td>
			<td>tpl/map</td>
			<td><pre lang="gotpl">
extraConfigMap: |
  #file_1: "conf content"
 
</pre></td>
			<td>Define this for extra config map</td>
		</tr>
		<tr>
			<td><a id="extraPodEnv">extraPodEnv</a></td>
			<td>tpl/list</td>
			<td><pre lang="gotpl">
extraPodEnv: |
  #- name: KEY_1
  #  value: "VALUE_1"
  #- name: KEY_2
  #  value: "VALUE_2"
  - name: PASSWORD_AUTHENTICATION
    value: "md5"
 
</pre></td>
			<td>Define this for extra pod environment variables</td>
		</tr>
		<tr>
			<td><a id="extraPodSpec">extraPodSpec</a></td>
			<td>tpl/map</td>
			<td><pre lang="gotpl">
extraPodSpec: |
  ##You can set pod attribute if needed
  #ports:
  #  - containerPort: 5432
  #    name: tcp-port
 
</pre></td>
			<td>This will be evaluated as pod spec</td>
		</tr>
		<tr>
			<td><a id="extraSecret">extraSecret</a></td>
			<td>tpl/map</td>
			<td><pre lang="gotpl">
extraSecret: |
  #key_1: value_1
 
</pre></td>
			<td>Define this for extra secrets to be included</td>
		</tr>
		<tr>
			<td><a id="extraVolume">extraVolume</a></td>
			<td>tpl/list</td>
			<td><pre lang="gotpl">
extraVolume: |
  ##You may potentially mount a config map/secret
  #- name: custom-config
  #  configMap:
  #    name: geoserver-config
 
</pre></td>
			<td>Define this for extra volume (in pair with extraVolumeMounts)</td>
		</tr>
		<tr>
			<td><a id="extraVolumeMounts">extraVolumeMounts</a></td>
			<td>tpl/list</td>
			<td><pre lang="gotpl">
extraVolumeMounts: |
  ##You may potentially mount a config map/secret
  #- name: custom-config
  #  mountPath: /docker-entrypoint.sh
  #  subPath: docker-entrypoint.sh
  #  readOnly: true
 
</pre></td>
			<td>Define this for extra volume mounts in the pod</td>
		</tr>
		<tr>
			<td><a id="global--storageClass">global.storageClass</a></td>
			<td>string</td>
			<td><pre lang="json">
null
</pre></td>
			<td>Storage class name used to provision PV</td>
		</tr>
		<tr>
			<td><a id="image">image</a></td>
			<td>object/container-image</td>
			<td><pre lang="yaml">
# -- Image registry
registry: docker.io
# -- Image repository
repository: kartoza/postgis
# -- Image tag
tag: "13-3"
# -- (k8s/containers/image/imagePullPolicy) Image pullPolicy
pullPolicy: IfNotPresent

</pre></td>
			<td>Image map</td>
		</tr>
		<tr>
			<td><a id="image--pullPolicy">image.pullPolicy</a></td>
			<td>k8s/containers/image/imagePullPolicy</td>
			<td><pre lang="json">
"IfNotPresent"
</pre></td>
			<td>Image pullPolicy</td>
		</tr>
		<tr>
			<td><a id="image--registry">image.registry</a></td>
			<td>string</td>
			<td><pre lang="json">
"docker.io"
</pre></td>
			<td>Image registry</td>
		</tr>
		<tr>
			<td><a id="image--repository">image.repository</a></td>
			<td>string</td>
			<td><pre lang="json">
"kartoza/postgis"
</pre></td>
			<td>Image repository</td>
		</tr>
		<tr>
			<td><a id="image--tag">image.tag</a></td>
			<td>string</td>
			<td><pre lang="json">
"13-3"
</pre></td>
			<td>Image tag</td>
		</tr>
		<tr>
			<td><a id="persistence--accessModes">persistence.accessModes</a></td>
			<td>list</td>
			<td><pre lang="json">
[
  "ReadWriteOnce"
]
</pre></td>
			<td>Default Access Modes</td>
		</tr>
		<tr>
			<td><a id="persistence--annotations">persistence.annotations</a></td>
			<td>map</td>
			<td><pre lang="json">
{}
</pre></td>
			<td>You can specify extra annotations here</td>
		</tr>
		<tr>
			<td><a id="persistence--enabled">persistence.enabled</a></td>
			<td>bool</td>
			<td><pre lang="json">
true
</pre></td>
			<td>Enable persistence. If set to false, the data directory will use ephemeral volume</td>
		</tr>
		<tr>
			<td><a id="persistence--existingClaim">persistence.existingClaim</a></td>
			<td>string</td>
			<td><pre lang="gotpl">
persistence.existingClaim: |
 
</pre></td>
			<td>A manually managed Persistent Volume and Claim If defined, PVC must be created manually before volume will be bound The value is evaluated as a template, so, for example, the name can depend on .Release or .Chart</td>
		</tr>
		<tr>
			<td><a id="persistence--mountPath">persistence.mountPath</a></td>
			<td>path</td>
			<td><pre lang="json">
"/opt/kartoza/postgis/data"
</pre></td>
			<td>The path the volume will be mounted at, useful when using different PostgreSQL images.</td>
		</tr>
		<tr>
			<td><a id="persistence--size">persistence.size</a></td>
			<td>string/size</td>
			<td><pre lang="json">
"8Gi"
</pre></td>
			<td>Size of the PV</td>
		</tr>
		<tr>
			<td><a id="persistence--storageClass">persistence.storageClass</a></td>
			<td>string</td>
			<td><pre lang="json">
null
</pre></td>
			<td>Storage class name used to provision PV</td>
		</tr>
		<tr>
			<td><a id="persistence--subPath">persistence.subPath</a></td>
			<td>string</td>
			<td><pre lang="json">
"data"
</pre></td>
			<td>The subdirectory of the volume to mount to, useful in dev environments and one PV for multiple services. Default provisioner usually have .lost+found directory, so you might want to use this so the container can have empty volume</td>
		</tr>
		<tr>
			<td><a id="postgresqlDataDir">postgresqlDataDir</a></td>
			<td>path</td>
			<td><pre lang="json">
"/opt/kartoza/postgis/data"
</pre></td>
			<td>PostgreSQL data dir. Location where you want to store the stateful data</td>
		</tr>
		<tr>
			<td><a id="postgresqlDatabase">postgresqlDatabase</a></td>
			<td>string</td>
			<td><pre lang="json">
"gis"
</pre></td>
			<td>default generated database name if the image support it, pass a comma-separated list of database name, and it will be exposed in environment variable POSTGRES_DBNAME. The first database will be used to check connection in the probe.</td>
		</tr>
		<tr>
			<td><a id="postgresqlPassword">postgresqlPassword</a></td>
			<td>object/common.secret</td>
			<td><pre lang="yaml">
# -- (string) Specify this password value. If not, it will be
# autogenerated everytime chart upgraded
value:
valueFrom:
    secretKeyRef:
        name:
        key: postgresql-password

</pre></td>
			<td>Secret structure for postgres super user password Use this for prefilled password</td>
		</tr>
		<tr>
			<td><a id="postgresqlPassword--value">postgresqlPassword.value</a></td>
			<td>string</td>
			<td><pre lang="json">
null
</pre></td>
			<td>Specify this password value. If not, it will be autogenerated everytime chart upgraded</td>
		</tr>
		<tr>
			<td><a id="postgresqlUsername">postgresqlUsername</a></td>
			<td>string</td>
			<td><pre lang="json">
"docker"
</pre></td>
			<td>postgres super user</td>
		</tr>
		<tr>
			<td><a id="probe">probe</a></td>
			<td>k8s/containers/probe</td>
			<td><pre lang="gotpl">
probe: |
 
</pre></td>
			<td>Probe can be overridden If set empty, it will use default probe</td>
		</tr>
		<tr>
			<td><a id="securityContext">securityContext</a></td>
			<td>k8s/containers/securityContext</td>
			<td><pre lang="gotpl">
securityContext: |
  ##You have to use fsGroup if you use custom certificate
  #fsGroup: 101  # postgres group
  #runAsUser: 1000  # run as root
  #runAsGroup: 1000  # run as root
 
</pre></td>
			<td>Define this if you want more control with the security context of the pods</td>
		</tr>
		<tr>
			<td><a id="service--annotations">service.annotations</a></td>
			<td>tpl/map</td>
			<td><pre lang="gotpl">
service.annotations: |
 
</pre></td>
			<td>Provide any additional annotations which may be required. Evaluated as a template.</td>
		</tr>
		<tr>
			<td><a id="service--clusterIP">service.clusterIP</a></td>
			<td>k8s/service/clusterIP</td>
			<td><pre lang="json">
"None"
</pre></td>
			<td>Set to None for Headless Service Otherwise set to "" to give a default cluster IP</td>
		</tr>
		<tr>
			<td><a id="service--labels">service.labels</a></td>
			<td>tpl/map</td>
			<td><pre lang="gotpl">
service.labels: |
 
</pre></td>
			<td>Provide any additional annotations which may be required. Evaluated as a template.</td>
		</tr>
		<tr>
			<td><a id="service--loadBalancerIP">service.loadBalancerIP</a></td>
			<td>k8s/service/loadBalancerIP</td>
			<td><pre lang="json">
null
</pre></td>
			<td>Set the LoadBalancer service type to internal only. <a href="https://kubernetes.io/docs/concepts/services-networking/service/#internal-load-balancer">ref</a></td>
		</tr>
		<tr>
			<td><a id="service--nodePort">service.nodePort</a></td>
			<td>k8s/service/nodePort</td>
			<td><pre lang="json">
null
</pre></td>
			<td>Specify the nodePort value for the LoadBalancer and NodePort service types. <a href="https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport">ref</a></td>
		</tr>
		<tr>
			<td><a id="service--port">service.port</a></td>
			<td>k8s/service/port</td>
			<td><pre lang="json">
5432
</pre></td>
			<td>Default TCP port</td>
		</tr>
		<tr>
			<td><a id="service--type">service.type</a></td>
			<td>k8s/service/type</td>
			<td><pre lang="json">
"ClusterIP"
</pre></td>
			<td>PostgresSQL service type</td>
		</tr>
		<tr>
			<td><a id="test--postgis--containers">test.postgis.containers</a></td>
			<td>tpl/array</td>
			<td><pre lang="json">
null
</pre></td>
			<td>List of containers override for testing</td>
		</tr>
		<tr>
			<td><a id="tls--ca_file">tls.ca_file</a></td>
			<td>string</td>
			<td><pre lang="json">
"ca.crt"
</pre></td>
			<td>Subpath of the secret CA</td>
		</tr>
		<tr>
			<td><a id="tls--cert_file">tls.cert_file</a></td>
			<td>string</td>
			<td><pre lang="json">
"tls.crt"
</pre></td>
			<td>Subpath of the secret Cert file</td>
		</tr>
		<tr>
			<td><a id="tls--enabled">tls.enabled</a></td>
			<td>bool</td>
			<td><pre lang="json">
false
</pre></td>
			<td>Enable to true if you can specify where the certificate is located. You must also enable securityContext.fsGroup if you want to use tls</td>
		</tr>
		<tr>
			<td><a id="tls--key_file">tls.key_file</a></td>
			<td>string</td>
			<td><pre lang="json">
"tls.key"
</pre></td>
			<td>Subpath of the secret TLS key</td>
		</tr>
		<tr>
			<td><a id="tls--secretName">tls.secretName</a></td>
			<td>string</td>
			<td><pre lang="json">
null
</pre></td>
			<td>Secret of a Certificate kind that stores the certificate</td>
		</tr>
	</tbody>
</table>

# Helm-Docs Chart Template Version
common-v1.0.1
