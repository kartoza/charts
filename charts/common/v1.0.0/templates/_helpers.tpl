{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "common.fullname" -}}
{{- $name := default .Chart.Name (default .Values.nameOverride .Values.global.nameOverride) -}}
{{- $fullname := default (printf "%s-%s" .Release.Name $name) .Values.fullnameOverride -}}
{{- printf "%s" $fullname | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "common.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Return the proper common image name
*/}}
{{- define "common.image" -}}
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
{{- define "common.sharedSecretName" -}}
	{{- $secretName := default (tpl .Values.global.sharedSecretName $) (tpl .Values.global.existingSecret $) -}}
	{{- default .Release.Name $secretName -}}
{{- end -}}

{{/*
Derive shared config name for this release
Must only depends on global values
*/}}
{{- define "common.sharedConfigName" -}}
	{{- $configName := default (tpl .Values.global.sharedConfigName $) (tpl .Values.global.existingConfig $) -}}
	{{- default .Release.Name $configName -}}
{{- end -}}

{{/*
Get the secret from declared source
*/}}
{{- define "common.secretFrom" -}}
valueFrom:
  secretKeyRef:
  {{- if .Value.valueFrom.secretKeyRef.name }}
    name: {{ .Value.valueFrom.secretKeyRef.name | quote }}
  {{- else }}
    name: {{ include "common.sharedSecretName" .Context | quote }}
  {{- end }}
    key: {{ .Value.valueFrom.secretKeyRef.key | quote }}
{{- end -}}

{{/*
Get the password secret.
*/}}
{{- define "common.secretName" -}}
{{- if .Value.valueFrom.secretKeyRef.name -}}
    {{- printf "%s" (tpl .valueFrom.secretKeyRef.name $) -}}
{{- else -}}
    {{- printf "%s" (include "common.sharedSecretName" .Context) -}}
{{- end -}}
{{- end -}}

{{/*
Get the password ref key.
*/}}
{{- define "common.secretKey" -}}
	{{- .valueFrom.secretKeyRef.key -}}
{{- end -}}

{{/*
Return password or secret value from values.yml or generate if it doesn't exists
*/}}
{{- define "common.secretValue" -}}
{{- if .value -}}
	{{- .value -}}
{{- else if .valueFrom -}}
    {{- randAlphaNum 10 -}}
{{- end -}}
{{- end -}}

{{- /*
common.util.merge will merge two YAML templates and output the result.
This takes an array of three values:
- the top context
- the template name of the overrides (destination)
- the template name of the base (source)
*/}}
{{- define "common.util.merge" -}}
{{- $top := first . -}}
{{- $overrides := fromYaml (include (index . 1) $top) | default (dict ) -}}
{{- $tpl := fromYaml (include (index . 2) $top) | default (dict ) -}}
{{- toYaml (merge $overrides $tpl) -}}
{{- end -}}
