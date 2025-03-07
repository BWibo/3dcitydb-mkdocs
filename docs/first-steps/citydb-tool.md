---
title: Using the citydb-tool
description: How to import and export CityGML data using citydb-tool
---

This guide provides a step-by-step example of how to import and export CityGML data using citydb-tool.

## Prerequisites

Before you begin, ensure you have the following:

- A running PostgreSQL database with the 3DCityDB schema installed (LINK DOCKER EXAMPLES, DOCKER)
- citydb-tool installed and configured.
- CityGML files to import.

## Step 1: Connecting to the database

First, configure the database connection. You can specify the connection details directly in the command or use an options file.

### Example: Command line

```bash
citydb import citygml \
  -H localhost -P 5432 -d 3dcitydb -S citydb -u admin -p password -o input.gml
```

### Example: Options file

Create a file named db_options.txt with the following content:

```bash
--db-host=localhost
--db-port=5432
--db-name=3dcitydb
--db-schema=citydb
--db-username=admin
--db-password=password
```

Then reference the file in the command:

```bash
citydb import citygml @db_options.txt -o input.gml
```

## Step 2: Importing CityGML data

Use the import command to import CityGML files into the 3D City Database.

### Example: Import command

```bash
citydb import citygml \
  -H localhost -P 5432 -d 3dcitydb -S citydb -u admin -p password input.gml
```

Or using the options file:

```bash
citydb import citygml @db_options.txt input.gml
```

## Step 3: Exporting CityGML data

After importing the data, you can export it back to CityGML format.

### Example: Export command

```bash
citydb export citygml \
  -H localhost -P 5432 -d 3dcitydb -S citydb -u admin -p password -o output.gml
```

Or using the options file:

```bash
citydb export citygml @db_options.txt -o output.gml
```

[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2F3dcitydb.github.io%2F3dcitydb-mkdocs%2Ffirst-steps%2Fcitydb-tool%2F&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=Visitors&edge_flat=false)](https://hits.seeyoufarm.com/#history)

/// caption
///
