# Kartoza Helm charts

Kartoza Helm/Rancher charts for Kubernetes

# Add Helm Repo

To add the Helm Repo using Helm CLI:

```bash
helm repo add kartoza https://kartoza.github.io/charts
```

To add the Helm Repo in Rancher (Because we are using Rancher format structure),
use the github url: https://github.com/kartoza/charts.git.
Stable version of the charts is in `main` branch.


# Usage

To install chart, execute helm command

```bash
helm install -n <namespace> <release-name> kartoza/<chart-name> --version <chart-version> -f <values.yaml>
```

# Development

The chart structure is not yet stable, but we are welcoming any contributions.
In the bare minimum we will try to keep the same version as stable as possible.

If you are interested in contributing, you can check
[DEVELOPMENT-README.md](DEVELOPMENT-README.md).

List of stable charts (with somewhat good documentation):

- [Postgis](charts/postgis)
- [Django](charts/django)
- [GeoNode](charts/geonode)
- [GeoServer](charts/geoserver)

List of working charts, but not thoroughly tested:

- [QGIS Server](charts/qgis-server)
- [Guacamole](charts/guacamole)
- [NextCloud](charts/nextcloud)

Our design patterns are somewhat inspired by the [Bitnami](https://bitnami.com/)
helm charts. We are trying to refactor most reusable pieces in [common](charts/common)
library charts. By using the available template tags and docs template, we hope 
making a new Helm charts of different application will be easier.
