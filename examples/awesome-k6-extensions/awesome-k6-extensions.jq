map(
 select(.module != "go.k6.io/k6") | 
 select( (.repo.stars >= $stars or .official)) | 
 {
   name:.repo.name,
   url: .repo.url,
   description: (if .description | endswith(".") then .description else .description + "." end),
   order: (if .official then 1 else 2 end),
   tier: (if .official then "Official" else "Community" end)
 }
 ) |
 group_by(.order) | .[] | 
  (
    ["\n### \(.|first|.tier)\n"] + 
    (sort_by(.name)| map("- [\(.name)](\(.url)) - \(.description)"))
  ) |
.[]

