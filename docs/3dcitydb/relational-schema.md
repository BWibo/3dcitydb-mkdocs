---
title: Relational schema overview
description: 3DCityDB v5 database schema
tags:
  - 3dcitydb
  - relational schema
---

The 3D City Database `v5` is a major revision of the previous `v4` release. The database schema has been
completely redesigned, significantly simplified, and restructured. Unlike `v4`, it no longer uses individual feature
tables with dedicated attribute columns. Instead, the schema is streamlined with fewer tables, including a single
`FEATURE` table for storing all features and objects, and a single `PROPERTY` table that holds most attributes and
associations. 

The following figure illustrates the complete 3DCityDB `v5` relational database schema.

![relational schema](assets/relational-schema.png)
/// figure-caption
Relation schema of the 3DCityDB `v5`.
///

All tables of the relation schema are logically grouped into five modules, which are discussed in the
following chapters:

- **Feature module**: Contains the core tables for storing feature information, excluding geometry and appearance data.
- **Geometry module**: Contains tables for storing both explicit and implicit geometry data.
- **Appearance module**: Contains tables for storing appearance information.
- **Metadata module**: Holds meta-information about features and their properties.
- **Codelist module]**: Stores codelists with their corresponding values.

!!! note
    Although conceptually the database model is applicable to any database system, this chapter uses
    PostgreSQL-specific figures and examples.

[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2F3dcitydb.github.io%2F3dcitydb-mkdocs%2F3dcitydb%2Frelational-db-schema%2F&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=Visitors&edge_flat=false)](https://hits.seeyoufarm.com/#history)

/// caption
///
