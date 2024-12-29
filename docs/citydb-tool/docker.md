---
# title: Docker
subtitle: CityDB tool Docker documentation
description: CityDB tool Docker documentation and usage examples
icon: fontawesome/brands/docker
status: wip
tags:
  - docker
  - citydb-tool
---

<!--

<eMailaddr>
<link>
<link in new tab>{target="_blank"}
[Open Link](https://www.werder.de)
[Open in new tab](https://www.werder.de){target="_blank"}

# Admonitions
[!!!|???] note|abstract|info|tip|success|question|warning|failure|danger|bug|example|quote [inline|inline end] "Der Title statt Note|..."
    Content content

# Images
![Image title](https://dummyimage.com/600x400/eee/aaa){ align=left }

![Image title](https://dummyimage.com/600x400/){ width="300" }
/// caption
Image caption
///

# Figures
![Image title](https://dummyimage.com/600x400/){ width="300" }
/// figure-caption
Image caption
///

-->

# Using CityDB tool with Docker

The `citydb-tool` Docker images expose the capabilities of the [`citydb-tool`](../citydb-tool/index.md) CLI for dockerized applications and workflows.

## TL;DR

``` bash

docker run --rm --name citydb-tool [-i -t] \
    [-e CITYDB_HOST=the.host.de] \
    [-e CITYDB_PORT=5432] \
    [-e CITYDB_NAME=theDBName] \
    [-e CITYDB_SCHEMA=theCityDBSchemaName] \
    [-e CITYDB_USERNAME=theUsername] \
    [-e CITYDB_PASSWORD=theSecretPass] \
    [-v /my/data/:/data] \
  3dcitydb/citydb-tool[:TAG] COMMAND
```

!!! tip

    Use the `help` command to list all CLI parameters and arguments. For subcommands (e.g. `import citygml`) us this syntax `import help citygml` to show CLI options.

## Image variants and versions

The `citydb-tool` Docker images are based on [Eclpise Temurin JRE 21](https://hub.docker.com/_/eclipse-temurin){target="blank"}.
They are available from [3DCityDB DockerHub](https://hub.docker.com/r/3dcitydb/citydb-tool){target="blank"} or [Github Container registry (ghcr.io)](https://github.com/3dcitydb/citydb-tool/pkgs/container/citydb-tool){target="blank"}.

=== "Dockerhub"

    ``` bash
    docker pull 3dcitydb/citydb-tool
    ```

=== "ghcr.io"

    ``` bash
    docker pull ghcr.io/3dcitydb/citydb-tool
    ```

### Tags

We publish images for two types of events. For each __release__ on Github (e.g. `v1.2.3`) we provide a set images using the _`citydb-tool` version_ as tag.
The tags composed of `<major>.<minor>` and `<major>` are volatile and point to the latest `citydb-tool` release. For instance, `1` and `1.2` will point to `1.2.3`, if this is the latest version. This is handy, when you want automatic updates for minor or micro releases. The `latest` tag points alway to the latest release version.

=== "Dockerhub"

    ``` bash
    docker pull 3dcitydb/citydb-tool:1.0.0
    docker pull 3dcitydb/citydb-tool:1.0
    docker pull 3dcitydb/citydb-tool:1
    docker pull 3dcitydb/citydb-tool:latest
    ```

=== "ghcr.io"

    ``` bash
    docker pull ghcr.io/3dcitydb/citydb-tool:1.0.0
    docker pull ghcr.io/3dcitydb/citydb-tool:1.0
    docker pull ghcr.io/3dcitydb/citydb-tool:1
    docker pull ghcr.io/3dcitydb/citydb-tool:latest
    ```

For each push to the _main_ branch of the [`citydb-tool` repository](https://github.com/3dcitydb/citydb-tool){target="blank"} we publish a fresh version of the __edge__ image.

=== "Dockerhub"

    ``` bash
    docker pull 3dcitydb/citydb-tool:edge
    ```

=== "ghcr.io"

    ``` bash
    docker pull ghcr.io/3dcitydb/citydb-tool:edge
    ```

!!! warning
    The `edge` images contain the latest state of development. It may contain bugs and should not be used for production purposes.

<table>
<caption>3DCityDB Importer/Exporter Docker image variants and major
versions</caption>
<thead>
<tr>
<th>Tag</th>
<th>Debian</th>
<th>Alpine</th>
</tr>
</thead>
<tbody>
<tr>
<td>edge</td>
<td><a
href="https://hub.docker.com/r/3dcitydb/impexp/tags?page=1&amp;ordering=last_updated"><img
src="https://img.shields.io/github/actions/workflow/status/%0A3dcitydb/importer-exporter/docker-build-edge.yml?%0Astyle=flat-square&amp;logo=Docker&amp;logoColor=white"
alt="deb-build-edge" /></a> <a
href="https://hub.docker.com/r/3dcitydb/impexp/tags?page=1&amp;ordering=last_updated"><img
src="https://img.shields.io/docker/image-size/%0A3dcitydb/impexp/edge?label=image%20size&amp;logo=Docker&amp;logoColor=white&amp;style=flat-square"
alt="deb-size-edge" /></a></td>
<td><a
href="https://hub.docker.com/r/3dcitydb/impexp/tags?page=1&amp;ordering=last_updated"><img
src="https://img.shields.io/github/actions/workflow/status/%0A3dcitydb/importer-exporter/docker-build-edge-alpine.yml?%0Astyle=flat-square&amp;logo=Docker&amp;logoColor=white"
alt="alp-build-edge" /></a> <a
href="https://hub.docker.com/r/3dcitydb/impexp/tags?page=1&amp;ordering=last_updated"><img
src="https://img.shields.io/docker/image-size/%0A3dcitydb/impexp/edge-alpine?label=image%20size&amp;logo=Docker&amp;logoColor=white&amp;style=flat-square"
alt="alp-size-edge" /></a></td>
</tr>
<tr>
<td>latest</td>
<td><a
href="https://hub.docker.com/r/3dcitydb/impexp/tags?page=1&amp;ordering=last_updated"><img
src="https://img.shields.io/docker/image-size/%0A3dcitydb/impexp/latest?label=image%20size&amp;logo=Docker&amp;logoColor=white&amp;style=flat-square"
alt="deb-size-latest" /></a></td>
<td><a
href="https://hub.docker.com/r/3dcitydb/impexp/tags?page=1&amp;ordering=last_updated"><img
src="https://img.shields.io/docker/image-size/%0A3dcitydb/impexp/latest-alpine?label=image%20size&amp;logo=Docker&amp;logoColor=white&amp;style=flat-square"
alt="alp-size-latest" /></a></td>
</tr>
<tr>
<td>5.0.0</td>
<td><a
href="https://hub.docker.com/r/3dcitydb/impexp/tags?page=1&amp;ordering=last_updated"><img
src="https://img.shields.io/docker/image-size/%0A3dcitydb/impexp/5.0.0?label=image%20size&amp;logo=Docker&amp;logoColor=white&amp;style=flat-square"
alt="deb-size-v5.0.0" /></a></td>
<td><a
href="https://hub.docker.com/r/3dcitydb/impexp/tags?page=1&amp;ordering=last_updated"><img
src="https://img.shields.io/docker/image-size/%0A3dcitydb/impexp/5.0.0-alpine?label=image%20size&amp;logo=Docker&amp;logoColor=white&amp;style=flat-square"
alt="alp-size-v5.0.0" /></a></td>
</tr>
</tbody>
</table>

Note

| Minor releases are not listed in this table. | The latest 3DCityDB
Importer/Exporter version is:
[![version-badge-github](https://img.shields.io/github/v/release/3dcitydb/importer-exporter?label=Github&logo=github)](https://github.com/3dcitydb/importer-exporter/releases)
| The latest image version on DockerHub is:
[![version-badge-dockerhub](https://img.shields.io/docker/v/3dcitydb/impexp?label=Docker%20Hub&logo=docker&logoColor=white&sort=semver)](https://hub.docker.com/r/3dcitydb/impexp/tags)


## Usage and configuration

The 3DCityDB Importer/Exporter Docker images do not require
configuration for most use cases and allow the usage of the
Importer/Exporter CLI out of the box. Simply append the
`Importer/Exporter CLI command <impexp_cli_chapter>` you want to execute
to the `docker run` command line.

    docker run --rm --name impexp 3dcitydb/impexp COMMAND

However, the database credentials can be passed to the Importer/Exporter
container using environment variables as well, as described in
`impexp_docker_env_vars_section`.

All import and export operations require a mounted directory for
exchanging data between the host system and the container. Use the `-v`
or `--mount` options of the `docker run` command to mount a directory or
file.

    # mount /my/data/ on the host system to /data inside the container
    docker run --rm --name impexp \
        -v /my/data/:/data \
      3dcitydb/impexp COMMAND

    # Mount the current working directory on the host system to /data
    # inside the container
    docker run --rm --name impexp \
        -v $(pwd):/data \
      3dcitydb/impexp COMMAND

Note

The default working directory inside the container is `/data`.

Tip

Watch out for __correct paths__ when working with mounts! All paths
passed to the Importer/Exporter CLI have to be specified from the
container's perspective. If you are not familiar with how Docker manages
volumes and bind mounts go through the [Docker volume
guide](https://docs.docker.com/storage/volumes/).

In order to allocate a console for the container process, you must use
`-i` `-t` together. This comes in handy, for instance, if you don't want
to pass the password for the 3DCityDB connection on the command line but
rather want to be prompted to enter it interactively on the console. You
must use the `-p` option of the Importer/Exporter CLI without a value
for this purpose (see `impexp_cli_chapter`) as shown in the example
below. Note that the `-i` `-t` options of the `docker run` command are
often combined and written as `-it`.

    docker run -it --rm --name impexp \
        -v /my/data/:/data \
      3dcitydb/impexp import \
        -H my.host.de -d citydb -u postgres -p \
        bigcity.gml

The `docker run` command offers further options to configure the
container process. Please check the [official
reference](https://docs.docker.com/engine/reference/run/) for more
information.

### Environment variables

The Importer/Exporter Docker images support the following environment
variables to set the credentials for the connection to a 3DCityDB
instance (see also `impexp_cli_environment_variables`).

Warning

When running the Importer/Exporter on the command line, the values of
these variables will be used as input if a corresponding CLI option is
__not__ available. Thus, the CLI options always take precedence.

CITYDB<span id="type">TYPE</span>=&lt;postgresql|oracle&gt;

The type of the 3DCityDB to connect to. _postgresql_ is the default.

CITYDB<span id="host">HOST</span>=&lt;hostname or ip&gt;

Name of the host or IP address on which the 3DCityDB is running.

CITYDB<span id="port">PORT</span>=&lt;port&gt;

Port of the 3DCityDB to connect to. Default is _5432_ for PostgreSQL and
_1521_ for Oracle.

CITYDB<span id="name">NAME</span>=&lt;dbName&gt;

Name of the 3DCityDB database to connect to.

CITYDB<span id="schema">SCHEMA</span>=&lt;citydb&gt;

Schema to use when connecting to the 3DCityDB (default: *citydb |
username*).

CITYDB<span id="username">USERNAME</span>=&lt;username&gt;

Username to use when connecting to the 3DCityDB

CITYDB<span id="password">PASSWORD</span>=&lt;thePassword&gt;

Password to use when connecting to the 3DCityDB

### User management and file permissions

When exchanging files between the host system and the Importer/Exporter
container it is import to make sure that files and directories have
permissions set correctly. For security reasons (see
[here](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user))
the Importer/Exporter runs as non-root user by default inside the
container. The default user is named `impexp` with user and group
identifier (uid, gid) = `1000`.

    $ docker run --rm --entrypoint bash 3dcitydb/impexp \
        -c "cat /etc/passwd | grep impexp"

    impexp:x:1000:1000::/data:/bin/sh

As 1000 is the default uid/gid for the first user on many Linux
distributions in most cases you won't notice this, as the user on the
host system is going to have the same uid/gid as inside the container.
However, if you are facing file permission issues, you can run the
Importer/Exporter container as another user with the `-u` option of the
`docker run` command. This way you can make sure, that the right
permissions are set on generated files in the mounted directory.

The following example illustrates how to use the `-u` option to pass the
user ID of your current host's user.

    docker run --rm --name impexp \
        -u $(id -u):$(id -g) \
        -v /my/data/:/data \
      3dcitydb/impexp COMMAND

## Build your own images

3DCityDB Importer/Exporter images are easily built on your own. The
images support two build arguments:

BUILDER<span id="image_tag">IMAGE\_TAG</span>=&lt;tag of the builder
image&gt;

Set the tag of the builder image, which is `openjdk` for the Debian and
`adoptopenjdk/openjdk11` for the Alpine image variant. This base image
is only used for building the Importer/Exporter from source.

RUNTIME<span id="image_tag">IMAGE\_TAG</span>=&lt;tag of the runtime
image&gt;

Set the tag of the runtime image, which is `openjdk` for the Debian and
`adoptopenjdk/openjdk11` for the Alpine image variant. This is the base
image the container runs with.

__Build process__

1.  Clone the [Importer/Exporter Github
    repository](https://github.com/3dcitydb/importer-exporter) and
    navigate to the cloned repo:

        git clone https://github.com/3dcitydb/importer-exporter.git
        cd importer-exporter

2.  Build the image using [docker
    build](https://docs.docker.com/engine/reference/commandline/build/):

> # Debian variant
>     docker build . \
>       -t 3dcitydb/impexp
>
>     # Alpine variant
>     docker build . \
>       -t 3dcitydb/impexp \
>       -f Dockerfile.alpine

## Examples

For the following examples we assume that a 3DCityDB instance with the
following settings is running:

    HOSTNAME      my.host.de
    PORT          5432
    DB TYPE       postgresql
    DB DBNAME     citydb
    DB USERNAME   postgres
    DB PASSWORD   changeMe!

### Importing CityGML

This section provides some examples for importing CityGML datasets.
Refer to `impexp_cli_import_command` for a detailed description of the
Importer/Exporter CLI import command.

Import the CityGML dataset `/home/me/mydata/bigcity.gml` on you host
system into the DB given in `impexp_docker_code_exampledb`:

    docker run --rm --name impexp \
        -v /home/me/mydata/:/data \
      3dcitydb/impexp import \
        -H my.host.de -d citydb -u postgres -p changeMe! \
        bigcity.gml

Note

Since the host directory `/home/me/mydata/` is mounted to the default
working directory `/data` inside the container, you can simply reference
your input file by its filename instead of using an absolute path.

Import all CityGML datasets from `/home/me/mydata/` on your host system
into the DB given in `impexp_docker_code_exampledb`:

    docker run --rm --name impexp \
        -v /home/me/mydata/:/data \
      3dcitydb/impexp import \
        -H my.host.de -d citydb -u postgres -p changeMe! \
        /data/

### Exporting CityGML

This section provides some examples for exporting CityGML datasets.
Refer to `impexp_cli_export_command` for a detailed description of the
Importer/Exporter CLI export command.

Export all data from the DB given in `impexp_docker_code_exampledb` to
`/home/me/mydata/output.gml`:

    docker run --rm --name impexp \
        -v /home/me/mydata/:/data \
      3dcitydb/impexp export \
        -H my.host.de -d citydb -u postgres -p changeMe! \
        -o output.gml

### Importer/Exporter Docker combined with 3DCityDB Docker

This example shows how to use the 3DCityDB and Importer/Exporter Docker
images in conjunction. Let's assume we have a CityGML containing a few
buildings file on our Docker host at: `/d/temp/buildings.gml`

First, let's bring up a Docker network and a 3DCityDB instance using the
`3DCityDB Docker images <citydb_docker_chapter>`. As the emphasized line
shows, we name the container `citydb`. You can use the
`LoD3 Railway dataset <https://github.com/3dcitydb/importer-exporter/raw/master/resources/samples/Railway%20Scene/Railway_Scene_LoD3.zip>`
for testing.

    docker network create citydb-net

    docker run -d --name citydb \
        --network citydb-net \
        -e POSTGRES_PASSWORD=changeMe \
        -e SRID=25832 \
      3dcitydb/3dcitydb-pg:latest-alpine

The next step is to `import <impexp_cli_import_command>` our data to the
3DCityDB container. Therefore, we need to mount our data directory to
the container, as shown in line 3. The emphasized lines show how to use
the container name from the first step as hostname when both containers
are attached to the same Docker network.

Note

There are many other networking options to connect Docker containers.
Take a look at the Docker [networking
overview](https://docs.docker.com/network/) to learn more.

    docker run -i -t --rm --name impexp \
        --network citydb-net \
        -v /d/temp:/data \
      3dcitydb/impexp:latest-alpine import \
        -H citydb \
        -d postgres \
        -u postgres \
        -p changeMe \
        /data/building.gml

Now, with our data inside the 3DCityDB, let's use the Importer/Exporter
to create a `visualization export <impexp_cli_export_vis_command>`. We
are going to export all Buildings in LoD 2 as binary glTF with embedded
textures and draco compression enabled. All Buildings will be translated
to elevation 0 to fit in a visualization without terrain model.

    docker run -i -t --rm --name impexp \
        --network citydb-net \
        -v /d/temp:/data \
      3dcitydb/impexp:latest-alpine export-vis \
        -H citydb \
        -d postgres \
        -u postgres \
        -p changeMe \
        -l 2 \
        -D collada \
        -G \
        --gltf-binary \
        --gltf-embed-textures \
        --gltf-draco-compression \
        -O globe \
        -o /data/building_glTf.kml

The export file are now available in `/d/temp`.

    $ ls -lhA /d/temp

    drwxrwxrwx 1 theUser theUser 4.0K May  6 17:51 Tiles/
    -rwxrwxrwx 1 theUser theUser 1.4K May  6 17:55 building_glTf.kml*
    -rwxrwxrwx 1 theUser theUser  310 May  6 17:55 building_glTf_collada_MasterJSON.json*
    -rwxrwxrwx 1 theUser theUser 3.2M May  5 16:25 buildings.gml*

As we are done now, the 3DCityDB container and the network are no longer
needed and can be removed:

    docker rm -f -v citydb
    docker network rm citydb-net
