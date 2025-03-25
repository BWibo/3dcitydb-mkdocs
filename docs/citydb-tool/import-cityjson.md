---
title: Import CityJSON command
description: Importing CityJSON data
# icon: material/emoticon-happy
tags:
  - citydb-tool
  - CityJSON
  - import
---

# Import CityJSON command

The `import cityjson` command imports one or more [CityJSON files](https://www.cityjson.org/) into the 3DCityDB `v5`.

## Synopsis

```bash
citydb import cityjson [OPTIONS] <file>...
```

## Options

The `import cityjson` command inherits global options from the main [`citydb`](cli.md) command and general import and
metadata options from its parent [`import`](import.md) command. Additionally, it provides CityJSON format-specific
import and filter options.

### Global options

--8<-- "docs/citydb-tool/includes/global-options.md"

For more details on the global options and usage hints, see [here](cli.md#options).

### General import options

--8<-- "docs/citydb-tool/includes/import-general-options.md"

For more details on the general import options and usage hints, see [here](import.md#usage).

### CityJSON import options

| Option                       | Description                                                             | Default value |
|------------------------------|-------------------------------------------------------------------------|---------------|
| `--[no-]map-unknown-objects` | Map city objects from unsupported extensions onto generic city objects. | `true`        |

### Metadata options

--8<-- "docs/citydb-tool/includes/import-metadata-options.md"

For more details on the metadata options and usage hints, see [here](import.md#metadata-options).

### Filter options

--8<-- "docs/citydb-tool/includes/import-filter-options.md"

### Database connection options

--8<-- "docs/citydb-tool/includes/db-options.md"

For more details on the database connection options and usage hints, see [here](database.md).

## Usage

!!! tip
    For general usage hints applicable to all subcommands of the `import` command (including but not limited to
    `import cityjson`), refer to the documentation for the `import` command [here](import.md#usage).

### Supported CityJSON versions

The `import cityjson` command supports importing CityJSON files in versions 2.0, 1.1, and 1.0. In addition to regular
CityJSON files, the [CityJSON Text Sequence (CityJSONSeq)](https://www.cityjson.org/cityjsonseq/) format is also
supported. CityJSONSeq decomposes the CityJSON dataset into its 1st-level features, which are stored as separate JSON
objects on individual lines, each delimited by newlines. This format enables efficient streaming of large CityJSON data.

The following file types and extensions are recognized by citydb-tool:

| File type            | File extensions |
|----------------------|-----------------|
| CityJSON file        | json, jsonl     |
| GZIP compressed file | gz, gzip        |
| ZIP archive          | zip             |

The file extensions are used when a directory or ZIP archive is provided as `<file>` input instead of a single file.
In such cases, the directory or archive is recursively scanned for input files, which are identified using the
extensions listed above and then processed for import.

### Filtering CityJSON content

The `import cityjson` command offers the same filtering options and capabilities as the `import citygml` command.
For more details, refer to the [corresponding section](import-citygml.md#filtering-citygml-content) of that command.

- [Feature type filter](import-citygml.md#feature-type-filter) (`--type-name`): Filters features by their feature type.
- [Feature identifier filter](import-citygml.md#feature-identifier-filter) (`--id`): Filters features by their
  identifier. The filter behavior depends on the CityJSON file format:
    - **Regular CityJSON**: Only features with a matching `key` in `"CityObjects"` are imported.
    - **CityJSONSeq:** Only `"CityJSONFeature"` objects with a matching `"id"` property are imported.
- [Bounding box filter](import-citygml.md#bounding-box-filter) (`--bbox`, `--bbox-mode`): Filters features using a 2D bounding box based on
  their `"geographicalExtent"` property.
- [Count filter](import-citygml.md#count-filter) (`--limit`, `--start-index`): Limits the number of imported features.
- [Appearance filter](import-citygml.md#appearance-filter) (`--appearance-theme`, `--no-appearances`): Controls
  the import of appearances.

The following example illustrates an `import cityjson` command with multiple filters:

=== "Linux"

    ```bash
    ./citydb import cityjson [...] my-city.json \
        --type-name=bldg:Building,tran:Road \
        --bbox=367123,5807268,367817,5807913,25833 \
        --bbox-mode=on_tile \
        --no-appearances \
        --limit=100
    ```

=== "Windows CMD"

    ```bat
    citydb import cityjson [...] my-city.json ^
        --type-name=bldg:Building,tran:Road ^
        --bbox=367123,5807268,367817,5807913,25833 ^
        --bbox-mode=on_tile ^
        --no-appearances ^
        --limit=100
    ```

!!! note
    - If multiple filters are used, all conditions must be satisfied for a feature to be imported.
    - Filters are applied to the 1st-level city objects in the input file. Matching city objects are imported, including all
      their 2nd-level city objects. Filtering 2nd-level city objects is not supported.

### Handling unknown extensions

CityJSON provides a flexible extension mechanism similar to CityGML Application Domain Extensions (ADE). This mechanism
allows the addition of new feature attributes and feature types not covered by the CityJSON specification. If a dataset
contains extensions that are not registered in the 3DCityDB `v5`, citydb-tool handles them as follows:

- Unknown attributes are mapped to generic attributes and stored in the database.
- Unknown feature types are mapped to generic city objects in the database. This default behavior can be
  suppressed using the -`-no-map-unknown-objects` option, which will prevent unknown feature types from being imported.

!!! tip
    To import CityJSON extensions as defined, the corresponding type definitions have to be registered in the
    [`OBJECTCLASS`](../3dcitydb/metadata-module.md#objectclass-table) and
    [`DATATYPE`](../3dcitydb/metadata-module.md#datatype-table) metadata tables of the 3DCityDB `v5`. Additionally, a
    corresponding extension module must be loaded for citydb-tool to correctly parse and import the extensions.

[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2F3dcitydb.github.io%2F3dcitydb-mkdocs%2Fcitydb-tool%2Fimport_cityjson%2F&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=Visitors&edge_flat=false)](https://hits.seeyoufarm.com/#history)

/// caption
///
