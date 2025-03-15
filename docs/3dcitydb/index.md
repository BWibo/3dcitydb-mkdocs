---
title: General
description:
---

The **3D City Database V5** is a free 3D geo database to store, represent, and manage 
virtual 3D city models within a standard spatial relational database. 
The database model contains semantically rich, hierarchically structured, multi-scale 
urban objects facilitating complex GIS modeling and analysis tasks, 
far beyond visualization.

The database schema of the 3D City Database V5 results from a systematic mapping 
of the data model defined in the 
[OGC City Geography Markup Language Conceptual Model (**CityGML Version 3.0**)](https://www.ogc.org/standard/citygml/){target="blank"},
an international standard for representing and exchanging
virtual 3D city models issued by the [Open Geospatial Consortium (OGC)](https://www.ogc.org/){target="blank"}. 

All software of the new 3DCityDB v5 - but also of the previous versions - are available 
from the 3DCityDB Github repository [https://github.com/3dcitydb](https://github.com/3dcitydb){target="blank"}
and from the 3DCityDB homepage at [https://www.3dcitydb.org/](https://www.3dcitydb.org/){target="blank"}.

## 3DCityDB v5 software suite

`3DCityDB v5` is a software suite, currently consisting of these components (which are 
all covered by this documentation):

1. The `3dcitydb` database schema and pgSQL utility scripts, running within a PostgreSQL
   database management system with PostGIS spatial extension. Github repo:
   [https://github.com/3dcitydb/3dcitydb](https://github.com/3dcitydb/3dcitydb){target="blank"}
3. The software `citydb-tool` to import and export CityGML datasets of arbitrary file 
   sizes using both GML and CityJSON encoding. All CityGML versions (3.0, 2.0, and 1.0)
   as well as GML-based encodings ("CityGML files") and JSON-based encodings 
   ("CityJSON files") are supported. Github repo:
   [https://github.com/3dcitydb/citydb-tool](https://github.com/3dcitydb/citydb-tool){target="blank"}

## Key features of 3DCityDB v5

 * Full support for CityGML versions 3.0, 2.0 and 1.0
 * Complex thematic modelling including support for Application Domain Extensions (ADE). 
 * Four (CityGML 3.0) or Five (CityGML 2.0 and 1.0) different Levels of Detail (LODs)
 * Appearance information (textures and materials)
 * Digital terrain models (DTMs) represented as TINs
 * Representation of generic and prototypical 3D objects
 * Free, also recursive aggregation of geo objects
 * Flexible 3D geometries (Solid, CompositeSolid, MultiSurface, CompositeSurface, 
   Polygon, TINs, MultiCurve, CompositeCurve, LineString, LinearRing, Point, MultiPoint)
 * Stored database functions to delete complex objects including all their nested 
   sub-objects and geometries. As an alternative, objects can only be marked as terminated,
   which leaves them in the database but sets their termination date timestamps accordingly.
   This realizes a simple but powerful historization / versioning mechanism. 
 * Import and export tool to read and write CityGML datasets of arbitrary file 
   sizes using both GML and CityJSON encoding. 
   The [citydb-tool](https://github.com/3dcitydb/citydb-tool){target="blank"} allows the on-the-fly
   upgrade of CityGML 2.0 / 1.0 datasets during import to CityGML 3.0 and the downgrade 
   of stored CityGML 3.0 datasets in the database to CityGML 2.0 or 1.0 files.

The 3D City Database comes as a collection of SQL scripts that allow for creating and 
dropping database instances. Different versions of automatically generated Docker containers are
available. They allow for an immediate launching of a PostgreSQL/PostGIS database with 
preinstalled 3DCityDB data schema and scripts by a single command.

## Changes with respect to V4

Compared to the earlier versions of the `3DCityDB`(V4), more generic mapping rules have been
applied in the mapping of the CityGML 3.0 data model onto the relational schema resulting 
in a significant reduction of the number of database tables.
Furthermore, geometry objects are now directly mapped onto corresponding data types 
provided by PostGIS; i.e. Solid, MultiSurface, CompositeSurfaces, TINs, etc. are no longer
split into their individual polygons stored as separate rows as it was done in 3DCityDB V4. 
This makes it much easier to express spatial queries in SQL, faster to evaluate such queries, 
and also to directly connect to the 3DCityDB from geoinformation systems 
like QGIS or ArcGIS and utilize the spatial objects. 

Unlike the `3DCityDB-Importer-Exporter` for `3DCityDB v4`, the new citydb-tool does not provide 
a graphical user interface, but instead can fully be controlled via the command line
interface.

An exporter for visualization formats like KML, COLLADA, glTF (as was included in the 
`3DCityDB-Importer-Exporter`) is not available yet. However, we are already working on 
a tool to export visualization data in the form of OGC `3DTiles`. For that purpose we are 
currently customizing the third-party Open Source tool [pg2b3dm](https://github.com/Geodan/pg2b3dm){target="blank"} 
developed by Bert Temme to directly work on the 3DCityDB v5. The tool will be provided as a 
customized Docker container, too.

Note, that `3DCityDB v4` and its tools remain functioning and are still available. They will
be maintained at least for the next 1-2 years to give users enough time to migrate to the new version.
If you are (interested in) using the previous version and its tools, please refer to the old 
package [3DCityDB v4 suite](https://github.com/3dcitydb/3dcitydb-suite){target="blank"}. The documentation 
of the 3DCityDB v4 suite is still [available here](https://3dcitydb-docs.readthedocs.io/en/latest/){target="blank"}.

## Who is using the 3D City Database?

The 3DCityDB V5 has just been released and we expect that most users of the earlier
version (V4) will migrate to the new version sometime in the future. Note, that the 
earlier version V4 is still working, 
[available](https://github.com/3dcitydb/3dcitydb/tree/3dcitydb-v4), and will also still
be supported for some time in the next 1-2 years. However, we recommend to start new projects 
using the new version V5. V4 of the 3D City Database is in use in real life production systems in 
many places around the world such as Berlin, Potsdam, Hamburg, Munich, Frankfurt, Dresden, 
Rotterdam, Vienna, Helsinki, Singapore, Zurich and is also being used in a number of research projects.

The companies [Virtual City Systems](https://vc.systems/) and [M.O.S.S.](https://www.moss.de/), 
who are also partners in development, use the 3D City Database at the core of their 
commercial products and services to create, maintain, visualize, transform, and export 
virtual 3D city models. Furthermore, the state mapping agencies of the federal states in Germany 
store and manage the nation-wide collected 3D city models (including approx. 56 million building models
and bridges) in CityGML LOD1 and LOD2 using the 3D City Database. 

## Where to find CityGML data?

An excellent list of Open Data 3D city models, especially also represented using CityGML, 
can be found in the [Awesome CityGML list](https://github.com/OloOcki/awesome-citygml). 
Currently, datasets from 21 countries and 65 regions/cities can be downloaded for free
(with a total of >210 million semantic 3D building models). All of the provided CityGML files 
can be loaded, analyzed, and managed using the 3DCityDB.

## License

The 3D City Database is licensed under the 
[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0).
See the `LICENSE` file for more details.

Note that releases of the software before version 3.3.0 continue to be licensed under 
[GNU LGPL 3.0](https://www.gnu.org/licenses/lgpl-3.0.en.html).
To request a previous release of the 3D City Database under Apache License 2.0 
create a GitHub issue.

[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2F3dcitydb.github.io%2F3dcitydb-mkdocs%2F3dcitydb%2Findex%2F&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=Visitors&edge_flat=false)](https://hits.seeyoufarm.com/#history)

/// caption
///
