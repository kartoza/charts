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
	{{- $globalSharedSecretTemplate := default "" .Values.global.sharedSecretName -}}
	{{- $existingSecretTemplate := default "" .Values.existingSecret -}}
	{{- $secretName := default (tpl $globalSharedSecretTemplate $) (tpl $existingSecretTemplate $) -}}
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
    name: {{ include "common.secretName" . | quote }}
    key: {{ include "common.secretKey" .Value | quote }}
{{- end -}}

{{/*
Get the password secret.
This takes a map of
 - Value: the secret object structure
 - Context: the top level context
*/}}
{{- define "common.secretName" -}}
{{- if .Context.existingSecret -}}
    {{- printf "%s" (tpl .Context.existingSecret $) -}}
{{- else if .Value.valueFrom.secretKeyRef.name -}}
    {{- printf "%s" (tpl .valueFrom.secretKeyRef.name $) -}}
{{- else if not (eq (include "common.sharedSecretName" .Context) .Context.Release.Name) -}}
    {{- include "common.sharedSecretName" .Context -}}
{{- else -}}
    {{- include "common.fullname" .Context -}}
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

{{/*
Return password or secret value from values.yml or an existing secret, or generate if it doesn't exist

Usage:
    {{- include "common.stickySecretValue" (dict "Config" .Values.postgresqlPassword "Context" . ) -}}

Parameters
    - Config            The password config
    - Context           The context

*/}}
{{- define "common.stickySecretValue" -}}
{{- if .Config.value -}}
    {{- .Config.value -}}
{{- else if .Config.valueFrom -}}
    {{- include "common.getValueFromSecret" (dict "Namespace" .Context.Release.Namespace "Name" (default (include "common.fullname" .Context ) .Config.valueFrom.secretKeyRef.name ) "Key" .Config.valueFrom.secretKeyRef.key ) -}}
{{- end -}}
{{- end -}}


{{/*
Returns the available value for certain key in an existing secret (if it exists),
otherwise it generates a random value.

Usage:
    {{- include "getValueFromSecret" (dict "Namespace" .Release.Namespace "Name" (include "common.fullname" .) "Length" 10 "Key" "postgis-password")  -}}

Parameters:
    - Namespace         The release namespace to search. (default: .Release.Namespace)
    - Name              The name of the secret
    - Length            The length of the generated secret (default 10)
    - Key               The key within the secret to retrieve the value
*/}}
{{- define "common.getValueFromSecret" }}
    {{- $len := (default 10 .Length) | int -}}
    {{- $obj := (lookup "v1" "Secret" .Namespace .Name).data -}}
    {{- if $obj }}
        {{- index $obj .Key | b64dec -}}
    {{- else -}}
        {{- randAlphaNum $len -}}
    {{- end -}}
{{- end }}

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

{{/*
Return the name of the storageClass assigned
*/}}
{{- define "common.storageClass" -}}
{{- $defaultClass := coalesce .storageClass .Values.persistence.storageClass .Values.storageClass .Values.global.storageClass -}}
{{- if $defaultClass -}}
storageClassName: {{ $defaultClass | quote }}
{{- else -}}
{{- end -}}
{{- end -}}
