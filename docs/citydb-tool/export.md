---
title: Export command
description: Overview of the export command
tags:
  - citydb-tool
  - export
---

# Export command

The `export` command exports city model data from the 3DCityDB `v5` in a supported format. Each format has a dedicated
[subcommand](#commands) with format-specific options.

## Synopsis

```bash
citydb export [OPTIONS] COMMAND
```

## Options

The `export` command inherits global options from the main [`citydb`](cli.md) command. Additionally, it defines general
export, query and filter, feature history, and tiling options, which apply to all of its [subcommands](#commands).

### Global options

--8<-- "docs/citydb-tool/includes/global-options.md"

For more details on the global options and usage hints, see [here](cli.md#options).

### General export options

--8<-- "docs/citydb-tool/includes/export-general-options.md"

### Query and filter options

--8<-- "docs/citydb-tool/includes/export-filter-options.md"

### Time-based feature history options

--8<-- "docs/citydb-tool/includes/export-history-options.md"

### Tiling options

--8<-- "docs/citydb-tool/includes/export-tiling-options.md"

## Commands

| Command                                     | Description                                                                                |
|---------------------------------------------|--------------------------------------------------------------------------------------------|
| [`help`](cli.md#help-and-cli-documentation) | [Display help information about the specified command.](cli.md#help-and-cli-documentation) |
| [`citygml`](export-citygml.md)              | [Export data in CityGML format.](export-citygml.md)                                        |
| [`cityjson`](export-cityjson.md)            | [Export data in CityJSON format.](export-cityjson.md)                                      |

!!! note
    Additional subcommands to support more formats may be added in future versions. You can also implement your own
    [plugin](cli.md#plugins) to add support for a specific format. Contributions are welcome.

## Usage

### Specifying the output file

The output file for the export is specified using the `--output` option. Ensure the file extension matches the target
format. The export command also supports GZIP compression and ZIP archiving. To enable these, use the
corresponding file extensions listed below:

| File type            | File extensions          |
|----------------------|--------------------------|
| Regular file         | depends on target format |
| GZIP compressed file | `.gz`, `.gzip`           |
| ZIP archive          | `.zip`                   |

If the export includes texture files, a subfolder named `appearance` will be created relative to the output file, where
all textures will be stored. Likewise, a subfolder named `library-objects` will be created to store library objects
used by implicit geometries. When exporting as a ZIP archive, these folders are included within the archive.

### Querying and filtering

citydb-tool can export all features stored in 3DCityDB `v5` into a single output file. However, in most cases, only a
specific subset of features is needed. The `export` command provides various querying and filtering options to control
the content included in the export.

#### Feature type filter

The `--type-name` option specifies one or more feature types to export. For each feature type, provide its type name as
defined in the [`OBJECTCLASS`](../3dcitydb/metadata-module.md#objectclass-table) table of the 3DCityDB `v5`. To avoid
ambiguity, you can use the namespace alias from the [`NAMESPACE`](../3dcitydb/metadata-module.md#namespace-table) table
as a prefix in the format `prefix:name`. Only features matching the specified type will be exported.

#### CQL2-based filtering

citydb-tool supports the [OGC Common Query Language (CQL2)](https://www.ogc.org/publications/standard/cql2/){target="blank"} as the
default language for filtering features from the 3DCityDB `v5`. CQL2 filter expressions are passed to the `export`
command using the `--filter` option. Be sure to enclose them in quotes if needed. When applying
spatial filters, the filter geometries are assumed to be in the same CRS as the 3DCityDB instance. To specify a
different CRS, use the `--filter-crs` option and provide the SRID (e.g., `4326` for WGS84).

!!! tip
    - For more details on using CQL2 with the 3DCityDB `v5`, refer to the [CQL2 documentation](cql2.md).

The example below demonstrates how to filter buildings based on their `height` property.

=== "Linux"

    ```bash
    ./citydb export citygml [...] -o my-city.gml \
        --type-name=bldg:Building \
        --filter="con:height > 15"
    ```

=== "Windows CMD"

    ```bat
    citydb export citygml [...] -o my-city.gml ^
        --type-name=bldg:Building ^
        --filter="con:height > 15"
    ```

To apply a bounding box filter to the `envelope` property of features, you can use the following CQL2 filter expression.

=== "Linux"

    ```bash
    ./citydb export citygml [...] -o my-city.gml \
        --filter="s_intersects(core:envelope, bbox(13.369,52.506,13.405,52.520))" \
        --filter-crs=4326
    ```

=== "Windows CMD"

    ```bat
    citydb export citygml [...] -o my-city.gml ^
        --filter="s_intersects(core:envelope, bbox(13.369,52.506,13.405,52.520))" ^
        --filter-crs=4326
    ```


#### SQL-based filtering

The `--sql-filter` option allows the use of SQL `SELECT` statements as a filter expressions, providing access to
all details of the [relational schema](../3dcitydb/relational-schema.md). Any `SELECT` statement
supported by the underlying database system is permitted, as long as it returns only a list of `id` values from the
[FEATURE](../3dcitydb/feature-module.md#feature-table) table. Only features included in the returned list
will be considered for export.

Below is a simple example of filtering features based on their identifier in the `objectid` column of the `FEATURE`
table. The `SELECT` statement must be enclosed in quotes, and special characters may need to be escaped.

=== "Linux"

    ```bash
    ./citydb export citygml [...] -o my-city.gml \
        --sql-filter="SELECT id FROM feature WHERE objectid IN ('ABC', 'DEF')"
    ```

=== "Windows CMD"

    ```bat
    citydb export citygml [...] -o my-city.gml ^
        --sql-filter="SELECT id FROM feature WHERE objectid IN ('ABC', 'DEF')"
    ```

#### Count filter

The `--limit` option sets the maximum number of features to export. The `--start-index` option
defines the `0`-based index of the first feature within the result set to export. These options can be used
separately or together to control the total number of features exported.

#### LoD filter

The `export` command allows filtering geometries by Level-of-Detail (LoD) using the `--lod` option. You can specify
one or more LoD values as a comma-separated list. LoD values typically range from `[0..3]` or `[0..4]`,
depending on the CityGML version, but any string value is allowed.

- If a single LoD is provided, only geometries with that LoD will be included in the export. Features without a
  spatial representation for the requested LoD are not exported.
- If multiple LoDs are specified, only geometries with a matching LoD are retained, and the filtering behavior
  is controlled by the `--lod-mode` option:
    - `or`: Features with at least one matching LoD are exported. This is the default mode.
    - `and`: Only features with a spatial representation in all requested LoDs are exported.
    - `minimum`: Similar to `or`, but only the geometry with the lowest LoD is exported.
    - `maximum`: Similar to `or`, but only the geometry with the highest LoD is exported.

The `--lod-search-depth` option defines the number of subfeature levels to search for a matching LoD. With the default
`0`, only the feature and its boundary surfaces are considered. The LoD filter is satisfied if at least one
subfeature has a matching LoD representation.

The following command exports features represented in LoD2 or LoD3, retaining only their highest LoD.

=== "Linux"

    ```bash
    ./citydb export citygml [...] -o my-city.gml \
        --lod=2,3 \
        --lod-mode=maximum
    ```

=== "Windows CMD"

    ```bat
    citydb export citygml [...] -o my-city.gml ^
        --lod=2,3 ^
        --lod-mode=maximum
    ```

#### Appearance filter

The `--appearance-theme` option filters appearances based on their `<theme>`. You can specify
one or more themes as a comma-separated list. To filter appearances that have no theme property, use `none` as the value.
Only appearances associated with the specified themes will be exported. To exclude all appearances from the export,
use the `--no-appearances` option.

#### Sorting features by property

Along with filtering, the query options of the `export` command also allow sorting features by one or more properties,
which can be specified using the `--sort-by` option. Sorting by subfeature attributes is supported as well, by referencing
the attribute with the same JSON path notation used in CQL2 expressions (see [here](cql2.md)). Appending a `+` or `-` sign
to the property name defines the sort order: `+` for ascending (default), and `-` for descending.

The example below exports buildings, sorting them first by `height` in ascending order, and then by `objectId` in
descending order.

=== "Linux"

    ```bash
    ./citydb export citygml [...] -o my-city.gml \
        --type-name=bldg:Building
        --sort-by=con:height,core:objectId-
    ```

=== "Windows CMD"

    ```bat
    citydb export citygml [...] -o my-city.gml ^
        --type-name=bldg:Building
        --sort-by=con:height,core:objectId-
    ```

!!! tip
    - When using multiple filters, all conditions must be satisfied for a feature to be exported.
    - [Configuration](cli.md#configuration-files) and [argument](cli.md#argument-files) files are an excellent way
      to store complex filter expressions and easily reuse them.
    - When the `trace` log level is enabled, the final SQL `SELECT` statement generated from your query and filter options,
      which is used to query the 3DCityDB, will be printed to the console.

### Reprojecting geometries

The `export` command allows for the reprojecting of geometries to a different Coordinate Reference System (CRS) during
export. This is useful when the 3DCityDB `v5` instance is in one CRS, but the exported data needs to be in another.

To specify a different CRS for the export, use the `--crs` option followed by either the database SRID of the target CRS
or its identifier. citydb-tool supports both OGC-compliant names, such as `http://www.opengis.net/def/crs/EPSG/0/4326`,
and simpler formats like `EPSG:4326`.

Using the `--crs-name` option, you can specify the name or identifier of the target CRS to be included in the output
file (e.g., as the `srsName` attribute in CityGML files).

[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2F3dcitydb.github.io%2F3dcitydb-mkdocs%2Fcitydb-tool%2Fexport_shared_options%2F&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=Visitors&edge_flat=false)](https://hits.seeyoufarm.com/#history)

/// caption
///
