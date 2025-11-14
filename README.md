# Zero Trust Demo
This demo provides configuration for several zero-trust
services, configured to run on a single host for ease
of demonstration.

# TODO:
- [ ] Consider using Pomerium as an ingress controller instead of the
built-in minikube plugin (nginx)

## Components
The following components are used to form a zero-trust network:

> TODO: Descriptions of what these services are

TODO: Diagram

### Keycloak
TODO

### OPA
TODO

### Pomerium
TODO

### Istio
TODO

### Envoy
TODO

## Usage

### Prerequisites
Running this demo requires:
- A [Docker](docker.com) installation
- A [minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fbinary+download)
installation for running a kubernetes cluster locally.

The following minikube addons are also required:
- ingress
- istio
- istio-provisioner

```bash
# (On first setup) Enable addons
minikube addons enable ingress
minikube addons enable istio-provisioner
minikube addons enable istio
```

After installing minikube and its addons, start the cluster:

```bash
# Start the cluster
minikube start --memory=8192 --cpus=4
```

To stop the cluster, use `minikube stop`.

### Build Services
Custom services must be built manually and imported into minikube's local image
registry before starting a deployment. We provide a `build.sh`
for doing this for all services in `services`, though if you're on
Windows you may need to run the build commands yourself:

```bash
./build.sh

# Or, build images manually:
minikube image build -t simple-website:latest images/simple-website
```

### Deploying Services
> Note: Minikube provides a `kubectl` subcommand for automatically
installing `kubectl`. Note running it in this way
requires you pass all `kubectl` arguments after `--`.

Deploy all services with:
```bash
minikube kubectl -- apply -f manifest
```

And stop them with
```bash
minikube kubectl -- delete -f manifest
```

### Accessing Services
For services exposed via an ingress rule, you should be able to
access them through the address reported by `minikube ip`.

Currently configured services:
- simple-web: `http://$(minikube ip)/`
- keycloak: `http://$(minikube ip)/keycloak`

### Configuring Clients
TODO: Notes on configuring clients (i.e. installing mTLS certificates to the host machine)

# References
Keycloak config: https://www.keycloak.org/getting-started/getting-started-kube
OPA config: https://github.com/open-policy-agent/opa-envoy-plugin/tree/main
