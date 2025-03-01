"""
Helper build actions for running container images with `docker run` to
allow extracting files from processes executed within the container images.
"""

load("@aspect_bazel_lib//lib:run_binary.bzl", "run_binary")
load("@aspect_bazel_lib//lib:tar.bzl", "mtree_mutate", "mtree_spec")

DOCKER_SCRIPT = """#!/bin/bash
set -e

image="$(cat "{image}")"
CONTAINER_ID=$(docker create --entrypoint="" {env_flags} $image {command_str})
docker start -a $CONTAINER_ID

mkdir -p "$@"
docker cp $CONTAINER_ID:{out_dir}/. $@/

docker rm $CONTAINER_ID
"""

def _docker_run_and_extract_action_impl(ctx):
    env_flags = " ".join(["-e {k}={v}".format(k = k, v = v) for k, v in ctx.attr.env.items()])
    command_str = " ".join(ctx.attr.command)
    script_content = DOCKER_SCRIPT.format(
        out_dir = ctx.attr.out_dir,
        image = ctx.file.image.path,
        env_flags = env_flags,
        command_str = command_str,
    )

    output_file = ctx.actions.declare_file(ctx.label.name + ".sh")
    ctx.actions.write(
        output = output_file,
        content = script_content,
        is_executable = True,
    )

    return [DefaultInfo(files = depset([output_file, ctx.file.image]), executable = output_file)]

docker_run_and_extract_action = rule(
    implementation = _docker_run_and_extract_action_impl,
    attrs = {
        "env": attr.string_dict(
            doc = "Dictionary of environment variables to pass to the container.",
        ),
        "image": attr.label(
            doc = "Name (and optional tag) of the image to run.",
            mandatory = True,
            allow_single_file = True,
        ),
        "command": attr.string_list(
            doc = "List of command arguments to execute inside the container.",
            mandatory = True,
        ),
        "out_dir": attr.string(
            doc = "Directory to extract from the container.",
            mandatory = True,
        ),
    },
    executable = True,
    doc = """
Generates an executable shell script that runs a specified container image, with the provided environment variables,
and commands. When completed the files located at the given output directory in the container are extracted.
""",
)

def remove_leading_slash(path):
    if path.startswith("/"):
        return path[1:]
    return path

def docker_load(
        name,
        image,
        tags,
        **kwargs):
    """
    Load a tarball into the docker daemon.

    Args:
        name: Prefix of the Bazel target created by this macro.
        image: The tarball of the image.
        tags: A file defining the tag of the image.
        **kwargs: Additional keyword arguments.
    """
    tarball_name = name + "_tarball"
    native.filegroup(
        name = tarball_name,
        srcs = [image],
        output_group = "tarball",
    )

    cmd_load = "docker load -i $(location :{label})".format(label = tarball_name)
    cmd_tags = "cat $(location {tags}) > $@".format(tags = tags)
    script_contents = cmd_load + " && " + cmd_tags

    native.genrule(
        name = name,
        srcs = [tarball_name, tags],
        outs = [name + ".txt"],
        cmd = script_contents,
        **kwargs
    )

def docker_run_and_extract(
        name,
        src,
        command,
        out_dir,
        env = {}):
    """
    Sets up a target to run a Docker container extracting files from the container.

    Args:
        name: Prefix of the Bazel target created by this macro.
        src: The image to load.
        env:
            A dictionary of environment variables that will be passed to the
            container using `-e KEY=VALUE`. Example:

                {
                    "FOO": "BAR",
                    "HELLO": "WORLD"
                }
        command:
            A list of command-line arguments that define what should run inside
            the container. For example:

                [
                    "bash",
                    "-c",
                    "echo 'Doing work'; cp /path/inside/container /out_dir/"
                ]
        out_dir: The directory in the container to extract files from.
    """

    docker_script_name = name + "_script"
    docker_run_and_extract_action(
        name = docker_script_name,
        env = env,
        image = src,
        command = command,
        out_dir = out_dir,
    )

    out_dir = name + ".out"
    run_binary(
        name = name,
        srcs = [src, ":" + docker_script_name],
        args = ["$@"],
        execution_requirements = {
            "local": "1",
            "exclusive": "true",
        },
        mnemonic = "DockerRunAndExtract",
        out_dirs = [out_dir],
        tool = ":" + docker_script_name,
    )

    mspec = name + ".mkspec"
    mtree_spec(
        name = mspec,
        srcs = [":" + name],
    )

    mtree = name + ".mtree"
    mtree_mutate(
        name = mtree,
        mtree = ":" + mspec,
        strip_prefix = "{pkg}/{out_dir}".format(pkg = native.package_name(), out_dir = out_dir),
    )
