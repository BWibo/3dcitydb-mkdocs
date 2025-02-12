---
title: Compatibility and data migration
description: Which CitGML versions and tools are compatible
# icon: material/emoticon-happy
status: wip
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

CityGML 3.0 was officially released as a standard by the [Open Geospatial Consortium (OGC)](https://www.ogc.org/de/publications/standard/citygml/){target="blank"} in September 2021. CityGML 3.0 is an evolution of the previous versions 1.0 and 2.0 of CityGML. The latest version introduces significant modifications to the data model (see [here](https://www.asg.ed.tum.de/en/gis/projects/citygml-30/){target="blank"}), which led to the decision of a full re-implementation of 3D City Database (3DCityDB) and the toolset that comes with it. Compared to 3DCityDB `v4`, `v5` introduces a substantially simplified [database schema](./3dcitydb/relational-db-schema.md). 3DCityDB `v5` is the _only version_ supporting CityGML 3.0.

On this page you will find information on which versions of CityGML and its encodings are compatible to which 3DCityDB database versions and the tools you can use with each database version. A [compatibility overview](#compatibility-overview) is given in the table below. We also provide guidance on how to [migrate](#data-migration) between CityGML versions and 3DCityDB versions `v4` and `v5`.

!!! tip "Backward compatibility"
    All 3DCityDB versions and tools you might know from the past remain usable, even with CityGML 3.0 data. Depending on use-case and versions, data or database migration may be necessary.

    __Currently, only [citydb-tool](./citydb-tool/index.md) is compatible with 3DCityDB `v5`.__ However, the usage of 3DCityDB `v4` tools ([3DCityDB Importer/Exporter](https://3dcitydb-docs.readthedocs.io/en/latest/impexp/docker.html){target="blank"}, [3D Web Map Client](https://3dcitydb-docs.readthedocs.io/en/latest/webmap/docker.html){target="blank"}, [3DCityDB Web Feature Service (WFS)](https://3dcitydb-docs.readthedocs.io/en/latest/wfs/docker.html){target="blank"}) is still possible by migrating data to a 3DCityDB `v4`.


### Compatibility overview

The following table outlines the compatibility between __3DCityDB__ versions, __citydb-tool__ versions (including the legacy [3D CityDB Importer-Exporter](https://3dcitydb-docs.readthedocs.io/en/latest/impexp/index.html)), and the supported data formats and their versions.

| 3DCityDB version     | Tool version                   | Supported standards and encodings  | Supported standard/encodingersions                |
|----------------------|--------------------------------|------------------------------------|---------------------------------------------------|
| __5.x__              | __citydb-tool (current)__      | CityGML, CityJSON                  | CityGML: 3.0, 2.0, 1.0</br>CityJSON: 2.0, 1.1, 1.0|
| 4.x                  | 3DCityDB Importer-Exporter 3.x | CityGML, CityJSON                  | CityGML: 2.0, 1.0</br>CityJSON: 2.0, 1.1, 1.0     |
| 3.x                  | 3DCityDB Importer-Exporter 3.x | CityGML, CityJSON                  | CityGML: 2.0, 1.0</br>CityJSON: 1.0               |
| 2.x                  | 3DCityDB Importer-Exporter 2.x | CityGML                            | CityGML: 2.0, 1.0                                 |
| 1.x                  | 3DCityDB Importer-Exporter 1.x | CityGML                            | CityGML: 1.0                                      |

## Migrate CityGML data

To migrate CityGML data between versions and encodings we recommend using [3DCityDB `v5`](3dcitydb/index.md) and [citydb-tool](./citydb-tool/index.md).
The workflow is the same for all version upgrades and downgrades or encoding changes.

1. Create a 3DCityDB `v5` instance.
2. Import your CityGML or CityJSON encoded dataset.
3. Export your CityGML dataset in the desired encoding and version.

-v, --citygml-version=<version> 	Specify the CityGML version for the export: 3.0, 2.0, or 1.0. 	3.0
-v, --cityjson-version=<version> 	Specify the CityJSON version to use: 2.0, 1.1, or 1.0. 	2.0

## Migrate 3DCityDB versions

Workflow:

1. Export data in a version, that is supported by the target database version.
2. Create a 3DCityDB instance with the desired version.
3. Import the data from step 1. to the new instance from step 2..

### CityGML specific migration options

Due to changes

### CityGML `v3` to `v2`

### CityGML `v2` to `v3`

### 3DCityDB `v4` to `v5`

### 3DCityDB `v5` to `v4`







#### Import

## Upgrade options for CityGML 2.0 and 1.0

|OPTION / command | discription | default
|------------ | ------------- | -------------|
`--use-lod4-as-lod3` |  Use LoD4 as LoD3, replacing an existing LoD3.
`--map-lod0-roof-edge` |  Map LoD0 roof edges onto roof surfaces.
`--map-lod1-surface` | Map LoD1 multi-surfaces onto generic thematic surfaces.


#### Export

| `--use-lod4-as-lod3`                  | Replace existing **LoD3** geometries with **LoD4** geometries during the export.                     |               |
| `--map-lod0-roof-edge`                | Map **LoD0 roof edge lines** onto roof surfaces for better representation in the output.             |               |
| `--map-lod1-surface`                  | Map **LoD1 multi-surfaces** onto generic thematic surfaces to simplify LoD1 geometries.              |               |

Replace LoD3 with LoD4 Geometries

To replace existing LoD3 geometries with LoD4 geometries during the export:

citydb export citygml -o lod3_output.gml --use-lod4-as-lod3

Map LoD0 Roof Edges to Roof Surfaces

To include LoD0 roof edge lines as part of roof surfaces in the export:

citydb export citygml -o lod0_with_roofs.gml --map-lod0-roof-edge

Map LoD1 Multi-Surfaces to Generic Surfaces

To restructure LoD1 multi-surfaces into thematic surfaces for better alignment:

citydb export citygml -o lod1_mapped_output.gml --map-lod1-surface

This simplifies LoD1 geometries for tools that require a clearer surface structure



## dump


- Which version of our tools are compatible with CityGML `v2` and `v3`
- Which versions of our tools are compatible to each other
    - `v5`: 3DCityDB `v5` only compatible with `citydb-tool`
    - `v4`: 3DCityDB `v4` with `importer-exporter`, `web-map-client`, `wfs`
