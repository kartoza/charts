{{/*
Expand the name of the chart.
*/}}
{{- define "geoserver.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "geoserver.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "geoserver.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "geoserver.labels" -}}
helm.sh/chart: {{ include "geoserver.chart" . }}
{{ include "geoserver.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "geoserver.selectorLabels" -}}
app.kubernetes.io/name: {{ include "geoserver.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/*
Get the configMap key.
*/}}
{{- define "geoserver.configName" -}}
{{- if .Values.existingConfig -}}
    {{- printf "%s" (tpl .Values.existingConfig $) -}}
{{- else -}}
    {{- printf "%s" (include "geoserver.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the password secret.
*/}}
{{- define "geoserver.secretName" -}}
{{- if .Values.existingSecret -}}
    {{- printf "%s" (tpl .Values.existingSecret $) -}}
{{- else -}}
    {{- printf "%s" (include "geoserver.fullname" .) -}}
{{- end -}}
{{- end -}}


{{/*
Return GeoServer user
*/}}
{{- define "geoserver.user" -}}
{{- if .Values.geoserverUser -}}
    {{- .Values.geoserverUser -}}
{{- else -}}
    {{- randAlphaNum 7 -}}
{{- end -}}
{{- end -}}


{{/*
Return GeoServer password
*/}}
{{- define "geoserver.password" -}}
{{- if .Values.geoserverPassword -}}
    {{- .Values.geoserverPassword -}}
{{- else -}}
    {{- randAlphaNum 12 -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "geoserver.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "geoserver.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return GeoServer Data Dir storageClass declaration
*/}}
{{- define "geoserver.geoserverDataDir.storageClass" -}}
{{- if .Values.global -}}
	{{- if .Values.global.storageClass -}}
        {{- if (eq "-" .Values.global.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.global.storageClass -}}
        {{- end -}}
    {{- else -}}
        {{- if .Values.persistence.geoserverDataDir.storageClass -}}
              {{- if (eq "-" .Values.persistence.geoserverDataDir.storageClass) -}}
                  {{- printf "storageClassName: \"\"" -}}
              {{- else }}
                  {{- printf "storageClassName: %s" .Values.persistence.geoserverDataDir.storageClass -}}
              {{- end -}}
        {{- end -}}
    {{- end -}}
{{- else -}}
    {{- if .Values.persistence.geoserverDataDir.storageClass -}}
        {{- if (eq "-" .Values.persistence.geoserverDataDir.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.persistence.geoserverDataDir.storageClass -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the Postgis Hostname
*/}}
{{- define "geoserver.databaseHost" -}}
{{- if .Values.postgis.enabled }}
    {{- printf "%s" (include "geoserver.fullname" .) -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}

{{/*
Return the Postgis Port
*/}}
{{- define "geoserver.databasePort" -}}
{{- if .Values.postgis.enabled }}
    {{- printf "5432" -}}
{{- else -}}
    {{- printf "%d" (.Values.externalDatabase.port | int ) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Postgis Database Name
*/}}
{{- define "geoserver.databaseName" -}}
{{- if .Values.postgis.enabled }}
    {{- printf "%s" .Values.postgis.auth.database -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Return the Postgis User
*/}}
{{- define "geoserver.databaseUser" -}}
{{- if .Values.postgis.enabled }}
    {{- printf "%s" .Values.postgis.auth.username -}}
{{- else -}}
    {{- printf "%s" .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}


{{/*
Return the Postgis Secret Name
*/}}
{{- define "geoserver.databaseSecretName" -}}
{{- if and (.Values.postgis.enabled) (not .Values.postgis.existingSecret) -}}
    {{- printf "%s" (include "geoserver.fullname" .) -}}
{{- else if and (.Values.postgis.enabled) (.Values.postgis.existingSecret) -}}
    {{- printf "%s" .Values.postgis.auth.existingSecret -}}
{{- else }}
    {{- if .Values.externalDatabase.existingSecret -}}
        {{- printf "%s" .Values.externalDatabase.existingSecret -}}
    {{- else -}}
        {{- printf "%s-%s" .Release.Name "externaldb" -}}
    {{- end -}}
{{- end -}}
{{- end -}}

