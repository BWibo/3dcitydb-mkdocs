---
title: Import CityJSON command
description: Importing CityJSON data
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

For more details on the general import options and usage hints, see [here](import.md#general-import-options).

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

| File type            | File extensions    |
|----------------------|--------------------|
| CityJSON file        | `.json`, `.jsonl ` |
| GZIP compressed file | `.gz`, `.gzip`     |
| ZIP archive          | `.zip`             |

The file extensions are used when a directory or ZIP archive is provided as `<file>` input instead of a single file.
In such cases, the directory or archive is recursively scanned for input files, which are identified using the
extensions listed above and then processed for import.

### Filtering CityJSON content

The `import cityjson` command provides several filtering options to control which content is imported from the input
files.

#### Feature type filter

The `--type-name` option specifies one or more feature types to import. For each feature type, provide its type name as
defined in the [`OBJECTCLASS`](../3dcitydb/metadata-module.md#objectclass-table) table of the 3DCityDB `v5`. To avoid
ambiguity, you can use the namespace alias from the [`NAMESPACE`](../3dcitydb/metadata-module.md#namespace-table) table
as a prefix in the format `prefix:name`. Only features matching the specified type will be imported.

#### Feature identifier filter

The `--id` option enables filtering by one or more feature identifiers provided as a comma-separated list.  The filter
behavior depends on the CityJSON file format:

- **Regular CityJSON**: Only features with a matching `key` in `"CityObjects"` are imported.
- **CityJSONSeq:** Only `"CityJSONFeature"` objects with a matching `"id"` property are imported.

#### Bounding box filter

The `--bbox` option defines a 2D bounding box as a spatial filter using four coordinates for the lower-left and
upper-right corners. By default, the coordinates are assumed to be in the same CRS as the 3DCityDB instance. However,
you can specify the database SRID of the CRS as a fifth value (e.g., `4326` for WGS84). All values must be separated by
commas.

The bounding box filter is applied to the  `"geographicalExtent"` property of input features. The filter behavior is controlled
by the `--bbox-mode` option:

- `intersects`: Only features whose bounding box overlaps with the filter bounding box will be imported. This is the
  default mode.
- `contains`: Only features whose bounding box is entirely within the filter bounding box will be imported.
- `on_tile`: Only features whose bounding box center lies within the filter bounding box or on its left/bottom
  boundary will be imported. This mode ensures that when multiple filter bounding boxes are organized in a tile grid,
  each feature matches exactly one tile.

#### Count filter

The `--limit` option sets the maximum number of features to import. The `--start-index` option
defines the `0`-based index of the first feature to import. These options apply across all input files and can be used
separately or together to control the total number of features imported.

#### Appearance filter

The `--appearance-theme` option filters appearances based on their `<theme>`. You can specify
one or more themes as a comma-separated list. To filter appearances that have no theme property, use `none` as the value.
Only appearances associated with the specified themes will be imported. To exclude all appearances from the import,
use the `--no-appearances` option.

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
    - [Configuration](cli.md#configuration-files) and [argument](cli.md#argument-files) files are an excellent way
      to store complex filter expressions and easily reuse them.

### Handling unknown extensions

CityJSON provides a flexible extension mechanism similar to CityGML Application Domain Extensions (ADE). This mechanism
allows the addition of new feature attributes and feature types not covered by the CityJSON specification. If a dataset
contains extensions that are not registered in the 3DCityDB `v5`, citydb-tool handles them as follows:

- Unknown attributes are mapped to generic attributes and stored in the database.
- Unknown feature types are mapped to generic city objects in the database. This default behavior can be
  suppressed using the `--no-map-unknown-objects` option, which will prevent unknown feature types from being imported.

!!! tip
    To import CityJSON extensions as defined, the corresponding type definitions have to be registered in the
    [`OBJECTCLASS`](../3dcitydb/metadata-module.md#objectclass-table) and
    [`DATATYPE`](../3dcitydb/metadata-module.md#datatype-table) metadata tables of the 3DCityDB `v5`. Additionally, a
    corresponding extension module must be loaded for citydb-tool to correctly parse and import the extensions.