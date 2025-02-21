---
# title: Requirements
description: What do I need for the installation
# icon: material/emoticon-happy
tags:
  - requirements
---

# System requirements

Setting up an instance of the 3D City Database requires an existing installation of a [PostgreSQL](https://www.postgresql.org/) or use our [Docker images](../3dcitydb/docker.md). We recommend checking data and database [compatibility](../compatibility.md) first.

## PostgreSQL with PostGIS extension

Supported versions are PostgreSQL 13 and higher with PostGIS 3.0 and higher. Make sure to check the [PostgreSQL versioning policy](https://www.postgresql.org/support/versioning/) to find out which PostgreSQL versions are actively maintained or have reached end-of-life. The [PostGIS support matrix](https://trac.osgeo.org/postgis/wiki/UsersWikiPostgreSQLPostGIS) shows which versions of PostgreSQL are supported by which versions of PostGIS and whether a specific PostGIS version has reached end-of-life.

!!! info "NOTE"
    It is recommended that you always install the latest patches, minor releases, and security updates for your database system. Database versions that have reached end-of-life are no longer supported by the 3D City Database.

The SQL scripts for creating the 3D City Database schema are written to be executed by the default command-line client of either database system – namely psql for PostgreSQL. The scripts include meta commands specific to these clients and would not work properly when using a different client software. So please make sure psql is installed on the machine from where you want to set up the 3D City Database.
