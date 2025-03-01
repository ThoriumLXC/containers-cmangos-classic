"""
Dependency installation for the cmangos repositories.
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

CMANGOS_MANGOS_CLASSIC_COMMIT = "f0fab6b47cc892c185b8370208d7ee729fdaeae8"
CMANGOS_PLAYERBOTS_COMMIT = "50a69d2071c723e4f49306ab1ccfb434fccb0661"

SOURCE_REF_LABELS = {
    # cmangos.net/mangos-classic
    "net.cmangos.mangos-classic.revision": CMANGOS_MANGOS_CLASSIC_COMMIT,
    "net.cmangos.mangos-classic.source": "https://github.com/cmangos/mangos-classic",
    "net.cmangos.mangos-classic.url": "https://github.com/cmangos/mangos-classic",
    # cmangos.net/playerbots
    "net.cmangos.playerbots.revision": CMANGOS_PLAYERBOTS_COMMIT,
    "net.cmangos.playerbots.source": "https://github.com/cmangos/playerbots",
    "net.cmangos.playerbots.url": "https://github.com/cmangos/playerbots",
    # cmangos.net/classic-db
    "net.cmangos.classic-db.revision": "2025-02-22",
    "net.cmangos.classic-db.source": "https://github.com/cmangos/classic-db",
    "net.cmangos.classic-db.url": "https://github.com/cmangos/classic-db",
}

def import_dependencies(name = "cmangos"):
    """Setup the archives to pull the git repositories for cmangos-classic

    Args:
        name: A name prefix for all repositories.
    """

    http_archive(
        name = "{name}_mangos_classic".format(name = name),
        url = "https://github.com/cmangos/mangos-classic/archive/{commit}.tar.gz".format(commit = CMANGOS_MANGOS_CLASSIC_COMMIT),
        strip_prefix = "mangos-classic-{commit}".format(commit = CMANGOS_MANGOS_CLASSIC_COMMIT),
        sha256 = "88760bcc1ed66789f9dca951b04fb6aa72177dc7d117e4c917a50f890e3815c6",
        build_file = "//:third_party/cmangos_mangos_classic.BUILD",
        patches = [
            "//:third_party/patches/cmangos/mangos-classic/CMakeLists.patch",
        ],
    )

    http_archive(
        name = "{name}_classic_playerbots".format(name = name),
        url = "https://github.com/cmangos/playerbots/archive/{commit}.tar.gz".format(commit = CMANGOS_PLAYERBOTS_COMMIT),
        strip_prefix = "playerbots-{commit}".format(commit = CMANGOS_PLAYERBOTS_COMMIT),
        sha256 = "42d1a37dd1043f9f2d26d046d7f57c3d8f8768df781b62261e778f12092741cf",
        build_file = "//:third_party/cmangos_classic_playerbots.BUILD",
    )

    http_archive(
        name = "{name}_classic_db".format(name = name),
        url = "https://github.com/ThoriumLXC/cmangos-db/releases/download/cmangos-classic/classic-all-db.zip",
        sha256 = "c727486eedd14fb0786fcd4474bfe16eba00a82f44d00dc4066254f722194a68",
        build_file = "//:third_party/cmangos_classic_db.BUILD",
    )
