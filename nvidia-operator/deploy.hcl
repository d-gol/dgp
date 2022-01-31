metadata {
  path = "nvidia-operator"
  name = "deploy"
}

step "terraform-init" {
  wkdir   = "nvidia-operator/terraform"
  target  = "nvidia-operator/terraform"
  command = "terraform"

  args = [
    "init",
    "-upgrade",
  ]

  sha     = "h1:5y3pqjD2FfF1cPQ8iWwreb632qoCKpbQzyqD9BbJlIc="
  retries = 0
}

step "terraform-apply" {
  wkdir   = "nvidia-operator/terraform"
  target  = "nvidia-operator/terraform"
  command = "terraform"

  args = [
    "apply",
    "-auto-approve",
  ]

  sha     = "h1:5y3pqjD2FfF1cPQ8iWwreb632qoCKpbQzyqD9BbJlIc="
  retries = 1
}

step "terraform-output" {
  wkdir   = "nvidia-operator"
  target  = "nvidia-operator/terraform"
  command = "plural"

  args = [
    "output",
    "terraform",
    "nvidia-operator",
  ]

  sha     = "h1:5y3pqjD2FfF1cPQ8iWwreb632qoCKpbQzyqD9BbJlIc="
  retries = 0
}

step "kube-init" {
  wkdir   = "nvidia-operator"
  target  = "nvidia-operator/.plural/NONCE"
  command = "plural"

  args = [
    "wkspace",
    "kube-init",
  ]

  sha     = "6d5672e37d70b7fe6ca2ac3a87684a8790cdcd77c953e24876e8e6a24a63f894"
  retries = 0
}

step "crds" {
  wkdir   = "nvidia-operator"
  target  = "nvidia-operator/crds"
  command = "plural"

  args = [
    "wkspace",
    "crds",
    "nvidia-operator",
  ]

  sha     = "h1:2blKLDz++qBHLRzS62oZWipyvmesKkX5jyvElMH0CP0="
  retries = 0
}

step "bounce" {
  wkdir   = "nvidia-operator"
  target  = "nvidia-operator/helm"
  command = "plural"

  args = [
    "wkspace",
    "helm",
    "nvidia-operator",
  ]

  sha     = "h1:C274SowUuayTeRGf90Gx66QobxY+j3I4IyP7LGAutrY="
  retries = 1
}
