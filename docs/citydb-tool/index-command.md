---
title: Index command
description: Managing database indexes in 3DCityDB
tags:
  - citydb-tool
  - index
---

The `index` command allows managing indexes in the 3DCityDB `v5`. It provides [subcommands](#commands) for checking the
status of indexes, as well as for creating and dropping them.

Indexes improve query performance and enable faster data retrieval, both of which are especially important for large
databases. However, maintaining indexes comes with a cost, as they are updated in real time, potentially slowing down
processes such as data imports or deletions. The `index` command gives you control over handling the indexes.

## Usage

```bash
citydb index [OPTIONS] COMMAND
```

## Options

The `index` command inherits global options from the main [`citydb`](cli.md) command. Additionally, the `index create`
subcommand provides more options for creating indexes.

### Global options

--8<-- "docs/citydb-tool/includes/global-options.md"

For more details on the global options and usage hints, see [here](cli.md#options).

### Create index options

| Option                    | Description                                                                                            | Default value |
|---------------------------|--------------------------------------------------------------------------------------------------------|---------------|
| `-m, --index-mode=<mode>` | Index mode for property value columns: `partial`, `full`. Null values are not indexed in partial mode. | `partial`     |

The above options are only available for the `index create` command.

### Database connection options

--8<-- "docs/citydb-tool/includes/db-options.md"

For more details on the database connection options and usage hints, see [here](database.md#using-command-line-options).

## Commands

| Command                                     | Description                                                                                |
|---------------------------------------------|--------------------------------------------------------------------------------------------|
| [`help`](cli.md#help-and-cli-documentation) | [Display help information about the specified command.](cli.md#help-and-cli-documentation) |
| [`status`](#checking-index-status)          | [Show indexes with their status in the database.](#checking-index-status)                  |
| [`create`](#creating-indexes)               | [Create indexes on the database tables.](#creating-indexes)                                |
| [`drop`](#dropping-indexes)                 | [Drop indexes on the database tables.](#dropping-indexes)                                  |

## Usage

### Supported indexes

The `index` command operates on a subset of all indexes defined in the 3DCityDB `v5`. This subset includes the
most time-intensive spatial indexes and regular indexes on columns crucial for querying and filtering features.

The following indexes are supported by citydb-tool:

| Table           | Column(s)                            | Index type |
|-----------------|--------------------------------------|------------|
| `FEATURE`       | `identifier`, `identifier_codespace` | Regular    |
| `FEATURE`       | `envelope`                           | Spatial    |
| `FEATURE`       | `creation_date`                      | Regular    |
| `FEATURE`       | `valid_from`                         | Regular    |
| `FEATURE`       | `valid_to`                           | Regular    |
| `GEOMETRY_DATA` | `geometry`                           | Spatial    |
| `PROPERTY`      | `name`                               | Regular    |
| `PROPERTY`      | `namespace_id`                       | Regular    |
| `PROPERTY`      | `val_timestamp`                      | Regular    |
| `PROPERTY`      | `val_double`                         | Regular    |
| `PROPERTY`      | `val_int`                            | Regular    |
| `PROPERTY`      | `val_lod`                            | Regular    |
| `PROPERTY`      | `val_string`                         | Regular    |
| `PROPERTY`      | `val_uom`                            | Regular    |
| `PROPERTY`      | `val_uri`                            | Regular    |

### Checking index status

The `index status` command lists all supported indexes in the 3DCityDB `v5` with their current status, indicating whether
they are enabled (`on`) or dropped (`off`). Each index is listed with the name of the table and the column(s) for which it
is defined. This command helps you understand the current index situation and decide whether an index action is needed
to optimize subsequent database operations.

!!! note
    When setting up a new instance of the 3DCityDB v5, all indexes are enabled by default.

The following example demonstrates how to use the `index status` command, which then prints the index statuses to the
console.

=== "Linux"

    ```bash
    ./citydb index status \
        -H localhost \
        -d citdb \
        -u citydb_user \
        -p mySecret
    ```

=== "Windows CMD"

    ```bat
    citydb index status ^
        -H localhost ^
        -d citdb ^
        -u citydb_user ^
        -p mySecret
    ```

### Creating indexes

The `index create` command lets you create the predefined indexes supported by citydb-tool. These indexes are crucial
for optimizing query performance and enabling fast data retrieval, particularly in large databases. It is
recommended to create them before exporting data, especially if the export involves filtering features.

Since indexes on the `val_*` columns of the [`PROPERTY`](../3dcitydb/feature-module.md#property-table) table are often
sparsely populated with many `NULL` values, the `--index-mode` option offers the following modes for creating
indexes on property value columns:

- `partial`: Excludes `NULL` values from the indexes, resulting in smaller index sizes, faster creation and maintenance, and
  improved query performance. However, partial indexes cannot be used to search for `NULL` values. This is the default mode.
- `full`: Indexes all values, ensuring comprehensive coverage but potentially increasing storage requirements and the
  time needed for creation and maintenance.

The example below creates indexes on a 3DCityDB `v5` instance, using the `full` mode for property value columns.

=== "Linux"

    ```bash
    ./citydb index create \
        --index-mode=full
        -H localhost \
        -d citdb \
        -u citydb_user \
        -p mySecret
    ```

=== "Windows CMD"

    ```bat
    citydb index create ^
        --index-mode=full
        -H localhost ^
        -d citdb ^
        -u citydb_user ^
        -p mySecret
    ```

!!! warning
    Depending on the size of the database, the indexing process may take a significant amount of time, as it involves
    processing large amounts of data.

### Dropping indexes

The `index drop` command removes the predefined indexes supported by citydb-tool. Temporarily disabling indexes can
significantly speed up bulk data operations, such as large imports or deletions, by eliminating the overhead of updating
indexes. It can also be useful for database maintenance tasks, such as freeing up storage space.

Dropping indexes is simple, as shown in the example below.

=== "Linux"

    ```bash
    ./citydb index drop \
        -H localhost \
        -d citdb \
        -u citydb_user \
        -p mySecret
    ```

=== "Windows CMD"

    ```bat
    citydb index drop ^
        -H localhost ^
        -d citdb ^
        -u citydb_user ^
        -p mySecret
    ```

!!! warning
    While dropping indexes is a fast operation, re-creating them can be time-consuming, especially in large
    databases. As the database grows, the overhead of dropping and re-creating indexes may outweigh the benefits,
    particularly when dealing with smaller sets of features rather than bulk data operations.

!!! note
    Even after dropping indexes with the `index drop` command, a minimal set of indexes remains enabled to ensure
    that basic queries, such as filtering features by their `objectid` or `termination_date`, continue to perform efficiently.