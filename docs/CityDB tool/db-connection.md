---
title: Database connection
subtitle: How to connect a 3DCityDB
description:
# icon: material/emoticon-happy
status: wip
---
## Connecting to a PostgreSQL Database

The CityDB tool requires a connection to a PostgreSQL database hosting the 3DCityDB schema. You can specify the database connection details using the database [options](#specifying-database-options-in-the-command) (refer to the [Export](export.md) or [Import](import.md) sections for more details) section or store them in an external [options file](#specifying-database-options-in-a-file) for reuse.
It is also possible to use a [config file](#specifying-database-options-in-a-config-file) in JSON format to specify the database connection options.

### Specifying Database Options in the Command

You can provide the database connection options directly in the command:


| Option                  | Description                                              |
|-------------------------|----------------------------------------------------------|
| `-H`, `--db-host=<host>` | Hostname of the 3DCityDB server.                         |
| `-P`, `--db-port=<port>` | Port of the 3DCityDB server (default: 5432).             |
| `-d`, `--db-name=<database>` | Name of the 3DCityDB database to connect to.         |
| `-S`, `--db-schema=<schema>` | Database schema to use (default: `citydb` or `username`). |
| `-u`, `--db-username=<user>` | Username for the database connection.                |
| `-p`, `--db-password[=<password>]` | Password for the database connection. Leave empty to be prompted. |

#### Example 

```bash
citydb export citygml -H localhost -P 5432 -d 3dcitydb -S citydb -u admin -p password -o output.gml
```

### Specifying Database Options in an options File

You can store the database connection options in a file and reference it in the command using the `@` symbol.  The file should contain the options in the format `--option=value` (one per line).

#### Example

```bash 
citydb export citygml @args.txt
```

Example of a Database Connection File:

```bash 
--db-host=localhost
--db-port=5432
--db-name=3dcitydb
--db-schema=citydb
--db-username=admin
--db-password=password
``` 

### Specifying Database Options in a config File

You can store the database connection options in a JSON file and reference it in the command using `--config-file=file.json`.

#### Example

```json 
{
  "databaseOptions": {
    "connections": {
      "defaultConnectionId": {
        "description": "Default database connection",
        "user": "user",
        "password": "password",
        "host": "localhost",
        "port": 5432,
        "database": "citydb",
        "srid": 4326
      }
    }
  }
}
```
