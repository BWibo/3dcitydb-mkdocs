---
title: Compatibility and data migration
description: Which CitGML versions and tools are compatible
# icon: material/emoticon-happy
tags:
  - 3dcitydb
  - citydb-tool
  - importer-exporter
  - 3d-web-map-client
  - wfs
  - 3dcitydb v4
  - 3dcitydb v5
  - CityGML 1.0
  - CityGML 2.0
  - CityGML 3.0
  - CityJSON 1.0
  - CityJSON 2.0
  - data-migration
  - database-migration
  - legacy-support
---

CityGML 3.0 was officially released as a standard by the [Open Geospatial Consortium (OGC)](https://www.ogc.org/de/publications/standard/citygml/){target="blank"} in September 2021. CityGML 3.0 is an evolution of the previous versions 1.0 and 2.0 of CityGML. The latest version introduces significant modifications to the data model (see [here](https://www.asg.ed.tum.de/en/gis/projects/citygml-30/){target="blank"}), which led to the decision of a full re-implementation of 3D City Database (3DCityDB) and the toolset that comes with it. Compared to 3DCityDB `v4`, `v5` introduces a substantially simplified [database schema](./3dcitydb/relational-db-schema.md). CityGML 3.0 is currently only supported by 3DCityDB `v5`.

On this page you will find information on which versions of CityGML and its encodings are compatible to which 3DCityDB database versions and the tools you can use with each database version. A [compatibility overview](#compatibility-overview) is given in the table below. We also provide guidance on how to migrate between [CityGML versions](#migrate-citygml-or-cityjson-data) and [3DCityDB versions](#migrate-3dcitydb-versions) `v4` and `v5`.

!!! tip "Backward compatibility"
    All 3DCityDB versions and tools you might know from the past remain usable, even with CityGML 3.0 data. Depending on your use-case and versions, data and/or database migration may be necessary.

    __Currently, only [citydb-tool](./citydb-tool/index.md) is compatible with 3DCityDB `v5`.__ However, the usage of 3DCityDB `v4` tools ([3DCityDB Importer/Exporter](https://3dcitydb-docs.readthedocs.io/en/latest/impexp/docker.html){target="blank"}, [3D Web Map Client](https://3dcitydb-docs.readthedocs.io/en/latest/webmap/docker.html){target="blank"}, [3DCityDB Web Feature Service (WFS)](https://3dcitydb-docs.readthedocs.io/en/latest/wfs/docker.html){target="blank"}) is still possible by migrating data to a 3DCityDB `v4`.

### Compatibility overview

The following table outlines the compatibility between __3DCityDB__ versions, __citydb-tool__ versions (including the legacy [3D CityDB Importer-Exporter](https://3dcitydb-docs.readthedocs.io/en/latest/impexp/index.html)), and the supported data formats and their versions.

| 3DCityDB version     | Tool version                   | Supported standards and encodings  | Supported standard/encoding versions               |
|----------------------|--------------------------------|------------------------------------|----------------------------------------------------|
| __5.x__              | __citydb-tool (current)__      | CityGML, CityJSON                  | CityGML: 3.0, 2.0, 1.0</br>CityJSON: 2.0, 1.1, 1.0 |
| 4.x                  | 3DCityDB Importer-Exporter 3.x | CityGML, CityJSON                  | CityGML: 2.0, 1.0</br>CityJSON: 2.0, 1.1, 1.0      |
| 3.x                  | 3DCityDB Importer-Exporter 3.x | CityGML, CityJSON                  | CityGML: 2.0, 1.0</br>CityJSON: 1.0                |
| 2.x                  | 3DCityDB Importer-Exporter 2.x | CityGML                            | CityGML: 2.0, 1.0                                  |
| 1.x                  | 3DCityDB Importer-Exporter 1.x | CityGML                            | CityGML: 1.0                                       |

## Migrate CityGML or CityJSON data

To migrate CityGML data between versions and encodings we recommend using [3DCityDB `v5`](3dcitydb/index.md) and [citydb-tool](./citydb-tool/index.md).
The workflow is the same for all version up- or downgrades, or encoding changes.

1. Create a 3DCityDB `v5` instance.
2. Import your CityGML or CityJSON encoded dataset.
3. Export your CityGML dataset in the desired encoding and version.

For both CityGML and CityJSON encoding the citydb-tool `-v` option can be used to specify the desired export version.

| Encoding            | Option                              | Description                                                     | Default |
|---------------------|-------------------------------------|-----------------------------------------------------------------|---------|
| CityGML</br>`xml`   | `-v`, `--citygml-version=<version>` | Specify the CityGML version for the export: 3.0, 2.0, or 1.0.   | 3.0     |
| CityJSON</br>`json` | `-v`, `--cityjson-version=<version>`| Specify the CityJSON version to use: 2.0, 1.1, or 1.0.          | 2.0     |

### Handle CityGML data model differences

CityGML 3.0 introduces several far-reaching changes in the data model, that cannot be transferred one-to-one between versions `2.0` and `3.0`. Most important are:

- Buildings and interiors are now modeled using the new _Space_ concept (e.g. `BuildingRoom` for interiors).
- The LoD concept has been refined and standardized for different feature types.
- Interiors can be modeled independently of the LoDs. `LoD4` of CityGML `2.0` does no longer exist in version `3.0`.

To handle those modeling differences, there are three additional citydb-tool options for data import _and_ export of CityGML data:

- __Replace LoD3 with LoD4 Geometries:__ This replaces existing LoD3 geometries with LoD4 geometries.
- __Map LoD0 Roof Edges to Roof Surfaces:__ This includes LoD0 roof edge lines as part of roof surfaces.
- __Map LoD1 Multi-Surfaces to Generic Surfaces__ This simplifies LoD1 geometries for tools that require a clearer surface structure.

| Option                 | Description                                                                                                        | Default       |
|------------------------|--------------------------------------------------------------------------------------------------------------------|---------------|
| `--use-lod4-as-lod3`   | Replace existing __LoD3__ geometries with __LoD4__ geometries during the import/export.                            |               |
| `--map-lod0-roof-edge` | Map __LoD0 roof edge lines__ onto roof surfaces for better representation during the import/export.                |               |
| `--map-lod1-surface`   | Map __LoD1 multi-surfaces__ onto generic thematic surfaces to simplify LoD1 geometries during the import/export.   |               |

### Examples

Here are some example showing how to migrate data between CityGML versions. We use the [3DCityDB](3dcitydb/docker.md) and [citydb-tool](citydb-tool/docker.md) Docker images in the following examples. However, the migration can be done with [bare metal database](first-steps/setup.md) installations too. The only difference is the creation of the database in that case. For this example we use the test dataset available [here](citydb-tool/docker.md#data-preparation) and assume your data is located in the current working directory (`$PWD`).

    SRID        3068
    SRS_NAME    urn:ogc:def:crs,crs:EPSG::3068,crs:EPSG::5783

1. For all version up- or downgrades we first create a 3DCItyDB `v5` instance and a Docker network.

    === "Linux"

        ```bash
          # docker network remove citydb-net
          docker network create citydb-net

          # docker rm -f -v citydb
          docker run -t -d --name citydb \
            --network citydb-net \
            -e POSTGRES_PASSWORD=changeMe \
            -e SRID=3068 \
            -e SRS_NAME="urn:ogc:def:crs,crs:EPSG::3068,crs:EPSG::5783" \
          3dcitydb/3dcitydb:5-alpine
        ```

    === "Windows"

        ```bash
          # docker network remove citydb-net
          docker network create citydb-net

          # docker rm -f -v citydb
          docker run -t -d --name citydb ^
            --network citydb-net ^
            -e POSTGRES_PASSWORD=changeMe ^
            -e SRID=3068 ^
            -e SRS_NAME="urn:ogc:def:crs,crs:EPSG::3068,crs:EPSG::5783" ^
          3dcitydb/3dcitydb-pg-v5:edge-alpine
        ```

2. Import your dataset to the new database.

    === "Linux"

        ```bash
        docker run -i -t --rm --name citydb-tool \
          --network citydb-net \
          -v "$PWD:/data" \
        3dcitydb/citydb-tool:edge import citygml \
          -H citydb \
          -d postgres \
          -u postgres \
          -p changeMe \
          "Railway_Scene_LoD3.zip"
        ```

    === "Windows"

        ```bash
        docker run -i -t --rm --name citydb-tool ^
          --network citydb-net ^
          -v "$PWD:/data" ^
        3dcitydb/citydb-tool:edge import citygml ^
          -H citydb ^
          -d postgres ^
          -u postgres ^
          -p changeMe ^
          "Railway_Scene_LoD3.zip"
        ```

3. Export your dataset in the desired version. Use the `-v` option of citydb-tool (see above) to specify the version you want.
   Keep in mind to check if additional options for handling [CityGML `v2` vs. `v3` data model differences](#handle-citygml-data-model-differences) are required.

    === "Linux"

        ```bash hl_lines="10"
        docker run -i -t --rm --name citydb-tool \
          -u "$(id -u):$(id -g)" \
          --network citydb-net \
          -v "$PWD:/data" \
        3dcitydb/citydb-tool:edge export citygml \
          -H citydb \
          -d postgres \
          -u postgres \
          -p changeMe \
          -v "3.0" \
          -o "Railway_Scene_LoD3_CityGML_v3.gml"
        ```

    === "Windows"

        ```bash hl_lines="10"
        docker run -i -t --rm --name citydb-tool ^
          -u "$(id -u):$(id -g)" ^
          --network citydb-net ^
          -v "$PWD:/data" ^
        3dcitydb/citydb-tool:edge export citygml ^
          -H citydb ^
          -d postgres ^
          -u postgres ^
          -p changeMe ^
          -v "3.0" ^
          -o "Railway_Scene_LoD3_CityGML_v3.gml"
        ```

This is it! You have now migrated your CityGML dataset to the version you need.

## Migrate 3DCityDB versions

Migration between 3DCityDB `v5.x.x` and older versions is done by migrating data to a compatible CityGML version and re-importing the data to the target 3DCityDB version.

1. Check 3DCityDB and CityGML compatibility in the [table above](#compatibility-overview).
2. Migrate you dataset to a compatible CityGML version of your target database version, as described in [data migration above](#migrate-citygml-or-cityjson-data).
3. Create a 3DCityDB instance in your target version using [Docker](3dcitydb/docker.md) or [bare metal setup](first-steps/setup.md).
4. Import your dataset to the 3DCityDB with your target version. For 3DCityDB `v5.x.x` use [citydb-tool](citydb-tool/import_citygml.md), for older 3DCityDB versions use
   [3DCityDB Importer/Exporter](https://3dcitydb-docs.readthedocs.io/en/latest/impexp/index.html){target="blank"}.

[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2F3dcitydb.github.io%2F3dcitydb-mkdocs%2Fcompatibility%2F&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=Visitors&edge_flat=false)](https://hits.seeyoufarm.com/#history)

/// caption
///
