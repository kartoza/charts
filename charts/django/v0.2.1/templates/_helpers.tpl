
{{/*
Return Media storageClass declaration
*/}}
{{- define "django.mediaDir.storageClass" -}}
{{- if .Values.global -}}
	{{- if .Values.global.storageClass -}}
        {{- if (eq "-" .Values.global.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.global.storageClass -}}
        {{- end -}}
    {{- else -}}
        {{- if .Values.persistence.mediaDir.storageClass -}}
              {{- if (eq "-" .Values.persistence.mediaDir.storageClass) -}}
                  {{- printf "storageClassName: \"\"" -}}
              {{- else }}
                  {{- printf "storageClassName: %s" .Values.persistence.mediaDir.storageClass -}}
              {{- end -}}
        {{- end -}}
    {{- end -}}
{{- else -}}
    {{- if .Values.persistence.mediaDir.storageClass -}}
        {{- if (eq "-" .Values.persistence.mediaDir.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.persistence.mediaDir.storageClass -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}


{{/*
Return static dir storageClass declaration
*/}}
{{- define "django.staticDir.storageClass" -}}
{{- if .Values.global -}}
	{{- if .Values.global.storageClass -}}
        {{- if (eq "-" .Values.global.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.global.storageClass -}}
        {{- end -}}
    {{- else -}}
        {{- if .Values.persistence.staticDir.storageClass -}}
              {{- if (eq "-" .Values.persistence.staticDir.storageClass) -}}
                  {{- printf "storageClassName: \"\"" -}}
              {{- else }}
                  {{- printf "storageClassName: %s" .Values.persistence.staticDir.storageClass -}}
              {{- end -}}
        {{- end -}}
    {{- end -}}
{{- else -}}
    {{- if .Values.persistence.staticDir.storageClass -}}
        {{- if (eq "-" .Values.persistence.staticDir.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.persistence.staticDir.storageClass -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}
