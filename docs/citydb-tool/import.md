---
title: Import command
description: Overview of the import command
tags:
  - citydb-tool
  - import
---

# Import command

The `import` command imports city model data into the 3DCityDB `v5` in a supported format. Each format has a dedicated
[subcommand](#commands) with format-specific options.

## Synopsis

```bash
citydb import [OPTIONS] COMMAND
```

## Options

The `import` command inherits global options from the main [`citydb`](cli.md) command. Additionally, it defines general
import and metadata options, which apply to all of its [subcommands](#commands).

### Global options

--8<-- "docs/citydb-tool/includes/global-options.md"

For more details on the global options and usage hints, see [here](cli.md#options).

### General import options

--8<-- "docs/citydb-tool/includes/import-general-options.md"

### Metadata options

--8<-- "docs/citydb-tool/includes/import-metadata-options.md"

## Commands

| Command                                     | Description                                                                                |
|---------------------------------------------|--------------------------------------------------------------------------------------------|
| [`help`](cli.md#help-and-cli-documentation) | [Display help information about the specified command.](cli.md#help-and-cli-documentation) |
| [`citygml`](import-citygml.md)              | [Import data in CityGML format.](import-citygml.md)                                        |
| [`cityjson`](import-cityjson.md)            | [Import data in CityJSON format.](import-cityjson.md)                                      |

!!! note
    Additional subcommands to support more formats may be added in future versions. You can also implement your own
    [plugin](cli.md#plugins) to add support for a specific format. Contributions are welcome.

## Usage

### Specifying import files

The input for import is specified using one or more `<file>` arguments, each of which can point to either a file
or a directory. You can also use glob patterns with wildcard characters such as `*`, `?`, `[ ]`, or `{ }` to match multiple
files.

If a directory is provided, it will be scanned recursively for supported input files. The supported file formats and
extensions depend on the [subcommand](#commands). In addition to regular files, ZIP archives and GZIP-compressed files are
supported as input. Like directories, ZIP archives are also scanned recursively for supported input files.
The following example shows different ways for defining input files.

=== "Linux"

    ```bash
    ./citydb import citygml [...] \
        /path/to/my-city.gml \
        /foo/ \
        /bar/**/city*.{gml,gz,zip}
    ```

=== "Windows CMD"

    ```bat
    citydb import citygml [...] ^
        C:\path\to\my-city.gml ^
        C:\foo\ ^
        C:\bar\**\city*.{gml,gz,zip}
    ```

To enforce a specific encoding for the input files, provide the IANA-based encoding name (e.g., `UTF-8`) with the
`--input-encoding` option. This encoding will be applied to all input files.

### Import modes and duplicate features

The import mode defined by the `--import-mode` option determines how duplicate features are handled in the database.
The available modes are:

- `import_all`: All features from the input files are imported, even if duplicates are created. This is the default mode.
- `skip`: Features already in the database take precedence. If a duplicate is found, the feature from the input file is
  ignored and not imported.
- `delete`: Features from the input files take precedence. If a duplicate is found, the existing feature in the database
  is deleted before the new feature is imported.
- `terminate`: Similar to `delete`, but the duplicate feature in the database is terminated rather than deleted (for
  the difference, see the [`delete`](delete.md) command).

!!! note
    - Duplicates are identified by comparing the `objectid` column in the [`FEATURE`](../3dcitydb/feature-module.md#feature-table)
      with the feature identifier from the input file (e.g., `gml:id`
      for CityGML files). No additional checks are applied for identifying duplicates.
    - Terminated features are excluded from the duplicates check.

### Previewing the import

The `--preview` option runs the import in preview mode. The input data is processed as if the import were taking place, but
no changes are made to the database. This mode helps identify potential issues, such as conflicts or errors, before they
affect the database and ensures the actual import proceeds as expected.

### Managing indexes during import

When importing data, database indexes are updated in real time, which can slow down the import process, especially 
with large datasets. The `--index-mode` option offers the following modes for handling indexes during the import
operation:

- `keep`: The indexes remain unchanged. This is the default mode.
- `drop`: The indexes are removed before the import starts, improving import performance.
- `drop_create`: Similar to `drop`, but the indexes are re-created after the import completes, ensuring they are
  available for subsequent queries.

!!! note
    Dropping and re-creating indexes can also take a significant amount of time, depending on the size of the database. This
    mode is beneficial when importing large datasets, such as during the initial loading of the database. However, as
    the database grows, the overhead of dropping and re-creating indexes may outweigh the benefits, especially when
    importing smaller datasets.

!!! tip
    The [`index`](index.md) command allows you to manage indexes independently of the import operation, giving you
    greater control over index handling.

### Computing feature extents

By default, citydb-tool reads feature bounding boxes from the input file and stores them in the `envelope` column of the
[`FEATURE`](../3dcitydb/feature-module.md#feature-table) table. A correct envelope is essential for spatial queries.
With the `--compute-extent` option, citydb-tool computes envelopes instead of using those from the input file. The
computation considers the geometries of each feature and its subfeatures across all LoDs.

!!! tip
    You can also recompute envelopes after import using database functions in the 3DCityDB `v5`, as explained [here](../3dcitydb/db-functions.md#envelope-functions).

### Transforming feature geometries

The `--transform` option applies an affine transformation to input geometries using a 3x4 transformation matrix
before they are imported into the database. The matrix operates on homogeneous coordinates to compute the transformed
coordinates $(x', y', z')$:

$$
\begin{pmatrix}
x' \\ y' \\ z'
\end{pmatrix}
=
\begin{pmatrix}
m_0 & m_1 & m_2 & m_3 \\ m_4 & m_5 & m_6 & m_7 \\ m_8 & m_9 & m_{10} & m_{11}
\end{pmatrix}
\cdot
\begin{pmatrix}
x \\ y \\ z \\ 1
\end{pmatrix}
$$

The `--transform` option expects a comma-separated list of 12 matrix coefficients in row-major order, from $m_0$
to $m_{11}$:

```shell
--transform=m0,m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11
```

A common use case is swapping the $x$ and $y$ coordinates while keeping $z$ unchanged. This can be achieved with the
following matrix:

$$
\begin{pmatrix}
0 & 1 & 0 & 0 \\ 1 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0
\end{pmatrix}
\quad \Rightarrow \quad
[0,1,0,0,1,0,0,0,0,0,1,0]
$$

Alternatively, you can use `swap_xy` as a shorthand for this transformation, as shown below.

=== "Linux"

    ```bash
    ./citydb import citygml [...] my-city.gml \
        --transform=swap_xy
    ```

=== "Windows CMD"

    ```bat
    citydb import citygml [...] my-city.gml ^
        --transform=swap_xy
    ```

!!! note
    Ensure that the transformed coordinates remain consistent with CRS defined for your 3DCityDB instance.

### Defining import metadata

The options `--lineage`, `--updating-person`, and `--reason-for-update` capture metadata about the feature’s origin, the
person responsible for the import, and the reasons for the import. This metadata is specific to 3DCityDB and is not
part of the CityGML standard (see also [here](../3dcitydb/feature-module.md#feature-table)). If not provided, the
username used to establish the 3DCityDB database connection will be used as the default value for `--updating-person`.

### Controlling the import process

The `import` command offers the following options to control the import process:

- `--fail-fast`: Terminates the process immediately upon encountering an error. By default, the import continues despite
  errors with individual features.
- `--temp-dir=<dir>`: Specifies the directory for storing temporary files during import. For optimal performance, choose
  a fast storage medium not used for reading the input files.
- `--threads=<threads>`: Sets the number of threads for parallel processing to improve performance. By default, it
  equals the number of processors available to the JVM, or at least two.

!!! note
    Setting the number of threads too high can lead to performance issues due to thrashing. Additionally, each thread
    requires a separate database connection, so ensure your database can handle the required number of connections.