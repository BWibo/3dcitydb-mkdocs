---
title: Downloads
description: Download 3DCityDB and citydb-tool
# icon: material/emoticon-happy
tags:
  - 3dcitydb
  - citydb-tool
  - download
---

The 3D City Database v5 consists of three software components, each of which is available for separate download:
__*3DCityDB scripts*__, __*citydb-tool*__, and __*3DCityDB-Web-Map-Client*__.

### 3DCityDB scripts

The 3DCityDB scripts package includes the shell/SQL scripts for setting up a 3DCityDB schema in a PostgreSQL/PostGIS database. 
You can download both the latest and previous versions from the [GitHub releases page](https://github.com/3dcitydb/citydb-tool/releases).
For detailed instructions on using the 3DCityDB scripts, please refer to the [Database Setup](first-steps/setup.md) section.

### citydb-tool

The citydb-tool is a Java-based command-line utility designed for managing and interacting with 3DCityDB efficiently.
You can download both the latest and previous versions from
the [GitHub releases page](https://github.com/3dcitydb/citydb-tool/releases).
Please refer to the [First Step](first-steps/setup.md) section for a quick start and check
the [respective page](citydb-tool/index.md) for detailed instructions.

__Please note__ that the citydb-tool package includes the corresponding version of the 3DCityDB scripts. If you have already
downloaded the citydb-tool, there is no need to download the 3DCityDB scripts separately.

### 3DCityDB-Web-Map-Client

The 3DCityDB Web Map Client is a web-based front-end designed for high-performance 3D visualization of geospatial data exported from 3DCityDB.
You can download both the latest and previous versions from
the [GitHub releases page](https://github.com/3dcitydb/3dcitydb-web-map/releases).

!!! note

    The citydb-tool currently does not support exporting geospatial data to KML/COLLADA or 3D Tiles formats, 
    which are required for visualization in the 3DCityDB Web Map Client. Therefore, please refer to the previous 
    [documentation](https://3dcitydb-docs.readthedocs.io/en/latest/webmap/index.html) for guidance on using the 
    3DCityDB Web Map Client with these formats.