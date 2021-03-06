#!/bin/bash
# shellcheck disable=SC2091,SC2006

# Disabling SC2091 above because we want to print commands encased in $()
# Disabling SC2006 above because ``` code blocks are misinterpretted as shell execution

# shellcheck disable=SC1091
source control-tower/ci/tasks/lib/set-flags.sh

version=$(cat version/version)
pushd control-tower-ops
  bin_bosh_cli_version=$(                jq -r '."bosh-cli".linux' createenv-dependencies-and-cli-versions-aws.json)
  bin_terraform_version=$(               jq -r '.terraform.linux' createenv-dependencies-and-cli-versions-aws.json)
  deployment_concourse_release_url=$(    jq -r '.[] | select(.value.name? == "concourse") | .value.url' ops/versions-aws.json)
  deployment_concourse_release_version=$(jq -r '.[] | select(.value.name? == "concourse") | .value.version' ops/versions-aws.json)
  deployment_credhub_release_url=$(      jq -r '.[] | select(.value.name? == "credhub") | .value.url' ops/versions-aws.json)
  deployment_credhub_release_version=$(  jq -r '.[] | select(.value.name? == "credhub") | .value.version' ops/versions-aws.json)
  deployment_garden_release_url=$(       jq -r '.[] | select(.value.name? == "garden-runc") | .value.url' ops/versions-aws.json)
  deployment_garden_release_version=$(   jq -r '.[] | select(.value.name? == "garden-runc") | .value.version' ops/versions-aws.json)
  deployment_grafana_release_url=$(      jq -r '.[] | select(.value.name? == "grafana") | .value.url' ops/versions-aws.json)
  deployment_grafana_release_version=$(  jq -r '.[] | select(.value.name? == "grafana") | .value.version' ops/versions-aws.json)
  deployment_influxdb_release_url=$(     jq -r '.[] | select(.value.name? == "influxdb") | .value.url' ops/versions-aws.json)
  deployment_influxdb_release_version=$( jq -r '.[] | select(.value.name? == "influxdb") | .value.version' ops/versions-aws.json)
  deployment_riemann_release_url=$(      jq -r '.[] | select(.value.name? == "riemann") | .value.url' ops/versions-aws.json)
  deployment_riemann_release_version=$(  jq -r '.[] | select(.value.name? == "riemann") | .value.version' ops/versions-aws.json)
  deployment_stemcell_version=$(         jq -r '.[] | select(.path == "/stemcells/alias=xenial/version") | .value' ops/versions-aws.json)
  deployment_uaa_release_url=$(          jq -r '.[] | select(.value.name? == "uaa") | .value.url' ops/versions-aws.json)
  deployment_uaa_release_version=$(      jq -r '.[] | select(.value.name? == "uaa") | .value.version' ops/versions-aws.json)
  director_bosh_cpi_release_url=$(       jq -r .cpi.url createenv-dependencies-and-cli-versions-aws.json)
  director_bosh_cpi_release_version=$(   jq -r .cpi.version createenv-dependencies-and-cli-versions-aws.json)
  director_bosh_release_url=$(           jq -r .bosh.url createenv-dependencies-and-cli-versions-aws.json)
  director_bosh_release_version=$(       jq -r .bosh.version createenv-dependencies-and-cli-versions-aws.json)
  director_bpm_release_url=$(            jq -r .bpm.url createenv-dependencies-and-cli-versions-aws.json)
  director_bpm_release_version=$(        jq -r .bpm.version createenv-dependencies-and-cli-versions-aws.json)
  director_stemcell_version=$(           jq -r .stemcell.url createenv-dependencies-and-cli-versions-aws.json | cut -d= -f2)

  bin_bosh_cli_version_gcp=$(                jq -r '."bosh-cli".linux' createenv-dependencies-and-cli-versions-gcp.json)
  bin_terraform_version_gcp=$(               jq -r '.terraform.linux' createenv-dependencies-and-cli-versions-gcp.json)
  deployment_concourse_release_url_gcp=$(    jq -r '.[] | select(.value.name? == "concourse") | .value.url' ops/versions-gcp.json)
  deployment_concourse_release_version_gcp=$(jq -r '.[] | select(.value.name? == "concourse") | .value.version' ops/versions-gcp.json)
  deployment_credhub_release_url_gcp=$(      jq -r '.[] | select(.value.name? == "credhub") | .value.url' ops/versions-gcp.json)
  deployment_credhub_release_version_gcp=$(  jq -r '.[] | select(.value.name? == "credhub") | .value.version' ops/versions-gcp.json)
  deployment_garden_release_url_gcp=$(       jq -r '.[] | select(.value.name? == "garden-runc") | .value.url' ops/versions-gcp.json)
  deployment_garden_release_version_gcp=$(   jq -r '.[] | select(.value.name? == "garden-runc") | .value.version' ops/versions-gcp.json)
  deployment_grafana_release_url_gcp=$(      jq -r '.[] | select(.value.name? == "grafana") | .value.url' ops/versions-gcp.json)
  deployment_grafana_release_version_gcp=$(  jq -r '.[] | select(.value.name? == "grafana") | .value.version' ops/versions-gcp.json)
  deployment_influxdb_release_url_gcp=$(     jq -r '.[] | select(.value.name? == "influxdb") | .value.url' ops/versions-gcp.json)
  deployment_influxdb_release_version_gcp=$( jq -r '.[] | select(.value.name? == "influxdb") | .value.version' ops/versions-gcp.json)
  deployment_riemann_release_url_gcp=$(      jq -r '.[] | select(.value.name? == "riemann") | .value.url' ops/versions-gcp.json)
  deployment_riemann_release_version_gcp=$(  jq -r '.[] | select(.value.name? == "riemann") | .value.version' ops/versions-gcp.json)
  deployment_stemcell_version_gcp=$(         jq -r '.[] | select(.path == "/stemcells/alias=xenial/version") | .value' ops/versions-gcp.json)
  deployment_uaa_release_url_gcp=$(          jq -r '.[] | select(.value.name? == "uaa") | .value.url' ops/versions-gcp.json)
  deployment_uaa_release_version_gcp=$(      jq -r '.[] | select(.value.name? == "uaa") | .value.version' ops/versions-gcp.json)
  director_bosh_cpi_release_url_gcp=$(       jq -r .cpi.url createenv-dependencies-and-cli-versions-gcp.json)
  director_bosh_cpi_release_version_gcp=$(   jq -r .cpi.version createenv-dependencies-and-cli-versions-gcp.json)
  director_bosh_release_url_gcp=$(           jq -r .bosh.url createenv-dependencies-and-cli-versions-gcp.json)
  director_bosh_release_version_gcp=$(       jq -r .bosh.version createenv-dependencies-and-cli-versions-gcp.json)
  director_bpm_release_url_gcp=$(            jq -r .bpm.url createenv-dependencies-and-cli-versions-gcp.json)
  director_bpm_release_version_gcp=$(        jq -r .bpm.version createenv-dependencies-and-cli-versions-gcp.json)
  director_stemcell_version_gcp=$(           jq -r .stemcell.url createenv-dependencies-and-cli-versions-gcp.json | cut -d= -f2)
popd

pushd ops-version
  ops_version=$(cat version)
popd

name="control-tower $version"

echo "$name" > release-vars/name

cat << EOF > release-vars/body

Auto-generated release

Deploys:

**AWS**

- Concourse VM stemcell bosh-aws-xen-hvm-ubuntu-xenial-go_agent $deployment_stemcell_version
- Director stemcell     bosh-aws-xen-hvm-ubuntu-xenial-go_agent $director_stemcell_version
- Concourse [$deployment_concourse_release_version]($deployment_concourse_release_url)
- Garden RunC [$deployment_garden_release_version]($deployment_garden_release_url)
- BOSH [$director_bosh_release_version]($director_bosh_release_url)
- BOSH AWS CPI [$director_bosh_cpi_release_version]($director_bosh_cpi_release_url)
- BPM [$director_bpm_release_version]($director_bpm_release_url)
- Credhub [$deployment_credhub_release_version]($deployment_credhub_release_url)
- Grafana [$deployment_grafana_release_version]($deployment_grafana_release_url)
- InfluxDB [$deployment_influxdb_release_version]($deployment_influxdb_release_url)
- Riemann [$deployment_riemann_release_version]($deployment_riemann_release_url)
- UAA [$deployment_uaa_release_version]($deployment_uaa_release_url)
- BOSH CLI $bin_bosh_cli_version
- Terraform $bin_terraform_version

**GCP**

- Concourse VM stemcell bosh-google-kvm-ubuntu-xenial-go_agent $deployment_stemcell_version_gcp
- Director stemcell     bosh-google-kvm-ubuntu-xenial-go_agent $director_stemcell_version_gcp
- Concourse [$deployment_concourse_release_version_gcp]($deployment_concourse_release_url_gcp)
- Garden RunC [$deployment_garden_release_version_gcp]($deployment_garden_release_url_gcp)
- BOSH [$director_bosh_release_version_gcp]($director_bosh_release_url_gcp)
- BOSH GCP CPI [$director_bosh_cpi_release_version_gcp]($director_bosh_cpi_release_url_gcp)
- BPM [$director_bpm_release_version_gcp]($director_bpm_release_url_gcp)
- Credhub [$deployment_credhub_release_version_gcp]($deployment_credhub_release_url_gcp)
- Grafana [$deployment_grafana_release_version_gcp]($deployment_grafana_release_url_gcp)
- InfluxDB [$deployment_influxdb_release_version_gcp]($deployment_influxdb_release_url_gcp)
- Riemann [$deployment_riemann_release_version_gcp]($deployment_riemann_release_url_gcp)
- UAA [$deployment_uaa_release_version_gcp]($deployment_uaa_release_url_gcp)
- BOSH CLI $bin_bosh_cli_version_gcp
- Terraform $bin_terraform_version_gcp

>Note to build locally you will need to clone [control-tower-ops](https://github.com/EngineerBetter/control-tower-ops/tree/$ops_version) (version $ops_version) to the same level as control-tower to get the required manifests and ops files.
EOF

pushd control-tower
  commit=$(git rev-parse HEAD)
popd

echo "$commit" > release-vars/commit
