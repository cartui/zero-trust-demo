# Zero Trust Demo
This demo provides configuration for several zero-trust
services, configured to run on a single host for ease
of demonstration.

## Components
The following components are used to form a zero-trust network:

> TODO: Descriptions of what these services are

TODO: Diagram

### Keycloak
TODO

### OPA
TODO

### Istio
TODO

### Envoy
TODO

## Usage

### Setup
Running this demo requires:
- A [Docker](docker.com) installation
- A [minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fbinary+download)
installation for running a kubernetes cluster locally.

The following minikube addons are also required (installed by the setup script):
- istio
- istio-provisioner

After installing minikube, start the cluster:

```bash
# Start the cluster
minikube start --memory=8192 --cpus=4

# Stop and restart the cluster (doesn't require memory/cpus flags)
minikube stop
minikube start
```

After starting the cluster, you'll need to do some first time setup, including
enabling plugins, enabling injection for Istio's proxy containers, and
installing CRDs for the Gateway API. You can use the `setup.sh` script for this.

```bash
./setup.sh
```

You can completely delete the cluster with
`minikube delete`, though you will need to rerun setup.

To access expose endpoints inside the cluster to your local network, you'll
need to start a tunnel in a separate terminal to simulate a Kubernetes load-balancer:

```bash
# Keep running in a separate terminal
minikube tunnel
```

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
> installing `kubectl`. Running it in this way
> requires you pass all `kubectl` arguments after `--`.
>
> It's recommended to create an alias for kubectl: `alias kubectl='minikube kubectl --'`

Deploy all services with:
```bash
minikube kubectl -- apply -f manifest
```

And stop them with
```bash
minikube kubectl -- delete -f manifest
```

### Accessing Services
Services must be exposed via the gateway, which has rules in [manifest/gateway.yaml].

You can get the current gateway address by running `./show_addrs.sh`,
or with `kubectl get gtw web-gateway`.

View dashboard of currently running services by running `minikube dashboard` in a separate terminal.

### Configuring Clients
TODO: Notes on configuring clients (i.e. installing mTLS certificates to the host machine)

# References
Keycloak config: https://www.keycloak.org/getting-started/getting-started-kube
OPA config: https://github.com/open-policy-agent/opa-envoy-plugin/tree/main
