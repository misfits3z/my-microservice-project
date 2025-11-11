{{/*
Define the name of the chart.
*/}}
{{- define "django-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Define the full name of the chart (release + name).
*/}}
{{- define "django-app.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "django-app.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
