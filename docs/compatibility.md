---
title: Compatibility and data migration
description: Which CitGML versions and tools are compatible
# icon: material/emoticon-happy
status: wip
tags:
  - 3dcitydb
  - v4
  - data-migration
  - legacy-support
---


- Which version of our tools are compatible with CityGML `v2` and `v3`
- Which versions of our tools are compatible to each other
    - `v5`: 3DCityDB `v5` only compatible with `citydb-tool`
    - `v4`: 3DCityDB `v4` with `importer-exporter`, `web-map-client`, `wfs`

## Compatibility CityGML versions and tools

3DCityDB `v5` introduces a substantially changed (simplified) [database schema](./3dcitydb/relational-db-schema.md), that requires a new set of tools. On this page you will find information on which versions of CityGML and CityJSON are [compatible](#overview) to which 3DCityDB database version and which tools can be applied.

!!! tip
    All 3DCityDB database version and tools you might know from the past remain usable. See [data migration](#data-migration) for migrations paths from/to `v4` and `v5` database and tools!

Currently, __only__ [citydb-tool](./citydb-tool/index.md) is compatible with 3DCityDB `v5`. However, the usage of 3DCityDB `v4` tools ([3DCityDB Importer/Exporter](https://3dcitydb-docs.readthedocs.io/en/latest/impexp/docker.html){target="blank"}, [3D Web Map Client](https://3dcitydb-docs.readthedocs.io/en/latest/webmap/docker.html){target="blank"}, [3DCityDB Web Feature Service (WFS)](https://3dcitydb-docs.readthedocs.io/en/latest/wfs/docker.html){target="blank"}) is still possible by migrating data to a 3DCityDB `v4`.

### Overview

The following table outlines the compatibility between __3DCityDB__ versions, __citydb-tool__ versions (including the legacy [3D CityDB Importer-Exporter](https://3dcitydb-docs.readthedocs.io/en/latest/impexp/index.html)), and the supported data formats and their versions.

| 3DCityDB version     | Tool version                   | Supported standards and formats    | Supported standard/format versions                |
|----------------------|--------------------------------|------------------------------------|---------------------------------------------------|
| __5.x__              | __citydb-tool (current)__      | CityGML, CityJSON                  | CityGML: 3.0, 2.0, 1.0<br>CityJSON: 2.0, 1.1, 1.0 |
| 4.x                  | 3DCityDB Importer-Exporter 3.x | CityGML, CityJSON                  | CityGML: 2.0, 1.0<br>CityJSON: 2.0, 1.1, 1.0      |
| 3.x                  | 3DCityDB Importer-Exporter 3.x | CityGML, CityJSON                  | CityGML: 2.0, 1.0<br>CityJSON: 1.0                |
| 2.x                  | 3DCityDB Importer-Exporter 2.x | CityGML                            | CityGML: 2.0, 1.0                                 |
| 1.x                  | 3DCityDB Importer-Exporter 1.x | CityGML                            | CityGML: 1.0                                      |

## Data migration

## CityGML `v3` to `v2`

## CityGML `v2` to `v3`

## 3DCityDB `v4` to `v5`

## 3DCityDB `v5` to `v4`
