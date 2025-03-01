# Architecture Overview

## WORKSPACE, MODULE.bazel, BUILD.bazel

These top-level files establish the Bazel workspace. WORKSPACE sets up the project environment and external dependencies, MODULE.bazel manages module-specific definitions, and BUILD.bazel contains the primary build targets.

## bazel/

This directory provides shared scripts and utilities for Bazel.

## containers/

Container configurations are maintained here. Each directory is responsible for the container images in the build processes, and separates build-time from runtime environments.

## docs/

Documentation is specific to the build processes of this repository. Documentation for use of the images is maintained in another repository.

## scripts/

Utility scripts for build automation, deployment, and maintenance are located in this folder.

## tests/

Tests for spinning up prototypes of the local images builds for verifying behaviour.

## third_party/

Third-party dependencies and patches are managed here. This section controls external code integrations and applies necessary modifications for compatibility.
