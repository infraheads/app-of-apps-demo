{{- define "app.labels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- end }}

{{- define "app.selectorLabels" -}}
app.kubernetes.io/name: {{ .Release.Name }}
{{- end }}

{{/*
Render resources only if the app provided a resources block.
Defaults are the base, app values overwrite them.
*/}}
{{- define "app.resources" -}}
{{- if .Values.resources -}}
{{- $defaults := deepCopy .Values.defaultResources -}}
{{- $user := deepCopy .Values.resources -}}
{{- toYaml (mergeOverwrite $defaults $user) -}}
{{- end -}}
{{- end }}
