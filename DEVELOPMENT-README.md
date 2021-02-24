# Development Readme

This document is intended to give pointers on how to develop the charts in this repo.

# Prerequisite

Charts were mostly tested in the cloud. In order to keep the dependencies the 
same, we use Nix to pin the exact dependencies. We use Direnv to provide the 
local settings hooks

- Install [Docker](https://docs.docker.com/get-docker/)
- Install [Nix](https://nixos.org/manual/nix/stable/#sect-multi-user-installation) using multi-user installation if possible
- Install [Direnv](https://direnv.net/)
  
Or use Nix to install direnv

```bash
nix-env -f '<nixpkgs>' -iA direnv
```

- Install nix-direnv (Nix optimized plugin for direnv)

```bash
nix-env -f '<nixpkgs>' -iA nix-direnv
```

# Environment setup

The project directory is structured as a monorepo folder of charts. The charts
subdir uses Rancher charts convention where you store all the chart version. 
For example `charts/geonode` have several subdirectories with names `v0.1.1`, 
`v0.2.1`, etc. Each of this subdirectories is a Helm chart.

The dependencies inside each Helm chart subdirectories is managed by a combination 
of `.envrc` file (Direnv's) and `shell.nix` file (Nix's shell environment). 
Direnv will allow your shell to execute `.envrc` file, whenever you are inside that directory.
Each chart directory might need a different Helm binary version or Kubectl or KinD.
This is managed and expressed by `.envrc` and `.env` file.

Direnv files, `.envrc` works cascadingly. In the root directory, there is a 
`.envrc`. In the sub chart, there can be `.envrc` that overrides the root directory.
If you need to override these values, create extra file called `.local.envrc` or `.env`.
This will be executed to override `.envrc` in that directory.

Nix function/derivation `default.nix` is used to express the dependencies we need to 
setup our tools. It is also called by Direnv when we enter root directory of 
this project. You can customize your own Nix shell by creating a `local-shell.nix`

To setup the environment at first time, run this in the root project directory:

```bash
direnv allow
```

It will also setup your shell.

# Chart lint

To lint the chart, we use [chart-testing](https://github.com/helm/chart-testing) tools.

Chart testing works by comparing diff changes in the repo. So we need to provide 
which branch we are working on against. Normally you have `origin` and `upstream` 
in a git based workflow. If not, then you need to set your `upstream` remote accordingly.

Overriding any Chart testing option can be done by setting environment variable 
via your `.local.env` file. To see which option are available, check:
https://github.com/helm/chart-testing. If that is not enough, 
set `CT_CONFIG=<absolute path to this project path>/ct.override.yaml` and then 
set chart testing config file in `ct.override.yaml`. Example use case is when 
you want to repeatedly test specific chart in local.

Running

```bash
ct lint
```

Will do a lint by comparing the current branch with the current `main` branch 
in local repo.

# Generating chart documentations

Chart is autodocumented using default `values.yaml` and helm-docs.

Execute `helm-docs` in chart subdirectory to generate the docs.

Modification can be done in respective `README.md.gotmpl` file.

# Chart testing

In order to test the chart, you need a k8s distro running.

If you already have a sandbox k8s cluster, put the kubeconfig file in `kubeconfig.yaml` 
in the project root directory. Alternatively, specify `KUBECONFIG` environment 
in your `.local.env` file in the project directory

If you don't have a sandbox k8s cluster, create one in your local machine.
It's recommended to use [KIND](https://kind.sigs.k8s.io/) because it's lightweight.

Create cluster by running

```bash
kind create cluster --config=kind.config.yaml
```

You can replace `kind.config.yaml` file with any valid kind config file.
Once KIND is running, you can extract the kube config file like this:

```bash
kind export kubeconfig --kubeconfig kubeconfig.yaml
```

Once you got that set up,

Running

```bash
ct install
```

Will install changed charts into your target cluster.
`ct` will also run `helm test` if the chart have test hook.
