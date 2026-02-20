{{- define "java-maven-app.appName" -}}
{{- default .Chart.Name .Values.appName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "java-maven-app.namespace" -}}
{{- if .Values.namespaceOverride -}}
{{ .Values.namespaceOverride }}
{{- else -}}
{{ .Release.Namespace }}
{{- end -}}
{{- end -}}
