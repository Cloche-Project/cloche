<p align="center">
  <picture>
    <img src="cloche-logo/watermark.png" alt="Cloche OS Logo" height="80" />
  </picture>
</p>

<!-- <h2 align="center">Cloche OS - Headless Base</h2> -->

<p align="center">
  <strong>RPM-OStree Base Image</strong>
</p>

<p align="center">
  <a href="https://github.com/cloche-project/cloche/actions/workflows/build.yml">
    <img src="https://github.com/cloche-project/cloche/actions/workflows/build.yml/badge.svg" alt="Build Status" />
  </a>
  <a href="https://ghcr.io/cloche-project/cloche">
    <img src="https://img.shields.io/badge/container-GHCR-blue.svg" alt="GHCR Registry" />
  </a>
  <a href="https://github.com/cloche-project/cloche/tags">
    <img src="https://img.shields.io/github/v/tag/cloche-project/cloche?label=version&color=blue&sort=semver" alt="Version" />
  </a>
  <img src="https://img.shields.io/github/repo-size/cloche-project/cloche" alt="Repository Size" />
  <img src="https://img.shields.io/github/commit-activity/m/cloche-project/cloche" alt="Commit Activity" />
  <img src="https://img.shields.io/github/license/cloche-project/cloche" alt="License" />
</p>

---

## Technical Overview

This image serves as the minimal, headless baseline layer for the Cloche (`OS-tree`) ecosystem. Built via the **BlueBuild framework** utilizing container-native `rpm-ostree` deployment models, this repository handles the core operating system layering.

Rather than being deployed directly as an end-user workstation, this headless image is engineered to function as the upstream foundation for downstream environments.

### Core Architecture
* **Upstream Foundation:** Universal Blue (`ubue-os`) core components.
* **Deployment Model:** Image-based, declarative configuration tracking via YAML recipes.
* **Container Integration:** Podman and Docker engines pre-configured for rootless and rootful container workloads.
<!-- * **Security Baseline:** Hardened SELinux profiles and strict separation between system layers and persistent user applications. -->

---

## Key Features

* **Minimal Footprint:** Stripped of all graphical environments, Wayland components, and desktop-oriented media codecs.
* **Predictable Lifecycle:** Automated system updates managed cleanly with less risk of state drift.
* **Infrastructure Tooling:** Pre-installed utilities such as (`distrobox`, `just`, and basic network debugging tools).
<!-- * **Network Optimization:** Google's BBR TCP congestion control enabled by default for high-throughput network operations.-->

---

## Deployment & Installation

### Remote Rebase
To transition an existing compatible atomic/immutable installation to this headless base, execute the following command:

```bash
# Rebase the system to the unverified public registry
rpm-ostree rebase ostree-unverified-registry:ghcr.io/cloche-project/cloche:latest
```

### Apply the changes by performing a system reboot:

```bash
systemctl reboot
```

<!-- ### Local ISO Generation

If you need to provision bare-metal nodes or hypervisors, generate a bootable ISO locally utilizing the BlueBuild CLI:
Bash

 # Generate bootable installation medium locally
sudo bluebuild generate-iso --iso-name cloche-headless.iso image ghcr.io/augustofmarques/cloche-pro:latest -->

## Verification & Security

Images are cryptographically signed via Sigstore Cosign. To verify the integrity of the downloaded image layer, fetch the public key from this repository and run:

```Bash
cosign verify --key cosign verify --key cosign.pub ghcr.io/cloche-project/cloche:latest
```

**Note: For systems running Secure Boot, ensure you enroll the public key (secure_boot.der) before applying the system rebase.**