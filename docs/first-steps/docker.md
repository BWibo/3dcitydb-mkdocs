---
title: Docker
subtitle: Getting started with the 3DCityDB and Docker
description:
icon: fontawesome/brands/docker
status: wip
tags:
  - docker
  - 3dcitydb
  - citydb-tool
  - importer-exporter
  - wfs
  - 3d-web-map-client
  - quickstart
---

The quickest way to get up and running with 3DCityDB is using Docker! On this page you will find quick start examples for the 3DCityDB and tools using Docker :fontawesome-brands-docker:.

## TL;DR

- [3D City Database](../3dcitydb/docker.md)

    ``` bash
    docker run -d -p 5432:5432 --name citydb \
      -e POSTGRES_PASSWORD=changeMe! \
      -e SRID=25832 \
    3dcitydb/3dcitydb-pg
    ```

- [CityDB tool](../citydb-tool/docker.md)

    ``` bash
    docker run -i -t --rm --name citydb-tool \
      -v /my/data/:/data \
      -e CITYDB_HOST=the.host.de \
      -e CITYDB_PORT=5432 \ # (1)!
      -e CITYDB_NAME=theDBName \
      -e CITYDB_SCHEMA=theCityDBSchemaName \
      -e CITYDB_USERNAME=theUsername \
      -e CITYDB_PASSWORD=theSecretPass \
    3dcitydb/3dcitydb-pg-v5 [help|import|export|delete|index]
    ```

    !!! tip

        Use the `help` command to list all CLI parameters and arguments. For subcommands (e.g. `import citygml`) us this syntax `import help citygml` to show CLI options.

## Intro

[Docker :fontawesome-brands-docker:](https://docker.com){target="_blank"} is a widely used virtualization technology that makes it possible to pack an application with all its required resources into a standardized unit - the *Docker Container*. Software encapsulated in this way can run on Linux, Windows, macOS and most cloud services without any further changes or setup process. Docker containers are lightweight compared to traditional virtualization environments that emulate an entire operating system, because they contain only the application and all the tools, program libraries, and files it requires.

Docker enables you to get a 3DCityDB instance up and running in a fews seconds, without having to setup a database server or the 3DCityDB database schema, as shown below.

![Docker example](assets/citydb_docker_term.gif)
/// figure-caption
Setup a 3DCityDB instance using Docker and establish a connection to the ready-to-use 3DCityDB in seconds.
///

## Docker images overview

Docker images are available for the following tools of the 3DCityDB software suite:

- [3D City Database](3dcitydb.md)
- [CityDB tool](../citydb-tool/general.md)
- [3DCityDB Importer/Exporter](https://3dcitydb-docs.readthedocs.io/en/latest/impexp/docker.html){target="_blank"}
- [3D Web Map Client](https://3dcitydb-docs.readthedocs.io/en/latest/webmap/docker.html){target="_blank"}
- [3DCityDB Web Feature Service (WFS)](https://3dcitydb-docs.readthedocs.io/en/latest/wfs/docker.html){target="_blank"}

!!! warning "Docker image compatibility"

     3DCityDB `v5` introduces a substantially changed database schema and a new set of tools. Currently, __only [CityDB tool](../citydb-tool/general.md)__ is compatible with `v5`.

    Usage of the 3DCityDB `v4` tools ([3DCityDB Importer/Exporter](https://3dcitydb-docs.readthedocs.io/en/latest/impexp/docker.html){target="_blank"}, [3D Web Map Client](https://3dcitydb-docs.readthedocs.io/en/latest/webmap/docker.html){target="_blank"}, [3DCityDB Web Feature Service (WFS)](https://3dcitydb-docs.readthedocs.io/en/latest/wfs/docker.html){target="_blank"}) is still possible by migration data to a `v4` 3DCityDB, as described [here](../3dcitydb/v4-migration.md).

All images are available from [DockerHub]{target="_blank"} or Github container registry ([ghcr.io]{target="_blank"}).

``` bash title="Pull docker images examples"
# 3DCityDB
docker pull 3dcitydb/3dcitydb-pg-v5
# or
docker pull ghcr.io/3dcitydb/3dcitydb-pg-v5

# CityDB tool
docker pull 3dcitydb/citydb-tool
# or
docker pull ghcr.io/3dcitydb/citydb-tool

```


## Quick start examples

The following sections provide *quick start* code snippets for all 3DCityDB Docker images to get you running in a few seconds. For a more comprehensive documentation please visit the individual chapters of each image.

### 3DCityDB Docker

To run a PostgreSQL/PostGIS 3DCityDB container the only required settings are a database password (`POSTGRES_PASSWORD`) and the EPSG code of the coordinate reference system (`SRID`) of the 3DCityDB instance. Use the `docker run -p` switch to define a port to expose to the host system for database connections. The detailed documentation for the 3DCityDB Docker image is available [here](../3dcitydb/docker.md).

``` shell
docker run -d -p 5432:5432 --name cdb \
  -e POSTGRES_PASSWORD=changeMe \
  -e SRID=25832 \
3dcitydb/3dcitydb-pg-v5 #(1)!
```

1. Replace the line continuation character `\` with `^` for Windows systems.

A container started with the command above will host a 3DCityDB instance
configured like this:

``` text
CONTAINER NAME    cdb
DB HOST           localhost or 127.0.0.1
DB PORT           5432
DB NAME           postgres
DB USER           postgres
DB PASSWD         changeMe
DB SRID           25832
DB GMLSRSNAME     urn:ogc:def:crs:EPSG::25832
```

### CityDB tool Docker

The Docker image exposes the commands of the [`citydb-tool`](../citydb-tool/general.md). The environment variables listed below allow to specify a 3DCityDB `v5` connection. To exchange data for import or export with the container, mount a host folder to `/data` inside the container.

``` bash
docker run --rm --name citydb-tool -i -t \
  -e CITYDB_HOST=the.host.de \
  -e CITYDB_NAME=theDBName \
  -e CITYDB_USERNAME=theUsername \
  -e CITYDB_PASSWORD=theSecretPass \
  -v /my/data/:/data \
3dcitydb/citydb-tool COMMAND # (1)!
```

1. The commands off `citydb-tool` are documented [here](../citydb-tool/general.md).

#### Show CLI documentation

Use the `help` command to see the CLI documentation and list all available commands:

``` bash
docker run -i -t --rm 3dcitydb/citydb-tool help
```

Run `help COMMAND` to see the CLI documentation for a specific command:

``` bash
docker run -i -t --rm 3dcitydb/citydb-tool help import
```

To see the usage description of a subcommand, use the `help` function of the top level command:

``` bash
docker run -i -t --rm 3dcitydb/citydb-tool import help citygml
```

#### Import CityGML data

Run the `import` command :material-database-import: to import a CityGML dataset located at `/local/data/dir/data.gml`.

``` bash
docker run -i -t --rm -u $(id -u):$(id -g) \
  --network host \
  -v ${PWD}:/data/ \
  -e CITYDB_HOST=localhost \
  -e CITYDB_NAME=postgres \
  -e CITYDB_USERNAME=postgres \
  -e CITYDB_PASSWORD=changeMe \
3dcitydb/citydb-tool import citygml "/data/*.gml"
```

#### Export CityGML data

Run the `export` command :material-database-export: to export a CityGML dataset to `/local/data/dir/export.gml`.

``` bash
docker run -i -t --rm -u $(id -u):$(id -g) \
  --network host \
  -v ${PWD}:/data/ \
  -e CITYDB_HOST=localhost \
  -e CITYDB_NAME=postgres \
  -e CITYDB_USERNAME=postgres \
  -e CITYDB_PASSWORD=changeMe \
3dcitydb/citydb-tool export citygml -o "/data/export.gml"
```

The exported file will be available on the host system at:
`/local/data/dir/export.gml`.

[Dockerhub]: https://hub.docker.com/u/3dcitydb
[ghcr.io]: https://github.com/orgs/3dcitydb/packages?ecosystem=container
