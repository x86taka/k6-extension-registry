{{- $ownerless := coll.Slice -}}
{{- range $idx, $ext:= .registry -}}
{{-   if (ne $ext.module "go.k6.io/k6") -}}
{{-     if and (coll.Has $ext.compliance "issues") (coll.Has $ext.compliance.issues "codeowners") -}}
{{-       $ownerless = (coll.Append $ext $ownerless) -}}
{{-     end -}}
{{-   end -}}
{{- end -}}
{{- if (eq (len $ownerless) 0) -}}
Good news, all oficial extensions has `CODEOWNERS` file!
{{- else -}}
Some official extensions unfortunately do not have a `CODEOWNERS` file.

Repository | Description
-----------|------------
{{ range $idx, $ext:= $ownerless -}}
{{ if and $ext.repo $ext.repo.url }}[{{ $ext.repo.name }}]({{$ext.repo.url}}){{else}}{{ $ext.module }}{{end}} | {{ $ext.description }}
{{ end -}}
{{- end -}}
