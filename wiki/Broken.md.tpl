{{- $not_buildable := coll.Slice -}}
{{- $k6_version := "" -}}
{{- range $idx, $ext:= .registry -}}
{{-   if (ne $ext.module "go.k6.io/k6") -}}
{{-     if coll.Has $ext.compliance.issues "build" -}}
{{-       $not_buildable = (coll.Append $ext $not_buildable) -}}
{{-     end -}}
{{-   else -}}
{{-     $k6_version = (index $ext.versions 0)  -}}
{{-   end -}}
{{- end -}}
{{- if (eq (len $not_buildable) 0) -}}
Good news, all registered extensions can be built with the latest ([{{$k6_version}}](https://github.com/grafana/k6/releases/tag/{{$k6_version}})) k6 version!
{{- else -}}
Some extensions are unfortunately not buildable with the latest ([{{$k6_version}}](https://github.com/grafana/k6/releases/tag/{{$k6_version}})) k6 version.

Repository | Description
-----------|------------
{{ range $idx, $ext:= $not_buildable -}}
{{ if and $ext.repo $ext.repo.url }}[{{ $ext.repo.owner }}/{{ $ext.repo.name }}]({{$ext.repo.url}}){{else}}{{ $ext.module }}{{end}} | {{ $ext.description }}
{{ end -}}
{{- end -}}
