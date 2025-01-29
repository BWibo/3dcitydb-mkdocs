---
title: CityDB tools
subtitle: Importing and Exporting CityGML
description:
# icon: material/emoticon-happy
status: wip
# tags:
#   - tag1
#   - tag2
---

This guide provides a step-by-step example of how to import and export CityGML data using the CityDB tool.

## Prerequisites

Before you begin, ensure you have the following:

- A running PostgreSQL database with the 3DCityDB schema installed.
- The CityDB tool installed and configured.
- CityGML files to import.

## Step 1: Connecting to the Database

First, configure the database connection. You can specify the connection details directly in the command or use an options file.

### Example: Command Line

```bash
citydb import citygml -H localhost -P 5432 -d 3dcitydb -S citydb -u admin -p password -o input.gml
```

### Example: Options File
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

## Step 2: Importing CityGML Data

Use the import command to import CityGML files into the 3D City Database.

### Example: Import Command

```bash
citydb import citygml -H localhost -P 5432 -d 3dcitydb -S citydb -u admin -p password input.gml
```

Or using the options file:

```bash
citydb import citygml @db_options.txt input.gml
```

## Step 3: Exporting CityGML Data

After importing the data, you can export it back to CityGML format.

### Example: Export Command

```bash
citydb export citygml -H localhost -P 5432 -d 3dcitydb -S citydb -u admin -p password -o output.gml
```

Or using the options file:

```bash
citydb export citygml @db_options.txt -o output.gml
```
