metadata {
  path = "redis"
  name = "deploy"
}

step "terraform-init" {
  wkdir   = "redis/terraform"
  target  = "redis/terraform"
  command = "terraform"

  args = [
    "init",
    "-upgrade",
  ]

  sha     = "h1:Qs7nyEV3FHX0bHX0vJJNIW1Tks2Bx+j4Pzk/Y0Q/IqQ="
  retries = 0
}

step "terraform-apply" {
  wkdir   = "redis/terraform"
  target  = "redis/terraform"
  command = "terraform"

  args = [
    "apply",
    "-auto-approve",
  ]

  sha     = "h1:Qs7nyEV3FHX0bHX0vJJNIW1Tks2Bx+j4Pzk/Y0Q/IqQ="
  retries = 1
}

step "terraform-output" {
  wkdir   = "redis"
  target  = "redis/terraform"
  command = "plural"

  args = [
    "output",
    "terraform",
    "redis",
  ]

  sha     = "h1:Qs7nyEV3FHX0bHX0vJJNIW1Tks2Bx+j4Pzk/Y0Q/IqQ="
  retries = 0
}

step "kube-init" {
  wkdir   = "redis"
  target  = "redis/.plural/NONCE"
  command = "plural"

  args = [
    "wkspace",
    "kube-init",
  ]

  sha     = "bef26e5ec66cb7bf374e3221524d77eb8cd1115b642bc8e1c9fd871144dda2cf"
  retries = 0
}

step "crds" {
  wkdir   = "redis"
  target  = "redis/crds"
  command = "plural"

  args = [
    "wkspace",
    "crds",
    "redis",
  ]

  sha     = "h1:47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU="
  retries = 0
}

step "bounce" {
  wkdir   = "redis"
  target  = "redis/helm"
  command = "plural"

  args = [
    "wkspace",
    "helm",
    "redis",
  ]

  sha     = "h1:CPtJykqZ0eZOYssG0SDJV1p3JkSCqHHlKUtjDH4Uwnw="
  retries = 1
}
