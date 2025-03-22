---
title: Database connection
description: Options for connection to a 3DCityDB
tags:
  - database
  - connection options
  - 3dcitydb
---

Most citydb-tool commands require a connection to a 3DCityDB `v5` instance. Connection details can be specified via
[command-line options](#using-command-line-options), an [argument file](#using-argument-files),
a [JSON configuration file](#using-configuration-files), or [environment variables](#using-environment-variables).


## Using command-line options

--8<-- "docs/citydb-tool/includes/db-options.md"

The `--db-host` option specifies the network name or IP address of the database server. The name of the 3DCityDB `v5`
instance must be provided via `--db-name`. The `--db-schema` option defines the database schema to connect to. For
PostgreSQL, the default schema is `citydb`, but additional schemas can be created using
the [database scripts](../first-steps/setup.md#shell-scripts) included in the 3DCityDB `v5` software package.

The username and password for connecting to the 3DCityDB are set with `--db-username` and `--db-password`. You can
provide the password directly or leave it empty to be prompted for input before connecting. The prompt will time out
after 60 seconds. If this option is omitted, citydb-tool will attempt to connect without a password.

In addition to the standard connection parameters, database-specific properties can be provided through the
`--db-property` option to configure the Java driver's behavior. These properties should be listed as a comma-separated
series of `key=value` pairs.

The example below shows how to use the database connection options. It includes the PostgreSQL-specific `ssl` parameter to
establish an SSL connection

=== "Linux"

    ```bash
    citydb export citygml \
        -H localhost \
        -d citdb \
        -u citydb_user \
        -p mySecret \
        --db-property=ssl=true \
        -o output.gml
    ```

=== "Windows"

    ```bat
    citydb export citygml ^
        -H localhost ^
        -d citdb ^
        -u citydb_user ^
        -p mySecret ^
        --db-property=ssl=true ^
        -o output.gml
    ```
!!! tip
    Consult the database documentation for an overview of supported JDBC connection properties. For PostgreSQL, further
    details can be found [here](https://jdbc.postgresql.org/documentation/use/#connection-parameters){target="blank"}.

## Using argument files

You can store the database connection options in an argument file and reference it in the command using the `@`
symbol. The contents of the argument file are automatically expanded into the argument list. For more information on
using argument files, refer to the section [here](cli.md#argument-files).

For example, suppose the following database options are stored in an `@-file` located at `/home/foo/db-args`:

```bash
--db-host=localhost
--db-port=5432
--db-name=citdb
--db-schema=citydb
--db-username=citydb_user
--db-password=mySecret
--db-property=ssl=true
```

This `@-file` can then be used as shown below.

```bash
citydb export citygml @/home/foo/db-args -o output.gml
```

!!! warning
    Storing passwords in an argument file in clear text may pose a security risk. Consider using an environment
    variable for the password instead, or leave the `--db-password` option empty to be prompted.

## Using configuration files

citydb-tool supports loading options and settings from a JSON-encoded configuration file, as described
[here](cli.md#configuration-files). The JSON structure for storing database connection options is illustrated below.

```json
{
  "databaseOptions": {
    "connections": {
      "myFirstConnection": {
        "host": "localhost",
        "port": 5432,
        "database": "citydb",
        "schema": "citydb",
        "user": "citydb_user",
        "password": "mySecret",
        "properties": {
          "ssl": true
        },
        "poolOptions": {
          "loginTimeout": 120
        }
      },
      "mySecondConnection": {
        "host": "the.host.de",
        "database": "3dcitydb",
        "user": "citydb_user",
        "password": "mySecret"
      }
    }
  },
  "defaultConnection": "myFirstConnection"
}
```

Database connection options are defined in the `"databaseOptions"` object within the configuration file. The `"connections"`
key contains one or more connection configurations, each identified by a unique, user-defined name. In the example
above, `myFirstConnection` and `mySecondConnection` define connections to different 3DCityDB `v5` instances with distinct
settings. The `"defaultConnection"` key specifies which connection to use. It can be omitted if only one connection
is defined.

Each connection can include the following properties, closely aligned with the corresponding command-line
options:

| Property        | Description                                                          | Default value        |
|-----------------|----------------------------------------------------------------------|----------------------|
| `"host"`        | Name of the host on which the 3DCityDB is running.                   |                      |
| `"port"`        | Port of the 3DCityDB server.                                         | 5432                 |
| `"database"`    | Name of the 3DCityDB database to connect to.                         |                      |
| `"schema"`      | Schema to use when connecting to the 3DCityDB                        | `citydb` or username |
| `"user"`        | Username to use when connecting to the 3DCityDB.                     |                      |
| `"password"`    | Password to use when connecting to the 3DCityDB                      |                      |
| `"properties"`  | Database-specific connection properties provided as key-value pairs. |                      |
| `"poolOptions"` | Connection pool options provided as key-value pairs.                 |                      |

The `"poolOptions"` property is available only in the JSON configuration and is not exposed as a command-line option. It
configures internal connection pool behavior. Currently, the only supported option is `"loginTimeout"`, which sets the
maximum time (in seconds) to wait for a connection attempt before timing out (default: `60` seconds). Additional pool
options may be added in future versions.

You can use a configuration file as shown below.

```bash
citydb export citygml --config-file=/path/to/config.json -o output.gml
```

!!! note
    Connection options from a configuration file can be used alongside command-line options, in which case command-line
    options take precedence.

!!! warning
    Storing passwords in a configuration file in clear text may pose a security risk. Consider using an environment
    variable for the password instead, or leave the `--db-password` option empty to be prompted.

## Using environment variables

You can use environment variables to define database connection details dynamically. This approach is useful for
automated scripts, CI/CD pipelines, or when credentials should not be hard-coded. It is also ideal for running in Docker
environments, where environment variables can be easily passed into containers at runtime.

The following environment variables for defining database connection details are supported by citydb-tool and
closely align with the command-line options:

| Environment variable | Description                                                          |
|----------------------|----------------------------------------------------------------------|
| `CITYDB_HOST`        | Name of the host on which the 3DCityDB is running.                   |
| `CITYDB_PORT`        | Port of the 3DCityDB server.                                         |
| `CITYDB_NAME`        | Name of the 3DCityDB database to connect to.                         |
| `CITYDB_SCHEMA`      | Schema to use when connecting to the 3DCityDB.                       |
| `CITYDB_USER`        | Username to use when connecting to the 3DCityDB.                     |
| `CITYDB_PASSWORD`    | Password to use when connecting to the 3DCityDB.                     |
| `CITYDB_CONN_PROPS`  | Database-specific connection properties provided as key-value pairs. |

The following command demonstrates how to use these environment variables to dynamically specify database connection
details.

=== "Linux"

    ```bash
    export CITYDB_HOST=localhost
    export CITYDB_PORT=5432
    export CITYDB_NAME=citdb
    export CITYDB_SCHEMA=citydb
    export CITYDB_USER=citydb_user
    export CITYDB_PASSWORD=mySecret
        
    ./citydb export citygml -o output.gml
    ```

=== "Windows"

    ```bat
    set CITYDB_HOST=localhost
    set CITYDB_PORT=5432
    set CITYDB_NAME=citdb
    set CITYDB_SCHEMA=citydb
    set CITYDB_USER=citydb_user
    set CITYDB_PASSWORD=mySecret
    
    citydb export citygml -o output.gml
    ```

!!! note
    Environment variables can be used alongside command-line options and configuration files. However, they have the lowest
    precedence and are overridden by these options.

[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2F3dcitydb.github.io%2F3dcitydb-mkdocs%2Fcitydb-tool%2Fdb-connection%2F&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=Visitors&edge_flat=false)](https://hits.seeyoufarm.com/#history)

/// caption
///
