Metrics made from the content of the k6 extension registry are listed here, broken down according to different aspects. The page is automatically updated when the registry changes.
{{ $props := index .schema "$defs" "metrics" "properties" }}
## Extensions by Grade

Metrics by extension compliance grades. The grade for the fully compliant (without issue) extension is A.

```mermaid
pie showData 
{{ range $key, $value:= .metrics }}
  {{- if strings.Contains "_grade_" $key -}}
  {{- $name := strings.TrimSuffix "_count" (strings.TrimPrefix "registry_grade_" $key) -}}
  {{- if index $.metrics $key}}"{{strings.ToUpper $name}}" : {{index $.metrics $key}}{{"\n"}}{{end}}
  {{- end -}}
{{- end -}}
```

<div align="center">

Metric | Description | Value
-------|-------|------------
{{ range $key, $value:= .metrics }}
{{-  if strings.Contains "_grade_" $key -}}
{{-    $key }} | {{ strings.TrimSuffix "." (index $props $key "description") }} | {{ $value }}
{{ end -}}
{{ end}}

</div>

## Extensions by Issue

Metrics by extension compliance issues. Since an extension may have several compliance issues, the sum of the values may be greater than the total number of extensions.

```mermaid
pie showData title 
{{ range $key, $value:= .metrics }}
  {{- if strings.Contains "_issue_" $key -}}
  {{- $name := strings.TrimSuffix "_count" (strings.TrimPrefix "registry_issue_" $key) -}}
  {{- if index $.metrics $key}}"{{$name}}" : {{index $.metrics $key}}{{"\n"}}{{end}}
  {{- end -}}
{{- end -}}
```

<div align="center">

Metric | Description | Value
-------|-------|------------
{{ range $key, $value:= .metrics }}
{{-  if strings.Contains "_issue_" $key -}}
{{-    $key }} | {{ strings.TrimSuffix "." (index $props $key "description") }} | {{ $value }}
{{ end -}}
{{ end}}

</div>

## Extensions by Tier

Metrics by support. Unofficial extensions are actually community-supported extensions, they were only displayed for better visibility. Since the unofficial extensions also appear in the community extensions metric, the sum of the values is greater than the total number of extensions.

```mermaid
pie showData
{{ range $key, $value:= .metrics }}
  {{- if strings.Contains "_tier_" $key -}}
  {{- $name := strings.TrimSuffix "_count" (strings.TrimPrefix "registry_tier_" $key) -}}
  {{- if index $.metrics $key}}"{{$name}}" : {{index $.metrics $key}}{{"\n"}}{{end}}
  {{- end -}}
{{- end -}}
```

<div align="center">

Metric | Description | Value
-------|-------|------------
{{ range $key, $value:= .metrics }}
{{-  if strings.Contains "_tier_" $key -}}
{{-    $key }} | {{ strings.TrimSuffix "." (index $props $key "description") }} | {{ $value }}
{{ end -}}
{{ end}}

</div>

## Extensions by Product

Metrics by product. Since an extension may be supported in several products, the sum of the values may be greater than the total number of extensions.
{{ $products := dict "cloud" "Grafana Cloud k6" "synthetic" "Synthetic Monitoring" "oss" "Grafana k6" }}
```mermaid
pie showData
{{ range $key, $value:= .metrics }}
  {{- if strings.Contains "_product_" $key -}}
  {{- $name := strings.TrimSuffix "_count" (strings.TrimPrefix "registry_product_" $key) -}}
  {{- if index $.metrics $key}}"{{index $products $name}}" : {{index $.metrics $key}}{{"\n"}}{{end}}
  {{- end -}}
{{- end -}}
```

<div align="center">

Metric | Description | Value
-------|-------|------------
{{ range $key, $value:= .metrics }}
{{-  if strings.Contains "_product_" $key -}}
{{-    $key }} | {{ strings.TrimSuffix "." (index $props $key "description") }} | {{ $value }}
{{ end -}}
{{ end}}

</div>

## Extensions by Category

Metrics by extension category. Since an extension can belong to several categories, the sum of the value can be greater than the total number of extensions.

```mermaid
pie showData
{{ range $key, $value:= .metrics }}
  {{- if strings.Contains "_category_" $key -}}
  {{- $name := strings.TrimSuffix "_count" (strings.TrimPrefix "registry_category_" $key) -}}
  {{- if index $.metrics $key}}"{{$name}}" : {{index $.metrics $key}}{{"\n"}}{{end}}
  {{- end -}}
{{- end -}}
```

<div align="center">

Metric | Description | Value
-------|-------|------------
{{ range $key, $value:= .metrics }}
{{-  if strings.Contains "_category_" $key -}}
{{-    $key }} | {{ strings.TrimSuffix "." (index $props $key "description") }} | {{ $value }}
{{ end -}}
{{ end}}

</div>

## Extensions by Type

Metrics by extension type. Since an extension can implement both JavaScript and Output extensions, the sum of the values can be greater than the total number of extensions.

```mermaid
pie showData
{{ range $key, $value:= .metrics }}
  {{- if strings.Contains "_type_" $key -}}
  {{- $name := strings.TrimSuffix "_count" (strings.TrimPrefix "registry_type_" $key) -}}
  {{- if index $.metrics $key}}"{{$name}}" : {{index $.metrics $key}}{{"\n"}}{{end}}
  {{- end -}}
{{- end -}}
```

<div align="center">

Metric | Description | Value
-------|-------|------------
{{ range $key, $value:= .metrics }}
{{-  if strings.Contains "_type_" $key -}}
{{-    $key }} | {{ strings.TrimSuffix "." (index $props $key "description") }} | {{ $value }}
{{ end -}}
{{ end}}

</div>

## All metrics

The table below contains all available metrics from the registry.

<div align="center">

Metric | Description | Value
-------|-------|------------
{{ range $key, $value:= .metrics -}}
{{ $key }} | {{ strings.TrimSuffix "." (index $props $key "description") }} | {{ $value }} 
{{ end}}

</div>

Metrics can be downloaded in [JSON format]({{.Env.BASE_URL}}/metrics.json) using the command below.

```bash
curl '{{.Env.BASE_URL}}/metrics.json'
```
