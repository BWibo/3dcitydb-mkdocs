---
title: Geometry module
description: Tables for storing explicit and implicit geometries
tags:
  - 3dcitydb
  - relational schema
---

## GEOMETRY_DATA table

Starting from version 5, the geometry table has been named to ``GEOMETRY_DATA`` and redesigned to store not only surface-based geometries (Polygon, MultiSurface, Solid etc.) but also points and curves. In addition, this table used the predefined spatial data types of the database to store every geometry using a single row, not only for the simple primitive geometries, but also for complex geometries e.g. Solid and MultiSurface. In consequence, the identifier of the nested polygons cannot be stored in a column anymore. However, this identifier is required for linking with the appearance module, in order to assign textures and colors. This is solved by means of introducing an additional column ``GEOMETRY_PROPERTIES``, which is based on a json structure for storing the detailed attribute information of the geometry and its nested geometries in case of complex geometry.

The following table shows, how a simple solid geometry is stored in the ``GEOMETRY_DATA`` table. The first column ``ID`` is used for uniquely identifying the geometry row in the database. The ``GEOMETRY`` column uses the binary WKT format to store all belonging polygons based on the WKT’s ``MULTIPOLYGON``.

| id  | geometry     | implicit_geometry | geometry_property | feature_id |
| --- | ------------ | ----------------- | ----------------- | ---------- |
| 1   | {Binary WKT} | NULL              | {JSON CLOB}       | 1          |

The JSON code looks like the following. A full JSON schema for the JSON structure can be found in the subfolder json-schema/geometry-properties.schema.

``` json
{
  "type": 9,
  "objectId": "lod1Solid",
  "children": [
    {
      "type": 6,
      "objectId": "lod1CompositeSurface"
    },
    {
      "type": 5,
      "objectId": "Left",
      "parent": 0,
      "geometryIndex": 0
    },
    {
      "type": 5,
      "objectId": "Front",
      "parent": 0,
      "geometryIndex": 1
    },
    {
      "type": 5,
      "objectId": "Back",
      "parent": 0,
      "geometryIndex": 2
    },
    {
      "type": 5,
      "objectId": "Roof",
      "parent": 0,
      "geometryIndex": 3
    },
    {
      "type": 5,
      "objectId": "bottom",
      "parent": 0,
      "geometryIndex": 4
    }
  ]
}
```

## IMPLICIT_GEOMETRY table

This table is mainly used for storing implicit geometries, which can be seen as prototypical geometries stored only once and re-used or referenced many times. Each occurrence is represented as a new row in the ``PROPERTY`` table together with a link to the corresponding implicit geometry row via the column ``VAL_IMPLICITGEOM_ID``. The columns ``VAL_LOD``, ``VAL_IMPLICITGEOM_REFPOINT``, and ``VAL_ARRAY`` in the ``PROPERTY`` table are required for representing the information about level of details (LoD), anchor point, as well as the transformation matrix. If the shape of an implicit geometry is referenced by a URI using the library Object, the denoted object itself together with its URI and MIME type information should be stored in the columns ``LIBRARY_OBJECT``, ``REFERENCE_TO_LIBRARY``, ``MIME_TYPE``, and ``MIME_TYPE_CODESPACE`` respectively. Otherwise, the foreign key ``RELATIVE_GEOMETRY_ID`` should be used for referencing to the geometric object stored in the ``GEOMETRY_DATA`` table.
