load("@aspect_bazel_lib//lib:tar.bzl", "mtree_mutate", "mtree_spec", "tar")

SRCS = glob([
    "*",
    "**/*",
], exclude=["WORKSPACE", "BUILD.bazel"])

mtree_spec(
    name = "files",
    srcs = SRCS,
)

mtree_mutate(
    name = "repackage",
    mtree = ":files",
    package_dir = "source/classic-db",
)

tar(
    name = "source",
    srcs = SRCS,
    mtree = "repackage",
    visibility = ["//visibility:public"],
)
