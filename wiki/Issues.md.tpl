Lists of extensions based on issues found by the compliance check. A specific extension can be included in several lists, since an extension can have several issues.

{{- $issues := dict
        "module" (coll.Slice) 
        "replace" (coll.Slice) 
        "readme" (coll.Slice) 
        "examples" (coll.Slice) 
        "license" (coll.Slice) 
        "git" (coll.Slice) 
        "versions" (coll.Slice) 
        "build" (coll.Slice) 
        "smoke" (coll.Slice) 
        "types" (coll.Slice) 
        "codeowners" (coll.Slice) 
 -}}
{{- $k6_version := "" -}}
{{- range $idx, $ext:= .registry -}}
{{-   if (eq $ext.module "go.k6.io/k6") -}}
{{-     $k6_version = (index $ext.versions 0) -}}
{{-     continue -}}
{{-   end -}}
{{-   if coll.Has $ext.compliance "issues" -}}
{{-     range $j, $issue := $ext.compliance.issues -}}
{{-       $issues = (coll.Set $issue (append $ext (index $issues $issue)) $issues) -}}
{{-     end -}}
{{-   end -}}
{{- end -}}
{{- $summaries := dict
        "build" (print "The following extensions are not buildable with the latest ([" $k6_version "](https://github.com/grafana/k6/releases/tag/" $k6_version ")) k6 version.")
        "codeowners" "The following official extensions do not have a `CODEOWNERS` file."
        "types" "The following JavaScript extensions do not have a TypeScript API declaration (`index.d.ts`)."
        "examples" "The following JavaScript extensions do not have examples in the `examples` folder."
        "replace" "There is a replace directive in the `go.mod` file of the extensions below."
        "smoke" "The following JavaScript extensions do not have a smoke test script (`smoke.js`, `smoke.test.js`, `smoke.ts`, `smoke.test.ts` file in the `test`, `tests`, `examples` or base directory)."
        "module" "The extensions below do not have a valid `go.mod` file."
        "readme" "The extensions below do not have a readme file."
        "license" "The extensions below do not have a suitable open-source license file."
        "git" "The extensions below do not have a git repository (this is not possible, it can only happen locally)."
        "versions" "The extensions below do not have semantic version tags."
 -}}
{{- range $issue, $exts := $issues }}
{{   if gt (len $exts) 0  }}
## {{$issue}}
{{ default "" (index $summaries $issue) }}

Repository | Description
-----------|------------
{{-   range $idx, $ext := index $exts }}
{{      if and $ext.repo $ext.repo.url }}[{{ $ext.repo.owner }}/{{ $ext.repo.name }}]({{$ext.repo.url}}){{else}}{{ $ext.module }}{{end}} | {{ $ext.description }}
{{-   end -}}
{{- end -}}

{{   end }}
