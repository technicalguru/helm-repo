{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "postfixadmin.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "postfixadmin.fullname" -}}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "postfixadmin.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "postfixadmin.labels" -}}
helm.sh/chart: {{ include "postfixadmin.chart" . }}
{{ include "postfixadmin.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "postfixadmin.selectorLabels" -}}
app.kubernetes.io/name: {{ include "postfixadmin.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "postfixadmin.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "postfixadmin.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Test if the given value is an IP address
*/}}
{{- define "postfixadmin.isIpAddress" -}}
{{- $rc := . -}}
{{- $parts := splitList "." . -}}
{{- if eq (len $parts) 4 -}}
	{{- range $parts -}}
		{{- if and (not (atoi .)) (ne . "0") -}}
			{{- $rc = "" -}}
		{{- end -}}
	{{- end -}}
{{- else -}}
	{{- $rc = "" -}}
{{- end -}}
{{- print $rc }}
{{- end -}}

{{/*
Makes a full hostname from the given string if it's not one already or an IP address.
Attaches ".<namespace>.svc.cluster.local" to the end and includes the release name if required.
Please note that you need to call this template with (dict "Context" . "Value" "your-value")
*/}}
{{- define "postfixadmin.serviceName" -}}
{{- if include "postfixadmin.isIpAddress" .Value }}
	{{- print .Value }}
{{- else -}}
	{{- $parts := splitList "." .Value -}}
	{{- if gt (len $parts) 1 -}}
		{{- print .Value }}
	{{- else -}}
		{{- if eq .Context.Chart.Name .Context.Release.Name -}}
			{{- printf "%s.%s.svc.cluster.local" .Value .Context.Release.Namespace }}
		{{- else -}}
			{{- printf "%s-%s.%s.svc.cluster.local" .Context.Release.Name .Value .Context.Release.Namespace }}
		{{- end -}}

	{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Renders the full database server hostname if required
*/}}
{{- define "postfixadmin.dbHostname" -}}
{{- include "postfixadmin.serviceName" (dict "Context" . "Value" .Values.dbHostname) }}
{{- end -}}

{{/*
Renders the full mail server hostname if required
*/}}
{{- define "postfixadmin.mailserverHostname" -}}
{{- include "postfixadmin.serviceName" (dict "Context" . "Value" .Values.mailserverHostname) }}
{{- end -}}

