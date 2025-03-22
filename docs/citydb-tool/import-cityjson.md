---
title: Import CityJSON
description: Importing CityJSON data
# icon: material/emoticon-happy
tags:
  - citydb-tool
  - CityJSON
  - import
---

# CityJSON-specific import options

The __import__ command imports one or more CityJSON files into the 3D City Database.

To import your files to the 3D City Database it is necessary to give along the information for the connection. Look up [Database connection](database.md) for further information.

Use `citydb import cityjson [OPTIONS] <file>` to import one or more CityJSON files from a directory into the database.

!!! warning "Important"
    It is important that the filename + extension is mentioned in the path to the file itself.

The command provides a range of [OPTIONS] to adapt the import process.

## Best practice

You can use a textfile to combine and outsource commands and the link to the `config.json` to keep a better overview of issued commands. Save the textfile in the same folder as the config.json.

```bash
citydb import cityjson <file> @options.txt
```

## Options table

### Import data

| Command                        | Description                                                                                               | Default Value |
|:------------------------------ |:--------------------------------------------------------------------------------------------------------- |:------------- |
| `@<filename>...`               | One or more argument files containing options.                                                            |               |
| `<file>...`                    | One or more files and directories to process (globpatterns allowed).                                      |               |
| `--input-encoding= <encoding>` |  Encoding of input file(s).                                                                               |               |
| `--fail-fast`                  | Fail fast on errors.                                                                                      |               |
| `--temp-dir= <dir>`            | Store temporary files in this directory.                                                                  |               |
| `--threads=<threads>`          | Number of threads to use for parallel processing.                                                         |               |
| `--preview`                    | Run in preview mode. Features will not be imported.                                                       |               |
| `--index-mode=<mode>`          | Index mode: keep, drop, drop_create Consider dropping indexes when processing large quantities of data.   | keep          |
| `--compute-extent`             | Compute and overwrite extents of features.                                                                |               |
| `-[no-]map-unknown-objects`    |  Map city objects from unsupported extensions onto generic city objects.                                  | true          |
| `--log-file=<file>`            | Write log messages to this file.                                                                          |               |
| `--pid-file=<file>`            | Create a file containing the process ID.                                                                  |               |
| `--plugins=<dir>`              | Load plugins from this directory.                                                                         |               |
| `--use-plugins=<plugin[=true|false][,<plugin[=true|false]...]` | Enable or disable plugins with a matching fully qualified class name      | true          |

### Example

Running the import in a preview mode to check the metadata in the commandline.

```bash
citydb import citygml generic_cityjson.json --preview @options.txt
```

Import a CityJSON file and create file in a separate folder with log message

```bash
citydb import citygml generic_cityjson.json --log-file=log.txt @options.txt
```

## Handling with duplicate features

There are different options for the import to handle duplicates.

| Command                    | Description                                      | Default Value  |
|:---------------------------|:------------------------------------------------ |:---------------|
| `-m, --import-mode=<mode>` | Import mode: skip, terminate, delete, import_all | import_all     |

skip:material-arrow-right: Duplicates in the input file are not imported into the database.

terminate :material-arrow-right: Duplicates in the database are terminated before importing the input file.

delete :material-arrow-right: Duplicates in the database are deleted before importing the input file.

import_all :material-arrow-right: All features from the input file are imported without checking for duplicates.

### Example

If you want to check if the files are already imported to the database you can use the import-mode skip to check on it.

```bash
citydb import citygml generic_cityjson.json --import-mode=skip @options.txt
```

## Filter options

| Command                                                  | Description                                                                | Default Value         |
|:---------------------------------------------------------|:---------------------------------------------------------------------------|:----------------------|
| `-t`, `--type-name=<[prefix:]name>[,<[prefix:]name>...]` | Names of the features to process.                                          |                       |
| `-i`, `--id=<id>[,<id>...]`                              | Identifiers of the features to process.                                    |                       |
| `-b`, `--bbox=<x_min,y_min,x_max,y_max,srid>`            | Bounding box to use as spatial filter.                                     |                       |
| `--bbox-mode=<mode>`                                     | Bounding box mode: intersects, contains, on_tile  \| intersects            |                       |
| `--limit=<count>`                                        | Maximum number of features to process.                                     |                       |
| `-a`, `--appearance-theme=<theme>[,<theme>...]`          | Process appearances with a matching theme. Use 'none' for the null theme.  |                       |

### Example

Import a feature with a specific ID from your JSON-File.

```bash
citydb import citygml generic_cityjson.json \
  --id=GMLID_0598627_75956_700 @options.txt
```

[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2F3dcitydb.github.io%2F3dcitydb-mkdocs%2Fcitydb-tool%2Fimport_cityjson%2F&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=Visitors&edge_flat=false)](https://hits.seeyoufarm.com/#history)

/// caption
///
