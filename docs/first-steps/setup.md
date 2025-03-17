---
title: Setting up a 3DCityDB
description: How to setup a 3DCityDB.
tags:
  - 3dcitydb
  - setup
  - bare metal
  - docker
  - shell scripts
  - database scripts
  - sql scripts
  - template database
---

The recommended way to set up a bare metal 3D City Database (3DCityDB) instance is by using the installation scripts
provided as separate 3DCityDB download package. These scripts are also included in each `citydb-tool` distribution.
Follow the [download instruction](../download.md) to obtain them. Alternatively, [use Docker :material-docker:](docker.md) for
a simpler setup and deployment of a 3DCityDB instance.

## 3DCityDB setup steps

### Step 1 - Create an empty PostgreSQL database

The first step is to create a new, empty database on your PostgreSQL server. Use a superuser or a database user
with the `CREATEDB` permission to do so. While not required, it is recommended to select or create a dedicated user
to own the database, who will also be used to run the 3DCityDB setup scripts in later steps.

The following command demonstrates how to create a new database for the user `citydb_user`.

``` SQL
CREATE DATABASE citydb_v5 OWNER citydb_user;
```

!!! tip
    You can execute this command using PostgreSQL's command-line client `psql` or any other SQL tool, such as the
    graphical database client [`pgAdmin`](https://www.pgadmin.org/). Refer to the documentation of your preferred tool
    for more information.

### Step 2 - Add the PostGIS extension

The 3D City Database requires the PostGIS extension to be added to the database. This can only be done by a superuser.
Use the following command to add the PostGIS extension:

``` SQL
CREATE EXTENSION postgis;
```

!!! info "Optional"
    To enable advanced spatial 3D operations such as extrusion, volume calculation, or union/intersection/difference of
    volume geometries, you can additionally install the `postgis_sfcgal` extension:

    ``` SQL
    CREATE EXTENSION postgis_sfcgal;
    ```

### Step 3 - Edit the `connection-details` script

Now it's time to use the 3DCityDB setup scripts. Navigate to the `3dcitydb/postgresql/shell-scripts` directory
where you have unzipped the 3DCityDB software package, or locate this folder within the installation directory of
`citydb-tool`. Then, change to the subfolder `unix` or `windows`, depending on your operating system.

Once inside, locate the `connection-details.[sh|bat]` script and open it with a text editor of your choice.
Enter the database connection details along with the full path to the `psql` executable in this file. As mentioned
above, it is recommended to provide the user who owns the database as `PGUSER` in the script.

Below is an example of the required information to include in the `connection-details` file.

=== "Linux"

    ```bash
      #!/bin/bash
      # Provide your database details here ----------------
      export PGBIN=/var/lib/postgresql/[version]/bin
      export PGHOST=localhost
      export PGPORT=5432
      export CITYDB=citydb_v5
      export PGUSER=citydb_user
      #----------------------------------------------------
    ```

=== "Windows"

    ```bat
      # Provide your database details here ----------------
      set PGBIN=C:\Program Files\PostgreSQL\[version]\bin
      set PGHOST=localhost
      set PGPORT=5432
      set CITYDB=citydb_v5
      set PGUSER=citydb_user
      #----------------------------------------------------
    ```

!!! info
    If the `psql` executable is already on your `PATH`, you can comment out or remove the line setting
    the `PGBIN` variable in the script.

### Step 4 - Execute the `create-db` script

Once the connection details have been set in the `connection-details` file, execute the `create-db.[sh|bat]` script
located in the same folder to begin the setup process. You can do this either by double-clicking the script or
by running it from within a shell environment. On UNIX/Linux machines, you may first need to set the appropriate file
permissions to make the script executable.

=== "Linux"

    ```bash
    chmod u+x create-db.sh
    ./create-db.sh
    ```

=== "Windows"

    ```bat
    create-db.bat
    ```

It is also possible to use a different `connection-details` file from another folder:

=== "Linux"

    ```bash
    ./create-db.sh /path/to/connection-details.sh
    ```

=== "Windows"

    ```bat
    create-db.bat C:\path\to\connection-details.bat
    ```

After executing the script, a welcome message along with usage hints will be displayed on the console. The script
will prompt the user for several essential parameters required for setting up the 3DCityDB instance.
The details of these user inputs are explained in the following steps.

### Step 5 – Specify the coordinate reference system

You are prompted for the coordinate reference system (CRS) to be used for the 3DCityDB instance.
Simply enter the PostGIS-specific SRID (**S**patial **R**eference **ID**) of the CRS. In most cases, the SRID will be
identical to the EPSG code of the CRS. There are three parameters that need to be provided in this step:

- __The SRID to be used with the geometries stored in the database:__ Only one SRID can be used for the
  3DCityDB instance.
- __The EPSG code of the height system:__ This is considered metadata and does not affect the geometries in the
  database. If the above SRID already references a true 3D CRS or if the height system is unknown, enter "0"
  (meaning "not available"). This is also the default value.
- __The OGC-compliant name of the CRS:__ The CRS name is, for instance, written to CityGML/CityJSON files
  when exporting data from the database. The `create-db` script proposes a URN-encoded name based on your
  input, following OGC recommendations. Simply press ++enter++ to accept the proposed value.

      ```
      urn:ogc:def:crs,crs:EPSG::<SRID>[,crs:EPSG::<HEIGHT_EPSG>]
      ```

!!! tip
    The coordinate reference system can be changed at any time after setup using the database function
    `citydb_pkg.change_schema_srid`. Refer to the [database procedures section](../3dcitydb/db-functions.md) for
    more information.

### Step 6 – Create changelog extension

You can choose whether to create the changelog extension for your 3DCityDB instance. The changelog
extension adds a table to the 3DCityDB schema, where insert, delete, and update operations on top-level city objects
are tracked. Each changelog entry provides metadata about the affected city object (identifier, envelope, etc.),
the database user executing the operation, a reason for the update, and the transaction type.
Database triggers are installed to automatically populate the changelog table. As a result, insert, delete,
and update operations may take longer when the changelog extension is used.

Enter `yes` or `no` to decide whether to install the changelog extension. The default value is `no`, which
can be confirmed by simply pressing ++enter++.

!!! tip
    The changelog extension can be installed and removed at any time after setup using the shell scripts
    `create-changelog` and `drop-changelog`.

### Step 7 - Execute the installation

Finally, enter the password for the database user provided in the `connection-details` script. Afterward,
the setup process will begin, and log messages informing you about the progress will be printed to the console.

The setup process will terminate immediately if any errors occur. Possible reasons include:

- The user executing `create-db` is neither a superuser nor the owner of the specified database (or does
  not have the privileges to create objects in that database).
- The PostGIS extension has not been installed.
- Parts of the 3DCityDB already exists because of a previous setup attempt. To prevent this, ensure that the schemas
  `citydb` and `citydb_pkg` do not exist in the database before starting the setup process.

When the message `Done` is displayed, the setup has been successfully completed. The figure below shows a
summary of the required user input for the `create-db` script.

![create-db script](assets/create-db.png)
/// figure-caption
Example user input for the create-db script.
///

## Shell scripts

In addition to the `connection-details` and `create-db` shell scripts for setting up a 3DCityDB instance, the 3DCityDB
package includes several other shell scripts designed for various tasks. Like the `create-db` script, these scripts may
also prompt the user for information necessary to execute them. The `connection-details` script is used by all these
scripts to establish a connection to your 3DCityDB instance, so ensure to adjust the connection details before
executing any of these scripts

The following table provides an overview of the available shell scripts. They can be executed either by
double-clicking them or by running them from within a shell environment.

| Script [.sh\|.bat]   | Description                                                                                               |
|----------------------|-----------------------------------------------------------------------------------------------------------|
| `connection-details` | Stores the connection details for a 3DCityDB instance which are used by all other scripts                 |
| `create-db`          | Creates a new 3DCityDB instance (relational schema including all database functions)                      |
| `create-schema`      | Creates an additional data-schema (analogous to the default schema `citydb`) with a user-defined name     |
| `drop-db`            | Drops a 3DCityDB instance (incl. all elements of the relational schema)                                   |
| `drop-schema`        | Drops a data-schema that has been created with `create-schema`                                            |
| `grant-access`       | Grants read-only or read-write access to a 3DCityDB instance                                              |
| `revoke-access`      | Revokes read-only or read-write access to a 3DCityDB instance, which has been granted with `grant-access` |
| `create-changelog`   | Create the changelog extension for a 3DCityDB instance                                                    |
| `drop-changelog`     | Remove the changelog extension from a 3DCityDB instance                                                   |

!!! tip
    Remember that you may first need to set the appropriate file permissions to make the scripts executable on
    UNIX/Linux machines.

## SQL scripts

Technically, the shell scripts listed above are simply wrappers designed to collect user input in a convenient manner.
The actual actions at the database level are carried out by SQL scripts that are invoked by these shell scripts.

The SQL scripts are provided in the `3dcitydb/postgresql/sql-scripts` directory of the 3DCityDB software package
or inside the installation directory of the `citydb-tool`. Navigate to the `unix` or `windows` subfolder,
depending on your operating system. The SQL scripts are designed to be executed with `psql`.

Most of the SQL scripts require input parameters to execute the database action. These parameters are expected to be
passed as command-line parameters to `psql`. Below is an example of how to invoke the `create-db.sql` script to set up
a 3DCityDB instance. The required input parameters have been discussed in the setup steps above. Refer to the
`psql` documentation for more information about the command-line parameters.

=== "Linux"

    ```bash
    psql -d "citydb_v5" \
        -h localhost \
        -U "citydb_user" \
        -f "/path/to/the/reate-db.sql" \
        -v srid="25833" \
        -v srs_name="urn:ogc:def:crs:EPSG::25833" \
        -v changelog="no"
    ```

=== "Windows"

    ```bat
    psql -d "citydb_v5" ^
        -h localhost ^
        -U "citydb_user" ^
        -f "C:\path\to\the\create-db.sql" ^
        -v srid="25833" ^
        -v srs_name="urn:ogc:def:crs:EPSG::25833" ^
        -v changelog="no"
    ```

!!! tip
    By using shell or environment variables instead of hardcoding values directly into your command as shown above, you make
    it easier to reuse the SQL scripts across different setups or systems. This makes automating things, integrating them
    into other
    software, or running them as part of a CI/CD pipeline way more flexible. This is an easy way to streamline workflows
    using the SQL scripts.

## Using template databases to set up a 3DCityDB

In PostgreSQL, **template databases** are pre-configured databases that serve as a base for creating new databases.
Using a
template database during database creation is a common practice. The new database is essentially created as a copy of
one of the template databases, with a few modifications (such as the database name). These template databases enable
quick database creation by copying an existing structure, schema, and even data.

You can also use a 3DCityDB instance as a template database. However, be cautious, as the `search_path` is not
automatically copied from the template database to the new 3DCityDB instance. A correct search path is crucial for
accessing data and database functions in the `citydb` and `citydb_pkg` schemas. Therefore, you must manually set the
search path in your new 3DCityDB instance:

```SQL
ALTER DATABASE new_citydb_v5 SET search_path TO citydb, citydb_pkg, public;
```
!!! info
    If your 3DCityDB template contains more schemas, ensure to add them all to the `search_path`.
    Note that the search path will be updated upon the next login, not within the same session.

[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2F3dcitydb.github.io%2F3dcitydb-mkdocs%2Ffirst-steps%2Fsetup%2F&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=Visitors&edge_flat=false)](https://hits.seeyoufarm.com/#history)

/// caption
///
