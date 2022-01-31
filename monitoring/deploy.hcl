metadata {
  path = "monitoring"
  name = "deploy"
}

step "terraform-init" {
  wkdir   = "monitoring/terraform"
  target  = "monitoring/terraform"
  command = "terraform"

  args = [
    "init",
    "-upgrade",
  ]

  sha     = "h1:o+iKWnbOD++JoFdxTlIAFlfJ0CAuLHY7qtM999xPDVU="
  retries = 0
}

step "terraform-apply" {
  wkdir   = "monitoring/terraform"
  target  = "monitoring/terraform"
  command = "terraform"

  args = [
    "apply",
    "-auto-approve",
  ]

  sha     = "h1:o+iKWnbOD++JoFdxTlIAFlfJ0CAuLHY7qtM999xPDVU="
  retries = 1
}

step "terraform-output" {
  wkdir   = "monitoring"
  target  = "monitoring/terraform"
  command = "plural"

  args = [
    "output",
    "terraform",
    "monitoring",
  ]

  sha     = "h1:o+iKWnbOD++JoFdxTlIAFlfJ0CAuLHY7qtM999xPDVU="
  retries = 0
}

step "kube-init" {
  wkdir   = "monitoring"
  target  = "monitoring/.plural/NONCE"
  command = "plural"

  args = [
    "wkspace",
    "kube-init",
  ]

  sha     = "6c94bab56328e67bfe39b95f6996456bf0afae65cdc9f8f2331e61c5587853e9"
  retries = 0
}

step "crds" {
  wkdir   = "monitoring"
  target  = "monitoring/crds"
  command = "plural"

  args = [
    "wkspace",
    "crds",
    "monitoring",
  ]

  sha     = "h1:x17zLJ/owkWQVZNZp1MWsv+vcv6wDMV85CsWU23xg8E="
  retries = 0
}

step "bounce" {
  wkdir   = "monitoring"
  target  = "monitoring/helm"
  command = "plural"

  args = [
    "wkspace",
    "helm",
    "monitoring",
  ]

  sha     = "h1:NsRg9t18G6WwbT6i4Di+tImhNnUmHZQD5nSmgfs1US4="
  retries = 1
}
