---
title: Appearance module
description: Tables for storing appearance information
tags:
  - 3dcitydb
  - relational schema
---

## APPEARANCE table

The appearance module is almost adopted from the database schema of the old 3DCityDB version 4. The table ``APPEARANCE`` contains information about the surface data of objects (attribute DESCRIPTION). The appearance category is stored in the column THEME. Since each feature and implicit geometry may store its own appearance data, the table ``APPEARANCE`` is related to the tables ``FEATURE`` and ``IMPLICIT_GEOMETRY`` by two foreign keys ``FEATURE_ID`` and ``IMPLICIT_GEOMETRY_ID``. An Appearance is actually a feature object, which can be referenced ``OBJECTID, IDENTIFIER,`` and ``IDENTIFIER_CODESPACE``, and versioned using the attribute columns ``CREATION_DATE, TERMINATION_DATE, VALID_FROM,`` and ``VALID_TO``. In order to determine if an Appearance is shared by multiple top-level features, the flag attribute ``IS_GLOBAL`` can be used.

## SURFACE_DATA and APPEAR_TO_SURFACE_DATA tables

An appearance is composed of data for each surface geometry object. Information on the data types and its appearance are stored in table ``SURFACE_DATA``, which is associated with the table ``APPEARANCE`` over the table ``APPEAR_TO_SURFACE_DATA``. In the ``SURFACE_DATA`` table, ``IS_FRONT`` determines the side a surface data object applies to (``IS_FRONT``=1: front face ``IS_FRONT``=0: back face of a surface data object). The ``OBJECTCLASS_ID`` column denotes, if materials or textures are used for the specific object (values: X3DMaterial, Texture, or GeoreferencedTexture). Materials are specified by the columns **X3D_xxx** which define its graphic representation. Details on using georeferenced textures, such as orientation and reference point, are contained in attributes **GT_xxx**. More information of the ``SURFACE_DATA`` attributes can be found in the CityGML specification, which explains the texture mapping process in detail.

## TEX_IMAGE table

Raster-based 2D textures are stored in the table ``TEX_IMAGE``. The name of the corresponding images is specified by the attribute ``IMAGE_URI``. The texture image can be stored within this table in the column ``IMAGE_DATA`` using binary data type. The ``MIMETYPE`` information of an image file are stored in the columns ``MIME_TYPE`` and ``MIME_TYPE_COEDSPACE``.

## SURFACE_DATA_MAPPING table

This table is used for linking the surface data to the surface geometries, which are stored in the ``SURFACE_DATA`` table. The 4 columns ``MATERIAL_MAPPING, TEXTURE_MAPPING, WORLD_TO_TEXTURE_MAPPING`` and ``GEOREFERENCED_TEXTURE_MAPPING`` use a JSON structure, which contains the objectids of the target surfaces plus the texture/material mapping.

Example of how to assign materials. It simply uses ture to assign the material to the target surface. The same json structure is also used for mapping geo-referenced textures.

```json
{
  "surface_A": true,
  "surface_D": true
}
Example of world-to-texture mapping schema
{
  "surface_A": [
    -0.4, 0.0, 0.0, 1.0,
     0.0, 0.0, 0.3333, 0.0,
     0.0, 0.0, 0.0, 1.0
  ],
  "surface_D": [
    …
  ]
}
Example of how to assign texture coordinates. Each texture coordinate (s,t)
is embraced by another array, which represents an interior or exterior ring
{
  "surface_A": [
    [ [0.0, 0.5], [0.7, 0.3], …],
    [ [0.1, 0.3], [0.6, 0.4], …],
    …
  ],
  "surface_D": [
    …
  ]
}
```