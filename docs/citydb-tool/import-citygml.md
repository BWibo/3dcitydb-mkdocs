---
title: Import CityGML command
description: Importing CityGML data
# icon: material/emoticon-happy
tags:
  - citydb-tool
  - CityGML
  - import
---

# Import CityGML command

The `import citygml` command imports one or more [CityGML files](https://www.ogc.org/publications/standard/citygml/)
into the 3DCityDB `v5`.

## Synopsis

```bash
citydb import citygml [OPTIONS] <file>...
```

## Options

The `import citygml` command inherits global options from the main [`citydb`](cli.md) command and general import and
metadata options from its parent [`import`](import.md) command. Additionally, it provides CityGML format-specific import
and filter options.

### Global options

--8<-- "docs/citydb-tool/includes/global-options.md"

For more details on the global options and usage hints, see [here](cli.md#options).

### General import options

--8<-- "docs/citydb-tool/includes/import-general-options.md"

For more details on the general import options and usage hints, see [here](import.md#usage).

### CityGML import options

| Option                                                                       | Description                                  | Default value |
|------------------------------------------------------------------------------|----------------------------------------------|---------------|
| `--import-xal-source`                                                        | Import XML snippets of xAL address elements. |               |
| `-x`, <code>--xsl-transform=&lt;stylesheet><br/>[,&lt;stylesheet>...]</code> | Apply XSLT stylesheets to transform input.   |               |

### Metadata options

--8<-- "docs/citydb-tool/includes/import-metadata-options.md"

For more details on the metadata options and usage hints, see [here](import.md#metadata-options).

### Upgrade options for CityGML 2.0 and 1.0

| Option                 | Description                                             | Default value |
|------------------------|---------------------------------------------------------|---------------|
| `--use-lod4-as-lod3`   | Use LoD4 as LoD3, replacing an existing LoD3.           |               |
| `--map-lod0-roof-edge` | Map LoD0 roof edges onto roof surfaces.                 |               |
| `--map-lod1-surface`   | Map LoD1 multi-surfaces onto generic thematic surfaces. |               |

### Filter options

--8<-- "docs/citydb-tool/includes/import-filter-options.md"

### Database connection options

--8<-- "docs/citydb-tool/includes/db-options.md"

For more details on the database connection options and usage hints, see [here](database.md).

## Usage

!!! tip
    For general usage hints applicable to all subcommands of the `import` command (including but not limited to
    `import citygml`), refer to the documentation for the `import` command [here](import.md#usage).

### Supported CityGML versions

The `import citygml` command supports importing CityGML files in versions 3.0, 2.0, and 1.0. It recognizes the following
file types and extensions:

| File type            | File extensions |
|----------------------|-----------------|
| CityGML file         | `.gml`, `.xml`  |
| GZIP compressed file | `.gz`, `.gzip`  |
| ZIP archive          | `.zip`          |

The file extensions are used when a directory or ZIP archive is provided as `<file>` input instead of a single file.
In such cases, the directory or archive is recursively scanned for input files, which are identified using the
extensions listed above and then processed for import.

### Upgrading CityGML 2.0 and 1.0

CityGML data can be exported from the 3DCityDB `v5` in the same version as it was imported, without loss. However,
switching CityGML versions between import and export may result in data loss, as CityGML 3.0 is not fully backward
compatible with versions 2.0 and 1.0. While citydb-tool applies automatic conversions where possible, certain
scenarios require user input.

If CityGML 3.0 is the primary format for your 3DCityDB `v5` instance, the following upgrade options are
available for resolving compatibility issues:

- `--use-lod4-as-lod3`: Converts LoD4 geometries to LoD3, replacing any existing LoD3.
- `--map-lod0-roof-edge`: Converts LoD0 roof edge geometries into roof surface features.
- `--map-lod1-surface`: Converts LoD1 multi-surfaces into generic thematic surface features.

!!! note
    Upgrade options are not required if you only manage CityGML 2.0 and 1.0 data in your 3DCityDB `v5`.
    However, be cautious when importing CityGML 3.0 in such cases, as citydb-tool does not support downgrades.
    For more details, refer to the [compatibility and data migration](../compatibility.md) guide.

### Filtering CityGML content

The `import citygml` command provides several filtering options to control which content is imported from the input
files.

#### Feature type filter

The `--type-name` option specifies one or more feature types to import. For each feature type, provide its type name as
defined in the [`OBJECTCLASS`](../3dcitydb/metadata-module.md#objectclass-table) table of the 3DCityDB `v5`. To avoid
ambiguity, you can use the namespace alias from the [`NAMESPACE`](../3dcitydb/metadata-module.md#namespace-table) table
as a prefix in the format `prefix:name`. Only features matching the specified type will be imported.

#### Feature identifier filter

The `--id` option enables filtering by one or more feature identifiers provided as a comma-separated list. Only features
with a matching `gml:id` value will be imported.

#### Bounding box filter

The `--bbox` option defines a 2D bounding box as a spatial filter using four coordinates for the lower-left and
upper-right corners. By default, the coordinates are assumed to be in the same CRS as the 3DCityDB instance. However,
you can specify the database SRID of the CRS as a fifth value (e.g., `4326` for WGS84). All values must be separated by
commas.

The bounding box filter is applied to the `gml:boundedBy` property of input features. The filter behavior is controlled
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

#### Filter example

The following example illustrates an `import citygml` command with multiple filters:

=== "Linux"

    ```bash
    ./citydb import citygml [...] my-city.gml \
        --type-name=bldg:Building,tran:Road \
        --bbox=367123,5807268,367817,5807913,25833 \
        --bbox-mode=on_tile \
        --no-appearances \
        --limit=100
    ```

=== "Windows CMD"

    ```bat
    citydb import citygml [...] my-city.gml ^
        --type-name=bldg:Building,tran:Road ^
        --bbox=367123,5807268,367817,5807913,25833 ^
        --bbox-mode=on_tile ^
        --no-appearances ^
        --limit=100
    ```

!!! note
    - When using multiple filters, all conditions must be satisfied for a feature to be imported.
    - Filters are applied to the top-level `<cityObjectMember>` elements in the input file. Matching features
      are imported, including all their subfeatures. Filtering subfeatures is not supported.

### Applying XSL transformations

XSLT stylesheets enable the on-the-fly transformation of CityGML input data before it is imported into the database.
This allows you to modify or restructure the data to meet specific needs, such as changing values, filtering attributes,
or removing and replacing entire GML/XML structures.

The `--xsl-transform` option specifies one or more XSLT stylesheets to be applied to the input files. Each stylesheet must
be referenced by its filename and path, which can be either absolute or relative to the current directory. Multiple XSLT
stylesheets can be listed, separated by commas, to facilitate a multi-step transformation process. In this case, the
stylesheets are executed in the specified order, with the output of one stylesheet serving as the input for the next.

=== "Linux"

    ```bash
    ./citydb import citygml [...] my-city.gml \
        --xsl-transform=my-first-stylesheet.xsl,my-second-stylesheet.xsl
    ```

=== "Windows CMD"

    ```bat
    citydb import citygml [...] my-city.gml ^
        --xsl-transform=my-first-stylesheet.xsl,my-second-stylesheet.xsl
    ```

!!! note
    - To handle large input files, citydb-tool chunks each CityGML file into top-level features, which are then imported
      into the database. As a result, each XSLT stylesheet operates on individual top-level features, not the entire file.
      Keep this in mind when developing your XSLT.
    - The output of each XSLT stylesheet must be valid CityGML.

### Storing xAL address elements

CityGML uses the [OASIS Extensible Address Language (xAL)](https://docs.oasis-open.org/ciq/v3.0/specs/ciq-specs-v3.html)
standard to encode address data. During import, citydb-tool parses the xAL content and maps it to the separate columns
of the [`ADDRESS`](../3dcitydb/feature-module.md#address-table) table, which provides a comprehensive and flexible
structure for storing address data. However, if the original xAL address element is too complex to be fully mapped to
the `ADDRESS` table columns, the `--import-xal-source` option allows importing and retaining the original xAL element.
For more details, see [here](../3dcitydb/feature-module.md#address-table).