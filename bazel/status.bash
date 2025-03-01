#!/bin/bash
# This workspace status file is used by Bazel to generate build metadata.
# It outputs a key-value pair—specifically for which this can be embedded into the build artifacts:

# CalVer for yielding 2025.12.01 style notations.
echo "STABLE_CALVER $(date +%Y.%m.%d)"