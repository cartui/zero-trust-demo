# Zero Trust Demo
This demo provides configuration for several zero-trust
services, configured to run on a single host for ease
of demonstration.

### Applications
Several simple user-facing services are included, including a static webserver
and a web terminal client using [ttyd](https://github.com/tsl0922/ttyd). This is
intended to demonstrate segmentation between services: The web terminal should
not be able to access other pods on the cluster network.

You can test this by navigating to the terminal (see `show_addrs.sh`) and
accessing another service like `simple-web`:

```bash
# On your host terminal, get the cluster-ip for the desired service:
kubectl get svc simple-web -o jsonpath='{.spec.clusterIP}'

# You can attempt to access this address from the web terminal,
# it should fail.
wget <cluster ip>
```

The bookinfo demo provided by Istio uses several backend services which all
must interact with each other, demonstrating how policies can be used
to granularly customize access control between services.

> Note: mTLS is disabled in the current version of the demo, as authentication isn't fully implemented

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
> You can create an alias for kubectl in your `.bashrc`: `alias kubectl='minikube kubectl --'`

Apply all configuration with:
```bash
minikube kubectl -- apply -f manifest
```

You can try to delete configuration if updating with apply doesn't work, though
restarting the cluster might give you better results:
```bash
# Remove configuration
minikube kubectl -- delete -f manifest

# Or restart the cluster
minikube stop && minikube start
```

### Accessing Services
Services must be exposed via the gateway, which has rules in [manifest/gateway.yaml].

You can get the current gateway address by running `./show_addrs.sh`,
or with `kubectl get gtw web-gateway`.

View dashboard of currently running services by running `minikube dashboard` in a separate terminal.

# References
Keycloak config: https://www.keycloak.org/getting-started/getting-started-kube

OPA config: https://github.com/open-policy-agent/opa-envoy-plugin/tree/main
