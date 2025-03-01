# Container Images

This directory is composed of multiple directories for each of the container images created in the build processes. These container images are documented roughly as follows.

All [variants](./variants.bzl) are tracked as an array, which are enumerated within the Bazel build.

## BuildDeps

An image only containing the build dependencies. Split from the builder to make it easier to isolate source code change differences from build dependency changes.

## Builder

An image that supports running the build process for the emulator server. This is fully self-contained, and executed by the [`BUILD.bazel`](./BUILD.bazel) file actions.

## Runtime

An image only containing the runtime dependencies. Split from the release image to make it easier to isolate differences between dependencies & the built binaries.

## Database

An image based off MariaDB that just bundles in SQL files & scripts for startup of the database.

## Extractor

An image based the runtime image, that uses the extractor tools to be a "ready to extract" container image.

## Release

An image based on the runtime image, including the built binaries, configuration & anything necessary to be ready-to-run.
