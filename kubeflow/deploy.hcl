metadata {
  path = "kubeflow"
  name = "deploy"
}

step "terraform-init" {
  wkdir   = "kubeflow/terraform"
  target  = "kubeflow/terraform"
  command = "terraform"

  args = [
    "init",
    "-upgrade",
  ]

  sha     = "h1:HfxYWetb8WHL+k6YUaoUT/Pb6unS7z377O7iB4bFTas="
  retries = 0
}

step "terraform-apply" {
  wkdir   = "kubeflow/terraform"
  target  = "kubeflow/terraform"
  command = "terraform"

  args = [
    "apply",
    "-auto-approve",
  ]

  sha     = "h1:HfxYWetb8WHL+k6YUaoUT/Pb6unS7z377O7iB4bFTas="
  retries = 1
}

step "terraform-output" {
  wkdir   = "kubeflow"
  target  = "kubeflow/terraform"
  command = "plural"

  args = [
    "output",
    "terraform",
    "kubeflow",
  ]

  sha     = "h1:HfxYWetb8WHL+k6YUaoUT/Pb6unS7z377O7iB4bFTas="
  retries = 0
}

step "kube-init" {
  wkdir   = "kubeflow"
  target  = "kubeflow/.plural/NONCE"
  command = "plural"

  args = [
    "wkspace",
    "kube-init",
  ]

  sha     = "931586b20de2f1693ef853bc020d5e3a172ce6d6346c0eb2f6c7b071f103b943"
  retries = 0
}

step "crds" {
  wkdir   = "kubeflow"
  target  = "kubeflow/crds"
  command = "plural"

  args = [
    "wkspace",
    "crds",
    "kubeflow",
  ]

  sha     = "h1:p5krdbmmvueudA67ARWjYtNUdoH49BDi8qpuReOXdvQ="
  retries = 0
}

step "bounce" {
  wkdir   = "kubeflow"
  target  = "kubeflow/helm"
  command = "plural"

  args = [
    "wkspace",
    "helm",
    "kubeflow",
  ]

  sha     = "h1:u1SLng29jx0iCv4oYn2EzGDB38ky/ATUiRTdE/goZzs="
  retries = 1
}
