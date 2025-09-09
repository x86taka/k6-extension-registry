The following table lists the k6 extensions that can be used in [Synthetic Monitoring](https://grafana.com/products/cloud/synthetic-monitoring/).

Name | Description
-----|------------
{{ range $idx, $ext:= .registry -}}
{{ if and (coll.Has $ext.products "synthetic") (ne $ext.module "go.k6.io/k6") -}}
{{ if and $ext.repo $ext.repo.url }}[{{ $ext.repo.name }}]({{$ext.repo.url}}){{else}}{{ $ext.module }}{{end}} | {{ $ext.description }}
{{ end -}}
{{ end }}

The list can be downloaded in [JSON format]({{.Env.BASE_URL}}/product/synthetic.json) using the command below.

```bash
curl {{.Env.BASE_URL}}/product/synthetic.json
```