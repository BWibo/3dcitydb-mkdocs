---
title: Import
subtitle: Import
description:
# icon: material/emoticon-happy
status: wip
---

The **import** command imports one or more CityGML or CityJSON files into the 3D City Database.

## Usage

To import your files to the 3D City Database it is necessary to give along the information for the connection. Look up [Database connection](db-connection.md) for further information.

Use `citydb import citygml [OPTIONS] <file>` to import one or more citygml files from a directory into the database.

The command provides a range of [OPTIONS] to adapt the import process.


# Options Table

## Import Data

OPTION / command | discription
------------ | -------------
`@<filename>...` | One or more argument files containing options.
`<file>...` | One or more files and directories to process (globpatterns allowed).
`--input-encoding= <encoding>` |  Encoding of input file(s).
`--fail-fast` | Fail fast on errors.
`--temp-dir= <dir>` | Store temporary files in this directory.
`--threads=<threads>`| Number of threads to use for parallel processing.
`--preview`| Run in preview mode. Features will not be imported.
`--index-mode=<mode>` | Index mode: keep, drop, drop_create (default: keep). Consider dropping indexes when processing large quantities of data.
`--compute-extent` | Compute and overwrite extents of features.
`--import-xal-source` | Import XML snippets of xAL address elements.
`--log-file=<file>`| Write log messages to this file.
`--pid-file=<file>` | Create a file containing the process ID.
`--plugins=<dir>` | Load plugins from this directory.
`--use-plugins=<plugin[=true|false][,<plugin[=true|false]...]` | Enable or disable plugins with a matching fully qualified class name (default: true).

## Upgrade options for CityGML 2.0 and 1.0
OPTION / command | discription | default
------------ | ------------- | ------------- 
`--use-lod4-as-lod3` |  Use LoD4 as LoD3, replacing an existing LoD3.
`--map-lod0-roof-edge` |  Map LoD0 roof edges onto roof surfaces.
`--map-lod1-surface` | Map LoD1 multi-surfaces onto generic thematic surfaces.

# Better Practice
You can use an textfile to combine and outsource commands and the link to the config.json to keep a better overwiew of issued commands. Save the textfile in the same folder as the config.json.

```bash
citydb import citygml <file> @options.txt
```
dhdghgdhgdhgd