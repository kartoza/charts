{{/*
Return first PostgreSQL database
*/}}
{{- define "postgresql.firstDatabaseName" -}}
{{- $dbList := splitList "," (printf "%s" .Values.postgresqlDatabase) -}}
{{- first $dbList -}}
{{- end -}}

{{/*
Return default internal cluster postgres host
*/}}
{{- define "postgresql.service.name" -}}
{{- include "common.fullname" . -}}
{{- end -}}

{{/*
Constructs postgres:// protocol connection string
Input is a map. If any value not supplied, will defer to default value.
- Context: Top Context
- Database: Database name
- Protocol: Protocol string. Like postgres for postgres://
- Port
- User
- Host
- Password
*/}}
{{- define "postgresql.connectionstring" -}}
{{- $top := .Context -}}
{{- $user := default $top.Values.postgresqlUsername .User -}}
{{- $port := default (int $top.Values.service.port) .Port -}}
{{- $db := default (include "postgresql.firstDatabaseName" $top) .Database -}}
{{- $host := default (include "postgresql.service.name" $top) .Host -}}
{{- $password := default (include "common.secretValue" $top.Values.postgresqlPassword) .Password -}}
{{- $protocol := default "postgres" .Protocol -}}
{{ printf "%s://%s:%s@%s:%d/%s" $protocol $user $password $host $port $db }}
{{- end -}}
