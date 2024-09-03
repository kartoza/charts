{{/*
This template is used as a shared template generator for GeoNode Django container.

Django, Celery, Celerybeat, and Celerycam containers used by GeoNode all must have
the same environment variables, volume mounts, and pod spec.
The only difference is their labels, command, and entrypoint declarations.
By using a shared template we minimize copy-paste error when modifying the application.
*/}}

{{/*
The GeoNode container spec
*/}}
{{- define "geonode.sharedContainerSpec" -}}
imagePullPolicy: {{ .Values.image.pullPolicy }}
env:
  - name: HTTP_HOST
    value: {{ .Values.global.geonodeSiteName | quote }}
  - name: HTTP_PORT
    value: "80"
  {{- if .Values.ingress.tls.enabled }}
  - name: HTTPS_HOST
    value: {{ .Values.global.geonodeSiteName | quote }}
  - name: HTTPS_PORT
    value: "443"
  {{- end }}
  - name: ADMIN_USERNAME
    value: {{ .Values.global.adminUser | quote }}
  - name: ADMIN_PASSWORD
    {{- $param := dict "Value" .Values.global.adminPassword "Context" . -}}
    {{ include "geonode.secretFrom" $param | nindent 4 }}
  - name: ADMIN_EMAIL
    value: {{ .Values.global.adminEmail | quote }}
  - name: GEOSERVER_ADMIN_USER
    value: {{ .Values.global.geoserverAdminUser | quote }}
  - name: GEOSERVER_ADMIN_PASSWORD
    {{- $param := dict "Value" .Values.global.geoserverAdminPassword "Context" . -}}
    {{ include "geonode.secretFrom" $param | nindent 4 }}
  - name: REGISTRATION_OPEN
    value: "True"
  - name: ALLOWED_HOSTS
    value: {{ template "geonode.allowedHosts" . }}
  - name: SECRET_KEY
    {{- $param := dict "Value" .Values.global.djangoSecretKey "Context" . -}}
    {{ include "geonode.secretFrom" $param | nindent 4 }}
  - name: DEFAULT_BACKEND_UPLOADER
    value: "geonode.importer"
  - name: DEFAULT_BACKEND_DATASTORE
    value: "datastore"
  - name: POSTGRES_USER
    value: {{ .Values.global.databaseUsername  | quote }}
  - name: POSTGRES_PASSWORD
    {{- $param := dict "Value" .Values.global.databasePassword "Context" . -}}
    {{ include "geonode.secretFrom" $param | nindent 4 }}
  - name: GEONODE_DATABASE_USER
    value: {{ .Values.global.databaseUsername  | quote}}
  - name: GEONODE_DATABASE
    value: {{ .Values.global.databaseName | quote }}
  - name: GEONODE_DATABASE_HOST
    value: {{ include "geonode.databaseHost" . | quote }}
  - name: GEONODE_DATABASE_PORT
    value: {{ .Values.global.databasePort | quote }}
  - name: GEONODE_DATABASE_PASSWORD
    {{- $param := dict "Value" .Values.global.databasePassword "Context" . -}}
    {{ include "geonode.secretFrom" $param | nindent 4 }}
  - name: GEONODE_GEODATABASE_USER
    value: {{ .Values.global.geodatabaseUsername  | quote}}
  - name: GEONODE_GEODATABASE
    value: {{ .Values.global.geodatabaseName | quote }}
  - name: GEONODE_GEODATABASE_HOST
    value: {{ include "geonode.geodatabaseHost" . | quote }}
  - name: GEONODE_GEODATABASE_PORT
    value: {{ .Values.global.databasePort | quote }}
  - name: GEONODE_GEODATABASE_PASSWORD
    {{- $param := dict "Value" .Values.global.geodatabasePassword "Context" . -}}
    {{ include "geonode.secretFrom" $param | nindent 4 }}
  - name: DEBUG
    value: {{ .Values.global.debug | quote }}
  - name: DJANGO_SETTINGS_MODULE
    value: {{ .Values.global.djangoSettingsModule | quote }}
  - name: STATIC_ROOT
    value: {{ .Values.global.staticRoot | quote }}
  - name: MEDIA_ROOT
    value: {{ .Values.global.mediaRoot | quote }}
  - name: STATIC_URL
    value: "/static/"
  - name: MEDIA_URL
    value: "/uploaded/"
  - name: GEOSERVER_LOCATION
    value: {{ include "geonode.internalGeoserverURL" . | quote }}
  - name: GEOSERVER_PUBLIC_LOCATION
    value: {{ include "geonode.geoserverURL" . | quote }}
  - name: SITE_HOST_NAME
    value: {{ .Values.global.geonodeSiteName | quote }}
  - name: SITEURL
    value: {{ include "geonode.siteURL" . | quote }}
  {{- if .Values.global.celeryAsync.enabled }}
  - name: CELERY_TASK_ALWAYS_EAGER
    value: "False"
  - name: BROKER_URL
    valueFrom:
      secretKeyRef:
        name: {{ include "geonode.sharedSecretName" . | quote }}
        key: broker-url
  {{- end }}
  {{- with .Values.extraPodEnv }}
  {{- tpl . $ | nindent 2 }}
  {{- end }}
ports:
  - name: uwsgi-geonode
    containerPort: 8000
  - name: http-geonode
    containerPort: 8080
volumeMounts:
  - name: config-volume
    mountPath: /spcgeonode/geonode/local_settings.py
    subPath: local_settings.py
  - name: config-volume
    mountPath: /spcgeonode/scripts/spcgeonode/django/initialize.py
    subPath: initialize.py
  {{- if .Values.persistence.staticDir.enabled }}
  - name: static-dir
    mountPath: {{ .Values.persistence.staticDir.mountPath }}
    subPath: {{ .Values.persistence.staticDir.subPath }}
  {{- end }}
  {{- if .Values.persistence.mediaDir.enabled }}
  - name: media-dir
    mountPath: {{ .Values.persistence.mediaDir.mountPath }}
    subPath: {{ .Values.persistence.mediaDir.subPath }}
  {{- end }}
  {{- with .Values.extraVolumeMounts }}
  {{- (tpl . $) | nindent 2 }}
  {{- end }}

{{- end -}}

{{/*
The GeoNode Volume declaration spec
*/}}
{{- define "geonode.sharedVolumeSpec" -}}
volumes:
  {{- with .Values.extraVolume }}
  {{- (tpl . $) | nindent 2 }}
  {{- end }}
  - name: config-volume
    configMap:
      name: {{ template "geonode.fullname" . }}-config
      defaultMode: 0755
  {{- if and .Values.persistence.staticDir.enabled .Values.persistence.staticDir.existingClaim }}
  - name: static-dir
    persistentVolumeClaim:
    {{- with .Values.persistence.staticDir.existingClaim }}
      claimName: {{ tpl . $ }}
    {{- end }}
  {{- else if .Values.persistence.staticDir.enabled }}
  - name: static-dir
    persistentVolumeClaim:
      claimName: static-dir
  {{- end }}
  {{- if and .Values.persistence.mediaDir.enabled .Values.persistence.mediaDir.existingClaim }}
  - name: media-dir
    persistentVolumeClaim:
    {{- with .Values.persistence.mediaDir.existingClaim }}
      claimName: {{ tpl . $ }}
    {{- end }}
  {{- else if .Values.persistence.mediaDir.enabled }}
  - name: media-dir
    persistentVolumeClaim:
      claimName: media-dir
  {{- end }}
{{- end -}}
