---
title: Metadata module
description: Tables for storing meta-information
tags:
  - 3dcitydb
  - relational schema
---

## NAMESPACE table

The new 3DCityDB version 5 is mainly designed for supporting CityGML 3.0 as well as for the old version 2.0 and 1.0. However, the same feature class from different CityGML versions have different namespaces. In order to assign a unique namespace for a feature class e.g. Building, a set of new 3DCityDB native namespaces have been defined, which are stored in the table NAMESPACE and can be prefilled after the setup of 3DCityDB instance automatically. A full list of the namespaces are shown in the following table. The definition of the prefilled 3DCityDB namespaces follows the standard modulation to the CityGML 3.0 abstract model. Hence, all values of the last column ``ADE_ID`` is NULL for these standard namespaces. When adding a new CityGML ADE extensions, its namespace should be first registered in this table, and the ``ADE_ID`` value should then be filled and reference to the ADE table, where all ADEs are registered.

| id  | alias | namespace                                          | ade_id |
| --- | ----- | -------------------------------------------------- | ------ |
| 1   | core  | <http://3dcitydb.org/3dcitydb/core/5.0>            | NULL   |
| 2   | dyn   | <http://3dcitydb.org/3dcitydb/dynamizer/5.0>       | NULL   |
| 3   | gen   | <http://3dcitydb.org/3dcitydb/generics/5.0>        | NULL   |
| 4   | luse  | <http://3dcitydb.org/3dcitydb/landuse/5.0>         | NULL   |
| 5   | pcl   | <http://3dcitydb.org/3dcitydb/pointcloud/5.0>      | NULL   |
| 6   | dem   | <http://3dcitydb.org/3dcitydb/relief/5.0>          | NULL   |
| 7   | tran  | <http://3dcitydb.org/3dcitydb/transportation/5.0>  | NULL   |
| 8   | con   | <http://3dcitydb.org/3dcitydb/construction/5.0>    | NULL   |
| 9   | tun   | <http://3dcitydb.org/3dcitydb/tunnel/5.0>          | NULL   |
| 10  | bldg  | <http://3dcitydb.org/3dcitydb/building/5.0>        | NULL   |
| 11  | brid  | <http://3dcitydb.org/3dcitydb/bridge/5.0>          | NULL   |
| 12  | app   | <http://3dcitydb.org/3dcitydb/appearance/5.0>      | NULL   |
| 13  | grp   | <http://3dcitydb.org/3dcitydb/cityobjectgroup/5.0> | NULL   |
| 14  | veg   | <http://3dcitydb.org/3dcitydb/vegetation/5.0>      | NULL   |
| 15  | vers  | <http://3dcitydb.org/3dcitydb/versioning/5.0>      | NULL   |
| 16  | wtr   | <http://3dcitydb.org/3dcitydb/waterbody/5.0>       | NULL   |
| 17  | frn   | <http://3dcitydb.org/3dcitydb/cityfurniture/5.0>   | NULL   |
| 18  | depr  | <http://3dcitydb.org/3dcitydb/deprecated/5.0>      | NULL   |

## ADE table

The table ADE serves as a central registry for all the registered extensions e.g. CityGML ADEs, each of which corresponds to a table row. The relevant ADE metadata attributes are mapped onto the respective columns. For example, each registered ADE receives a unique ID value in the database, that can be referenced by the belonging namespaces in the table namespace. The columns NAME and DESCRIPTION are mainly used for storing a basic description about each ADE. The column VERSION denotes the version number of an ADE and allows to distinguish different ADE versions, which might be compatible with different CityGML versions.

## OBJECTCLASS table

The table OBJECTCLASS is a central registry for enumerating not only the standard CityGML classes, but also the classes of the registered ADEs. In this table, Each class is assigned a globally unique numeric ID for querying and accessing the class-related information stored in the columns CLASSNAME, IS_ABSTRACT and IS_TOPLEVEL. The SCHEMA column stores the schema mapping information, which are in JSON structured and describe how the corresponding class is mapped to a database table.

Example of the schema mapping for the ADDRESS class

``` json
{
  "identifier": "core:Address",
  "table": "address",
  "properties": [
    {
      "name": "objectId",
      "namespace": "http://3dcitydb.org/3dcitydb/core/5.0",
      "value": {
        "column": "objectid",
        "type": "string"
      }
    },
    {
      "name": "identifier",
      "namespace": "http://3dcitydb.org/3dcitydb/core/5.0",
      "value": {
        "column": "identifier",
        "type": "string"
      }
    },
    {
      "name": "codeSpace",
      "namespace": "http://3dcitydb.org/3dcitydb/core/5.0",
      "value": {
        "column": "identifier_codespace",
        "type": "string"
      },
      "parent": 1
    },
    {
      "name": "street",
      "namespace": "http://3dcitydb.org/3dcitydb/core/5.0",
      "value": {
        "column": "street",
        "type": "string"
      }
    },
    {
      "name": "houseNumber",
      "namespace": "http://3dcitydb.org/3dcitydb/core/5.0",
      "value": {
        "column": "house_number",
        "type": "string"
      }
    },
    {
      "name": "poBox",
      "namespace": "http://3dcitydb.org/3dcitydb/core/5.0",
      "value": {
        "column": "po_box",
        "type": "string"
      }
    },
    {
      "name": "zipCode",
      "namespace": "http://3dcitydb.org/3dcitydb/core/5.0",
      "value": {
        "column": "zip_code",
        "type": "string"
      }
    },
    {
      "name": "city",
      "namespace": "http://3dcitydb.org/3dcitydb/core/5.0",
      "value": {
        "column": "city",
        "type": "string"
      }
    },
    {
      "name": "state",
      "namespace": "http://3dcitydb.org/3dcitydb/core/5.0",
      "value": {
        "column": "state",
        "type": "string"
      }
    },
    {
      "name": "country",
      "namespace": "http://3dcitydb.org/3dcitydb/core/5.0",
      "value": {
        "column": "country",
        "type": "string"
      }
    },
    {
      "name": "multiPoint",
      "namespace": "http://3dcitydb.org/3dcitydb/core/5.0",
      "value": {
        "column": "multi_point",
        "type": "core:MultiPoint"
      }
    }
  ]
}
```

The column ``SUPERCLASS_ID`` is a foreign key referencing to the super class id for representing the inheritance hierarchy of all classes. The last foreign key columns ``namepsace_id`` and ``ade_id`` can be used for retrieving the namespace and ADE information from the two above-mentioned NAMESPACE and ADE tables.

## DATATYPE table

Similar to the ``OBJECTCLASS`` table, The ``DATATYPE`` table is a central registry for all simple and complex data types. Each class is assigned a globally unique numeric ID for querying and accessing the datatype-related information stored in the columns ``TYPENAME``, ``IS_ABSTRACT``, and ``IS_TOPLEVEL``. There is also a column schema for storing the schema mapping information in JSON format.

Example of the schema mapping for the data type AddressProperty

``` json
{
  "identifier": "core:AddressProperty",
  "table": "property",
  "join": {
    "table": "address",
    "fromColumn": "val_address_id",
    "toColumn": "id"
  }
}
```

The column ``SUPERTYPE_ID`` referencing to the super datatype id can be used for representing the inheritance hierarchy of all the registered data types. The namespace and ADE information of each data type are also achievable over the columns ``NAMESAPCE_ID`` and ``ADE_ID`` respectively.

## DATABASE_SRS table

The definition of the CRS of a 3D City Database instance consists of two components:

1. A valid Spatial Reference Identifier (SRID, typically the EPSG code) and
2. A definition identifier for the CRS. For example an OGC GML conformant CRS definition identifier

Both components are defined during the [database setup](./../first-steps/setup.md) and are further stored in the table ``DATABASE_SRS``.
