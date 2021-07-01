{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "nextcloud.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "nextcloud.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "nextcloud.mariadb.fullname" -}}
{{- printf "%s-%s" .Release.Name "mariadb" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Create a default fully qualified redis app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "nextcloud.redis.fullname" -}}
{{- printf "%s-%s" .Release.Name "redis" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "nextcloud.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Get literal nextcloud admin username with priority:
- .Values.global.nextcloudAdminUser
- .Values.nextcloud.username
*/}}
{{- define "nextcloud.username" -}}
{{- printf "%s" (default .Values.nextcloud.username .Values.global.nextcloudAdminUser) -}}
{{- end -}}


{{/*
Get literal nextcloud admin password with priority:
- .Values.global.nextcloudAdminPassword.value
- .Values.nextcloud.password
*/}}
{{- define "nextcloud.password" -}}
{{- $userSpecifiedPassword := (default .Values.nextcloud.password (include "common.secretValue" .Values.global.nextcloudAdminPassword) ) -}}
{{- if $userSpecifiedPassword -}}
{{- printf "%s" $userSpecifiedPassword -}}
{{- else -}}
{{- randAlphaNum 10 -}}
{{- end -}}
{{- end -}}


{{/*
Get literal nextcloud SMTP Username with priority:
- .Values.global.smtpUser
- .Values.nextcloud.mail.smtp.name
*/}}
{{- define "nextcloud.smtp.username" -}}
{{- printf "%s" (default .Values.nextcloud.mail.smtp.name .Values.global.smtpUser) -}}
{{- end -}}

{{/*
Get literal nextcloud SMTP Password with priority:
- .Values.global.smtpPassword
- .Values.nextcloud.mail.smtp.password
*/}}
{{- define "nextcloud.smtp.password" -}}
{{- $userSpecifiedPassword := (default .Values.nextcloud.mail.smtp.password (include "common.secretValue" .Values.global.smtpPassword) ) -}}
{{- if $userSpecifiedPassword -}}
{{- printf "%s" $userSpecifiedPassword -}}
{{- else -}}
{{- randAlphaNum 10 -}}
{{- end -}}
{{- end -}}