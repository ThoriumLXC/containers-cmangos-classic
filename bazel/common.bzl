"""
Standard metadata for all of the container images.
"""

# The name/prefix for the repository images.
REPO_NAME = "cmangos-classic"

# Linux user (uid/gid)
STANDARD_USER = "mangos"
STANDARD_USER_ID = "7878"
STANDARD_USER_GID = "7878"

# Build Parameters
BUILD_DIRECTORY = "/opt/mangos"

# Common labels
IMAGE_LABELS = {
    "org.opencontainers.image.licenses": "GPL-2.0",
    "org.opencontainers.image.source": "https://github.com/ThoriumLXC/container-cmangos-classic",
    "org.opencontainers.image.url": "https://github.com/ThoriumLXC/container-cmangos-classic",
    "org.opencontainers.image.authors": "ThoriumLXC",
    "org.opencontainers.image.vendor": "ThoriumLXC",
}
