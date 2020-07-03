{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "geonode.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- $fullname := default (printf "%s-%s" .Release.Name $name) .Values.fullnameOverride -}}
{{- printf "%s" $fullname | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "geonode.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Return the proper geonode image name
*/}}
{{- define "geonode.image" -}}
{{- $registryName := .Values.image.registry -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $tag := .Values.image.tag | toString -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
        {{- printf "%s/%s:%s" .Values.global.imageRegistry $repositoryName $tag -}}
    {{- else -}}
        {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{/*
Derive shared secret name for this release
Must only depends on global values
*/}}
{{- define "geonode.sharedSecretName" -}}
	{{- $secretName := default (tpl .Values.global.sharedSecretName $) (tpl .Values.global.existingSecret $) -}}
	{{- default .Release.Name $secretName -}}
{{- end -}}

{{/*
Get the secret from declared source
*/}}
{{- define "geonode.secretFrom" -}}
valueFrom:
  secretKeyRef:
  {{- if .Value.valueFrom.secretKeyRef.name }}
    name: {{ .Value.valueFrom.secretKeyRef.name | quote }}
  {{- else }}
    name: {{ include "geonode.sharedSecretName" .Context | quote }}
  {{- end }}
    key: {{ .Value.valueFrom.secretKeyRef.key | quote }}
{{- end -}}

{{/*
Get the password secret.
*/}}
{{- define "geonode.secretName" -}}
{{- if .Value.valueFrom.secretKeyRef.name -}}
    {{- printf "%s" (tpl .valueFrom.secretKeyRef.name $) -}}
{{- else -}}
    {{- printf "%s" (include "geonode.sharedSecretName" .Context) -}}
{{- end -}}
{{- end -}}

{{/*
Get the password ref key.
*/}}
{{- define "geonode.secretKey" -}}
	{{- .valueFrom.secretKeyRef.key -}}
{{- end -}}

{{/*
Return password or secret value from values.yml or generate if it doesn't exists
*/}}
{{- define "geonode.secretValue" -}}
{{- if .value -}}
	{{- .value -}}
{{- else if .valueFrom -}}
    {{- randAlphaNum 10 -}}
{{- end -}}
{{- end -}}

{{/*
Return ALLOWED_HOSTS python formatted lists
*/}}
{{- define "geonode.allowedHosts" -}}
"['nginx','127.0.0.1','localhost','{{ .Values.global.geonodeSiteName }}']"
{{- end -}}

{{/*
Return GeoServer Base URL to be used
*/}}
{{- define "geonode.geoserverURL" -}}
{{- if not .Values.geoserver.enabled -}}
	{{- (tpl .Values.global.geoserverURL $) -}}
{{- else -}}
	{{- printf "http://%s-geoserver/geoserver/" (include "geonode.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return database host to be used
*/}}
{{- define "geonode.databaseHost" -}}
{{- if not .Values.postgis.enabled -}}
	{{- (tpl .Values.global.databaseHost $) -}}
{{- else -}}
	{{- include "geonode.fullname" . -}}-database
{{- end -}}
{{- end -}}


{{/*
Return geodatabase host to be used
*/}}
{{- define "geonode.geodatabaseHost" -}}
{{- if not .Values.postgis.enabled -}}
	{{- (tpl .Values.global.geodatabaseHost $) -}}
{{- else -}}
	{{- include "geonode.fullname" . -}}-geodatabase
{{- end -}}
{{- end -}}
