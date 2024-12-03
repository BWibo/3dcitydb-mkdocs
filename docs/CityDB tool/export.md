---
title: Export
subtitle: Export
description:
# icon: material/emoticon-happy
status: wip
---

The Exporter is a command-line utility for exporting data from 3DCityDB in the CityGML format. It provides extensive options for controlling the export process, including filters, tiling, and data transformation.

## Usage

To invoke the exporter, use the following command:

```bash
citydb export citygml [OPTIONS]
```

### General Options

| Option                     | Description                                             |
|----------------------------|---------------------------------------------------------|
| `@<filename>...`           | Specify one or more argument files containing options.  |
| `-o`, `--output=<file>`    | Name of the output file.                                |
| `--output-encoding=<encoding>` | Specify the encoding for the output file.         |
| `--fail-fast`              | Stop execution immediately upon encountering an error. |
| `--temp-dir=<dir>`         | Directory for storing temporary files.                 |
| `--threads=<threads>`      | Number of threads for parallel processing.             |
| `--crs=<crs>`              | SRID or CRS identifier for geometry coordinates (default: storage CRS). |
| `--crs-name=<name>`        | CRS name to use in the output file.                    |
| `--no-appearances`         | Exclude appearances from the export.                   |
| `-v`, `--citygml-version=<version>` | Specify CityGML version (3.0, 2.0, 1.0; default: 3.0). |
| `--[no-]pretty-print`      | Format and indent the output file (default: true).     |
| `-x`, `--xsl-transform=<stylesheet>` | Apply XSLT stylesheets for output transformation. |
| `-h`, `--help`             | Display help information and exit.                     |
| `-V`, `--version`          | Show version information and exit.                     |
| `--config-file=<file>`     | Load configuration from the specified file.            |
| `-L`, `--log-level=<level>` | Log level (fatal, error, warn, info, debug, trace; default: info). |
| `--log-file=<file>`        | Write log messages to the specified file.              |
| `--pid-file=<file>`        | Create a process ID file.                               |
| `--plugins=<dir>`          | Load plugins from the specified directory.             |
| `--use-plugins=<plugin>`   | Enable/disable plugins by their fully qualified class names. Default: true. |

#### Examples

Basic example:
```bash
citydb export citygml -o output.gml
```

Example with options stored in a file:
```bash
citydb export citygml -o output.gml @args.txt
```

### Database Connection Options

| Option                  | Description                                              |
|-------------------------|----------------------------------------------------------|
| `-H`, `--db-host=<host>` | Hostname of the 3DCityDB server.                         |
| `-P`, `--db-port=<port>` | Port of the 3DCityDB server (default: 5432).             |
| `-d`, `--db-name=<database>` | Name of the 3DCityDB database to connect to.         |
| `-S`, `--db-schema=<schema>` | Database schema to use (default: `citydb` or `username`). |
| `-u`, `--db-username=<user>` | Username for the database connection.                |
| `-p`, `--db-password[=<password>]` | Password for the database connection. Leave empty to be prompted. |

#### Example

Connect to a database and export:
```bash
citydb export citygml -H localhost -P 5432 -d my_citydb -u admin -p secret -o db_output.gml
```

### Query and Filter Options

| Option                      | Description                                           |
|-----------------------------|-------------------------------------------------------|
| `-t`, `--type-name=<name>`  | Specify feature names to process. Example: `--type-name=CityFurniture`. |
| `-f`, `--filter=<cql2-text>`| Apply a CQL2 filter to retrieve features.             |
| `--filter-crs=<crs>`        | CRS for geometries in the filter expression.          |
| `--sql-filter=<sql>`        | Use an SQL query as a filter.                         |
| `-s`, `--sort-by=<property>`| Sort features by specified properties.                |
| `--limit=<count>`           | Limit the number of features processed. Example: `--limit=5`. |
| `--start-index=<index>`     | Start processing features from the specified index.   |
| `-l`, `--lod=<lod>`         | Export geometries with a specified LoD.              |
| `--lod-mode=<mode>`         | LoD filter mode: `or`, `and`, `minimum`, `maximum` (default: `or`). |
| `--lod-search-depth=<depth>`| Levels of sub-features to search for matching LoDs (default: 0). |
| `-a`, `--appearance-theme=<theme>` | Export appearances with a matching theme. Use `none` for null themes. |

#### Examples

Export specific features:
```bash
citydb export citygml -t "CityFurniture" -o filtered_output.gml
```

Export with limited output:
```bash
citydb export citygml --limit=5 -o filtered_output.gml
```

### Tiling Options

| Option                          | Description                                           |
|---------------------------------|-------------------------------------------------------|
| `--tile-matrix=<columns,rows>`  | Export tiles in a specified grid (e.g., columns x rows). |
| `--tile-dimension=<width,height>` | Export tiles with defined dimensions in the database CRS grid. |
| `--tile-extent=<extent>`        | Define the tiling extent (e.g., `x_min,y_min,x_max,y_max[,srid]`). |
| `--tile-origin=<origin>`        | Origin for tile indexes: `top_left`, `bottom_left` (default: `top_left`). |

#### Examples

Export using a tile matrix:
```bash
citydb export citygml --tile-matrix=2,2 -o tiled_output.gml
```