---
title: Docker
subtitle: Getting started with the 3DCityDB and Docker
description:
icon: fontawesome/brands/docker
status: wip
tags:
  - docker
---

The quickest way to get up and running with 3DCityDB is using Docker! On this page you will find quick start examples for the 3DCityDB and tools using Docker :fontawesome-brands-docker:.

## TL;DR

- 3D City Database

    ``` bash
    docker run -d -p 5432:5432 --name citydb \
      -e POSTGRES_PASSWORD=changeMe! \
      -e SRID=25832 \
    3dcitydb/3dcitydb-pg
    ```

- CityDB tool

    ``` shell
    docker run -i -t --rm --name citydb-tool \
      -v /my/data/:/data \
      -e CITYDB_HOST=the.host.de \
      -e CITYDB_PORT=5432 \
      -e CITYDB_NAME=theDBName \
      -e CITYDB_SCHEMA=theCityDBSchemaName \
      -e CITYDB_USERNAME=theUsername \
      -e CITYDB_PASSWORD=theSecretPass \
    3dcitydb/citydb-tool [help|import|export|delete|index]
    ```

    !!! tip

        The CityDB tool commands are documented [here](../CityDB%20tool/) and can be listed using the `help` command.

## Intro

[Docker :fontawesome-brands-docker:](https://docker.com) is a widely used virtualization technology that makes it possible to pack an application with all its required resources into a standardized unit - the *Docker Container*. Software encapsulated in this way can run on Linux, Windows, macOS and most cloud services without any further changes or setup process. Docker containers are lightweight compared to traditional virtualization environments that emulate an entire operating system, because they contain only the application and all the tools, program libraries, and files it requires.

Docker enables you to get a 3DCityDB instance up and running in a fews seconds, without having to setup a database server or the 3DCityDB database schema, as shown below.

![Docker example](assets/citydb_docker_term.gif)
/// figure-caption
Setup a 3DCityDB instance using Docker and establish a connection to the ready-to-use 3DCityDB in seconds.
///

Docker images are available for the following tools of the 3DCityDB software suite:

- [3D City Database](3dcitydb.md)
- [CityDB tool](../CityDB tool/)
- [3D Web Map Client](https://3dcitydb-docs.readthedocs.io/en/latest/webmap/docker.html)
- [3DCityDB Web Feature Service (WFS)](https://3dcitydb-docs.readthedocs.io/en/latest/wfs/docker.html)

All images are available from [DockerHub] or Github container registry ([ghcr.io]).

## Quick start examples

The following sections provide *quick start* code snippets for all 3DCityDB Docker images to get you running in a few seconds. For a more comprehensive documentation please visit the individual chapters of each image.

!!! note "Line continuation characters"

    Replace the line continuation character `\` with `^` for Windows systems.

### 3DCityDB Docker

To run a PostgreSQL/PostGIS 3DCityDB container the only required settings are a database password (`POSTGRES_PASSWORD`) and the EPSG code of the coordinate reference system (`SRID`) of the 3DCityDB instance. Use the `docker run -p` switch to define a port to expose to the host system for database connections.

The detailed documentation for the 3DCityDB Docker image is available [here]().

``` bash
docker run -d -p 5432:5432 --name cdb \
  -e POSTGRES_PASSWORD=changeMe! \
  -e SRID=25832 \
3dcitydb/3dcitydb-pg
```

A container started with the command above will host a 3DCityDB instance
configured like this:

``` text
CONTAINER NAME    cdb
DB HOST           localhost or 127.0.0.1
DB PORT           5432
DB NAME           postgres
DB USER           postgres
DB PASSWD         changeMe!
DB SRID           25832
DB GMLSRSNAME     urn:ogc:def:crs:EPSG::25832
```

### CityDB tool Docker

The 3DCityDB Importer/Exporter Docker image exposes the Command Line
Interface (CLI) of the 3DCityDB Importer/Exporter. For all export or
import operations a shared folder (`docker run -v`) to exchange data
with the host system is required. It is recommended to run the container
as the currently logged in user and group (`docker run -u`) to ensure
files are readable/writeable.

The detailed documentation for the 3DCityDB Importer/Exporter Docker
image is available `here <impexp_docker_chapter>`{.interpreted-text
role="ref"}, the documentation of the CLI is available
`here <impexp_cli_chapter>`{.interpreted-text role="ref"}.

``` bash
docker run -i -t --name impexp --rm \
  -u $(id -u):$(id -g) \
  -v /local/data/dir:/data \
3dcitydb/impexp COMMAND
```

Use the `help` command to see the CLI documentation and list all
available commands:

``` bash
docker run -i -t --name impexp --rm 3dcitydb/impexp:edge-alpine help
```

Run `help COMMAND` to see the CLI documentation for a specific command:

``` bash
docker run -i -t --name impexp --rm 3dcitydb/impexp:edge-alpine help export
```

For instance, a simple CityGML export looks like this:

``` bash
docker run -i -t --name impexp --rm \
  -u $(id -u):$(id -g) \
  -v /local/data/dir:/data \
  3dcitydb/impexp \
    export -H my.citydb.host.de -d postgres -p postgres -u postgres -o out.gml
```

The exported file will be available on the host system at:
`/local/data/dir/out.gml`.

### 3D-Web-Map-Client Docker

The 3DCityDB 3D-Web-Map-Client Docker image provides an instance of the
3DCityDB 3D-Web-Map-Client. Use the `docker run -p` switch to expose a
port for connections to the web client.

Currently, the Webclient Docker images are maintained and documented at
the [TUM-GIS 3D-Web Client Docker
repo](https://github.com/tum-gis/3dcitydb-web-map-docker).

``` bash
docker run -d --name 3dwebmap-container -p 80:8000 tumgis/3dcitydb-web-map
```

### Web Feature Service (WFS) Docker

The 3DCityDB Web Feature Service (WFS) Docker image exposes the
capabilities of the `wfs_chapter`{.interpreted-text role="ref"} for
dockerized applications and workflows. Using the WFS Docker you can
expose the features stored in a 3DCityDB instance through an [OGC
WFS](https://www.ogc.org/standards/wfs) interface offering a rich set of
features like advanced filter capabilities. For a basic configuration
just the connection credentials of the 3DCityDB (`CITYDB_*` variables)
have to be specified.

All WFS
`functionalities <wfs_basic_functionality_chapter>`{.interpreted-text
role="ref"} are supported by the images.

The detailed documentation for the Docker image is available in
`wfs_docker_chapter`{.interpreted-text role="ref"}.

``` bash
docker run --name wfs [-d] -p 8080:8080 \
    [-e CITYDB_TYPE=PostGIS|Oracle] \
    [-e CITYDB_HOST=the.host.de] \
    [-e CITYDB_PORT=5432] \
    [-e CITYDB_NAME=theDBName] \
    [-e CITYDB_SCHEMA=theCityDBSchemaName] \
    [-e CITYDB_USERNAME=theUsername] \
    [-e CITYDB_PASSWORD=theSecretPass] \
    [-e WFS_CONTEXT_PATH=wfs-context-path] \
    [-e WFS_ADE_EXTENSIONS_PATH=/path/to/ade-extensions/] \
    [-e WFS_CONFIG_FILE=/path/to/config.xml] \
    [-v /my/data/config.xml:/path/to/config.xml] \
  3dcitydb/wfs[:TAG]
```

[Dockerhub]: https://hub.docker.com/u/3dcitydb
[ghcr.io]: https://github.com/orgs/3dcitydb/packages
