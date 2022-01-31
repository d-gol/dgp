metadata {
  path = "bootstrap"
  name = "deploy"
}

step "terraform-init" {
  wkdir   = "bootstrap/terraform"
  target  = "bootstrap/terraform"
  command = "terraform"

  args = [
    "init",
    "-upgrade",
  ]

  sha     = "h1:/692N6xXQEuKmCyMUJ0GwF5znDhmFQwxz4XTOYRFowA="
  retries = 0
}

step "terraform-apply" {
  wkdir   = "bootstrap/terraform"
  target  = "bootstrap/terraform"
  command = "terraform"

  args = [
    "apply",
    "-auto-approve",
  ]

  sha     = "h1:/692N6xXQEuKmCyMUJ0GwF5znDhmFQwxz4XTOYRFowA="
  retries = 1
}

step "terraform-output" {
  wkdir   = "bootstrap"
  target  = "bootstrap/terraform"
  command = "plural"

  args = [
    "output",
    "terraform",
    "bootstrap",
  ]

  sha     = "h1:/692N6xXQEuKmCyMUJ0GwF5znDhmFQwxz4XTOYRFowA="
  retries = 0
}

step "kube-init" {
  wkdir   = "bootstrap"
  target  = "bootstrap/.plural/NONCE"
  command = "plural"

  args = [
    "wkspace",
    "kube-init",
  ]

  sha     = "9299fc4cbc7fb014ae43389192a35bb632e26ab722d35b7fa36711fd9f5ab0a4"
  retries = 0
}

step "crds" {
  wkdir   = "bootstrap"
  target  = "bootstrap/crds"
  command = "plural"

  args = [
    "wkspace",
    "crds",
    "bootstrap",
  ]

  sha     = "h1:r7lkI2FXIlkFD2HoJ96LfAXG+vhx/xZ9QnqfTEe1CbI="
  retries = 0
}

step "bounce" {
  wkdir   = "bootstrap"
  target  = "bootstrap/helm"
  command = "plural"

  args = [
    "wkspace",
    "helm",
    "bootstrap",
  ]

  sha     = "h1:d155UdMMHeauDSyEo69LD4EfvvfcRLUka8xWpH2Z8NU="
  retries = 1
}
