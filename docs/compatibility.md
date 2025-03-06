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

CityGML 3.0 was officially released as a standard by the [Open Geospatial Consortium (OGC)](https://www.ogc.org/de/publications/standard/citygml/){target="blank"} in
September 2021. CityGML 3.0 is an evolution of the previous versions 1.0 and 2.0 of CityGML. The latest version
introduces significant modifications to the data model (see [here](https://www.asg.ed.tum.de/en/gis/projects/citygml-30/){target="blank"}), which led to the decision
of a full re-implementation of 3D City Database (3DCityDB) and the toolset that comes with it. Compared to
3DCityDB `v4`, `v5` introduces a substantially simplified [database schema](./3dcitydb/relational-db-schema.md). CityGML 3.0 and its GML/CityJSON
encodings are only supported by 3DCityDB `v5`.

On this page you will find information on which versions of CityGML and its encodings are compatible to which
3DCityDB database versions and the tools you can use with each database version. A [compatibility overview](#compatibility-overview) is
given in the table below. We also provide guidance on how to migrate between [CityGML versions](#migrate-citygml-or-cityjson-data) and
[3DCityDB versions](#migrate-3dcitydb-versions) `v4` and `v5`.

!!! tip "Backwards compatibility"
    All past 3DCityDB versions and tools remain usable with the CityGML versions they support. However, to take
    advantage of CityGML 3.0 as well as the simplified database schema and new features of 3DCityDB `v5`, a database
    and/or data migration to the 3DCityDB `v5` is required.

    __Currently, only [citydb-tool](./citydb-tool/index.md) is compatible with 3DCityDB `v5`.__ If you want to
    use legacy 3DCityDB `v4` tools such as the [Importer/Exporter](https://3dcitydb-docs.readthedocs.io/en/latest/impexp/docker.html){target="blank"},
    the [3D Web Map Client](https://3dcitydb-docs.readthedocs.io/en/latest/webmap/docker.html){target="blank"}, or the
    [Web Feature Service (WFS)](https://3dcitydb-docs.readthedocs.io/en/latest/wfs/docker.html){target="blank"},
    your data must first be imported into a 3DCityDB `v4`.

## Compatibility overview

The following table outlines the compatibility between __3DCityDB__ versions, __citydb-tool__ versions
(including the legacy [Importer-Exporter](https://3dcitydb-docs.readthedocs.io/en/latest/impexp/index.html)), and the supported data formats and their versions. The 3DCityDB `v3`
is included for reference but should no longer be used in production.

| 3DCityDB version | Tool version                     | Supported standards and encodings | Supported standard/encoding versions                           |
|------------------|----------------------------------|-----------------------------------|----------------------------------------------------------------|
| __5.x__          | __citydb-tool 1.x__              | CityGML, CityJSON                 | CityGML: __3.0__, 2.0, 1.0</br>CityJSON: __2.0__, __1.1__, 1.0 |
| 4.x              | Importer-Exporter 5.x            | CityGML, CityJSON                 | CityGML: 2.0, 1.0</br>CityJSON: 1.0                            |
| 3.x              | Importer-Exporter 4.3 and higher | CityGML, CityJSON                 | CityGML: 2.0, 1.0</br>CityJSON: 1.0                            |

## CityGML and CityJSON support in 3DCityDB `v5`

The [3DCityDB `v5`](3dcitydb/index.md) supports __all versions of CityGML__. Although the database schema has been
designed with CityGML 3.0 in mind, 3DCityDB `v5` remains backwards compatible, with full support for the previous
versions 2.0 and 1.0 of CityGML. Data can be managed without loss in 3DCityDB `v5` as long as the same CityGML version
is used for both import and export. However, changing the CityGML version between import and export may result in
data loss, as CityGML 3.0 is not fully backwards compatible with CityGML 2.0/1.0.

For example, if you import CityGML 2.0 data into the 3DCityDB `v5`, you can be sure that the same data can be exported
back as CityGML 2.0. However, exporting to CityGML 3.0 might lead to data loss due to
data model differences and unsupported features between both CityGML versions. The [citydb-tool](./citydb-tool/index.md)
offers options to handle some of those differences on-the-fly (see [below](#handle-citygml-version-differences)).

The same applies to CityJSON: data can be managed without loss when the same CityJSON version is used for import
and export, but changing versions may lead to data loss.

## Migrate CityGML or CityJSON data

To migrate CityGML data between versions and encodings, we recommend using [3DCityDB `v5`](3dcitydb/index.md)
and [citydb-tool](./citydb-tool/index.md). The workflow is the same for all version up- or downgrades,
or encoding changes.

1. Create a 3DCityDB `v5` instance.
2. Import your CityGML or CityJSON encoded dataset.
3. Export your CityGML dataset in the desired encoding and version.

For both CityGML and CityJSON encoding, the citydb-tool `-v` option can be used to specify the desired target version
for the export.

| Encoding            | Option                               | Description                                                    | Default |
|---------------------|--------------------------------------|----------------------------------------------------------------|---------|
| CityGML</br>`xml`   | `-v`, `--citygml-version=<version>`  | Specify the CityGML version for the export: 3.0, 2.0, or 1.0.  | 3.0     |
| CityJSON</br>`json` | `-v`, `--cityjson-version=<version>` | Specify the CityJSON version for the export: 2.0, 1.1, or 1.0. | 2.0     |

### Handle CityGML version differences

CityGML 3.0 introduces several significant changes in the data model that cannot be transferred one-to-one between
versions 2.0/1.0 and 3.0. Most important are:

- CityGML 3.0 introduces many new feature types, data types, attributes, and concepts that are not available
  in previous versions. 
- The LoD concept has been refined and standardized for all feature types. Some of the specific LoDs and
  geometry representations in CityGML 2.0 are no longer present in version 3.0. 
- Interiors can be modeled independently of the LoDs. As a result, `LoD4` of CityGML 2.0 does no longer exists
  in version 3.0.

As mentioned above, these differences are only relevant when changing CityGML versions between import and
export. In such situations, citydb-tool applies automatic conversions to ensure no data loss, where possible. For cases
where automatic conversion is not possible, the following options are provided to help upgrade unsupported
CityGML 2.0 structures to valid representations in version 3.0. 

| Option                 | Description                                                                                       |
|------------------------|---------------------------------------------------------------------------------------------------|
| `--use-lod4-as-lod3`   | __LoD4__ geometries are mapped onto __LoD3__, replacing any existing LoD3 geometries in the data. |
| `--map-lod0-roof-edge` | __LoD0 roof edge geometries__ are mapped onto __roof surfaces__ with LoD0 surface geometry.       |
| `--map-lod1-surface`   | __LoD1 multi-surfaces__ are mapped onto __generic thematic surfaces__ with LoD1 surface geometry. |

!!! warning "No downgrade options"
    The citydb-tool does not offer similar options for downgrading CityGML 3.0 content to versions 2.0 or 1.0.
    Therefore, CityGML 3.0-only features, geometries, or attributes stored in the 3DCityDB `v5` will be lost
    when exporting to versions 2.0 or 1.0, unless an automatic conversion is possible.

!!! tip "When to use the upgrade options"
    The decision on whether and how to apply the upgrade options depends on which CityGML version is intended
    to be the leading one in your 3DCityDB `v5`.

    - __CityGML 2.0:__ Import CityGML 2.0/1.0 data as-is, without using the upgrade options. Importing CityGML 3.0
      data should be avoided if it contains features not avaialble in CityGML 2.0. The upgrade options can be used
      for data exports when the CityGML 3.0 format is explicitly requested or required.
    - __CityGML 3:0 (recommended):__ The upgrade options should be applied when importing CityGML 2.0/1.0 data,
      provided the data contains corresponding content. Exporting to CityGML 2.0/1.0 might lead to data loss.

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

2. Import your dataset to the new database. Keep in mind to check if additional options for handling
   [CityGML `v2` vs. `v3` data model differences](#handle-citygml-data-model-differences) are required.

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

## Migrate 3DCityDB database instances

Migration between 3DCityDB `v5` and older versions is done by migrating data to a compatible CityGML version and
re-importing the data to the target 3DCityDB version. The typical use case is upgrading an existing 3DCityDB
`v4` instance to `v5`.

1. Check 3DCityDB and CityGML compatibility in the [table above](#compatibility-overview).
2. Migrate you dataset to a compatible CityGML version of your target database version, as described in [data migration above](#migrate-citygml-or-cityjson-data).
3. Create a 3DCityDB instance in your target version using [Docker](3dcitydb/docker.md) or [bare metal setup](first-steps/setup.md).
4. Import your dataset to the 3DCityDB with your target version. For 3DCityDB `v5` use [citydb-tool](citydb-tool/import_citygml.md), for older
   3DCityDB versions use the [Importer/Exporter](https://3dcitydb-docs.readthedocs.io/en/latest/impexp/index.html){target="blank"}.

[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2F3dcitydb.github.io%2F3dcitydb-mkdocs%2Fcompatibility%2F&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=Visitors&edge_flat=false)](https://hits.seeyoufarm.com/#history)

/// caption
///
