---
title: Migration from previous versions
description:
# icon: material/emoticon-happy
tags:
  - migration
---

The 3D City Database `v5` is a major revision of the previous version `v4`. The database schema has been
completely redesigned and significantly simplified compared to `v4` to support CityGML 3.0, alongside
CityGML 2.0 and 1.0. As a result, there is currently no tool available to automatically upgrade a
3DCityDB `v4` instance to version `v5` at the database level and migrate the data in one step.

The **recommended migration process** for an existing 3DCityDB `v4` is:

1. Export all data from the 3DCityDB `v4` as CityGML 2.0 using
   [Importer/Exporter](https://3dcitydb-docs.readthedocs.io/en/latest/impexp/docker.html){target="blank"} tool.
2. Set up a new 3DCityDB `v5` instance (see [3DCitydb setup guide](setup.md)).
3. Re-import the data into the 3DCityDB `v5` instance using `citydb-tool`.

!!! tip
    Check out the :simple-rocket: [compatibility and data migration](../compatibility.md) :simple-rocket: guide to
    learn more about:

    - Compatibility between CityGML, 3DCityDB and tool versions
    - Migrating from previous 3DCityDB releases
    - Migrating between CityGML versions
    - Migrating between 3DCityDB versions

[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2F3dcitydb.github.io%2F3dcitydb-mkdocs%2Ffirst-steps%2Fmigration%2F&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=Visitors&edge_flat=false)](https://hits.seeyoufarm.com/#history)

/// caption
///
