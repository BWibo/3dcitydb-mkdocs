---
title: Import
subtitle: Import
description:
# icon: material/emoticon-happy
status: wip
---

The **import** command imports one or more CityGML or CityJSON files into the 3D City Database. 

Use `citydb import citygml [OPTIONS] <file>` to import one or more citygml files from a directory into the database.

The command provides a range of [OPTIONS] to adapt the import process.

OPTION / Command | discription
------------ | -------------
`--input-encoding= <encoding>` |  Encoding of input file(s).
`--fail-fast` | Fail fast on errors.
`--temp-dir= <dir>` | Store temporary files in this directory.
`--threads=<threads>`| Number of threads to use for parallel processing.
` --preview`| Run in preview mode. Features will not be imported.
`--index-mode=<mode>` | Index mode: keep, drop, drop_create (default: keep). Consider dropping indexes when processing large quantities of data.
`--compute-extent` | Compute and overwrite extents of features.
` --import-xal-source` | Import XML snippets of xAL address elements.
`--log-file=<file>`| Write log messages to this file.
`--pid-file=<file>` | Create a file containing the process ID.
`--plugins=<dir>` | Load plugins from this directory.
`--use-plugins=<plugin[=true|false][,<plugin[=true|false]...]` | Enable or disable plugins with a matching fully qualified class name (default: true).
