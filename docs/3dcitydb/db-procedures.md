---
title: Database procedures
---

The 3D City Database is shipped with a set of stored procedures, which are automatically installed during
the setup procedure of the 3D City Database. In the PostgreSQL version, functions are written in PL/pgSQL
and stored either in their own database schema called `citydb_pkg`.
Many of these functions and procedures expose certain tasks on the database side to the citydb-tool. When calling
stored procedures, the `citydb_pkg` schema has not to be specified as prefix since it is put on the database search
path during setup.

## SRS procedures

The `citydb_pkg` package provides functions and procedures dealing with the coordinate reference system used
for an 3D City Database instance. The most essential procedure is `change_schema_srid` to change the
reference system for all spatial columns within a database schema. If a coordinate transformation is needed
because an alternative reference system shall be used, the value `1` should be passed to the procedure as the
third parameter. If a wrong `SRID` had been chosen by mistake during setup, a coordinate transformation might
not be necessary in case the coordinate values of the city objects are already matching the new reference system.
Thus, the value `0` should be provided to the procedure, which then only changes the spatial metadata to reflect
the new reference system. It can also be omitted, as `0` is the default value for the procedure.
Either way, changing the CRS will drop and recreate the spatial index for the affected column.
Therefore, this operation can take a lot of time depending on the size of the table.

| Function                                                                                                                                                                                                | Return Type  | Explanation                                               |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------|-----------------------------------------------------------|
| **`change_schema_srid`**<br/>`(schema_srid INTEGER, schema_srs_name TEXT, transform INTEGER DEFAULT 0, schema_name TEXT DEFAULT 'citydb')`                                                              | `SETOF VOID` | Update the coordinate system for a database schema        |
| **`change_column_srid`**<br/>`(table_name TEXT, column_name TEXT, dim INTEGER, schema_srid INTEGER, transform INTEGER DEFAULT 0, geom_type TEXT DEFAULT 'GEOMETRY', schema_name TEXT DEFAULT 'citydb')` | `SETOF VOID` | Update the coordinate system for a geometry column        |
| **`check_srid`**<br/>`(srsno INTEGER DEFAULT 0)`                                                                                                                                                        | `TEXT`       | Check if a given `SRID` is valid                          |
| **`is_coord_ref_sys_3d`**<br/>`(schema_srid INTEGER)`                                                                                                                                                   | `INTEGER`    | Check if a a coordinate system is 3D                      |
| **`is_db_coord_ref_sys_3d`**<br/>`(schema_name TEXT DEFAULT 'citydb')`                                                                                                                                  | `INTEGER`    | Check if the coordinate system of a database schema is 3D |

## UTIL procedures

The `citydb_pkg` package also provides various utility functions.
Nearly the functions `db_metadata` and `get_child_objectclass_ids` take the schema name as the last input argument (
“schema-aware”).
Therefore, they can be executed against another database schema in PostgreSQL. Note, for the
function `get_seq_values` the schema name must be part of the first argument – the sequence name, e.g.
`my_schema.cityobject_seq`. Below is an overview of the API.

| Function                                                                                                                                                                                         | Return Type     | Explanation                                                          |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------|----------------------------------------------------------------------|
| **`citydb_version`**<br/>`(OUT version TEXT,  OUT major_version INTEGER,  OUT minor_version INTEGER,  OUT minor_revision INTEGER) `                                                              | `RECORD`        | Query the full version information of a 3DCityDB instance            |
| **`db_metadata`**<br/>`(schema_name TEXT DEFAULT 'citydb', OUT srid INTEGER, OUT srs_name TEXT, OUT coord_ref_sys_name TEXT, OUT coord_ref_sys_kind TEXT, OUT wktext TEXT, OUT versioning TEXT)` | `RECORD`        | Query the relevant meta information of a 3DCityDB instance           |
| **`get_seq_values`**<br/>`(seq_name TEXT,seq_count BIGINT`                                                                                                                                       | `SETOF BIGINT`  | Query list of sequence values from given sequence                    |
| **`get_child_objectclass_ids`**<br/>`(class_id INTEGER,skip_abstract INTEGER DEFAULT 0,schema_name TEXT DEFAULT 'citydb')`                                                                       | `SETOF INTEGER` | QUERY the IDs of all transitive subclasses of the given object class |

## Delete procedures

The `citydb_pkg` package contains a set of functions that facilitate to delete single and multiple city objects.
Each function automatically takes care of integrity constraints between relations in the database.
These functions can be seen as low-level APIs providing a delete function for each relation ranging
from a single polygon in the table `GEOMETRY_DATA` (`delete_geometry_data`) up to a complete feature (`delete_feature`).
This should help users to develop more complex delete operations on top of these low-level functions without
re-implementing their functionality.

``` SQL
-- single version
SELECT delete_feature(id) FROM feature WHERE ... ;
SELECT cleanup_appearances();

-- array version
SELECT delete_feature(array_agg(id)) FROM feature WHERE ... ;
SELECT cleanup_appearances();
```

``` SQL
-- example procedure for deleting all building features
DO $$
DECLARE
  rec RECORD;
BEGIN
  FOR rec IN SELECT * FROM feature where objectclass_id = 901 LOOP
    -- Call the function for each row
    PERFORM delete_feature(rec.id);
  END LOOP;
END $$;
```

Which delete function to use depends on the ratio between the number of entries to be deleted and the total count
of objects in the database. One array delete executes each necessary query only once compared to numerous single
deletes and can be faster. However, if the array is huge and covers a great portion of the table (say 20% of all rows)
it might be faster to go for the single version instead or batches of smaller arrays. Nested features are deleted
with arrays anyway.

| Function                                                                                                              | Return Type                | Explanation                                                      |
|-----------------------------------------------------------------------------------------------------------------------|----------------------------|------------------------------------------------------------------|
| **`cleanup_schema`** <br/>`(schema_name TEXT DEFAULT 'citydb') `                                                      | `void`                     | truncates all data tables                                        |
| **`delete_feature`**<br/>`(pid bigint, schema_name TEXT)` <br/> or `(pid_array bigint[], schema_name TEXT)`           | `SETOF BIGINT` or `BIGINT` | delete from `FEATURE` table based on an id or id array           |
| **`delete_property`**<br/>`(pid bigint, schema_name TEXT)` <br/> or `(pid_array bigint[], schema_name TEXT)`          | `BIGINT` or `SETOF BIGINT` | delete from `PROPERTY` table based on an id or id array          |
| **`delete_geometry_data`**<br/>`(pid bigint, schema_name TEXT)` <br/> or `(pid_array bigint[], schema_name TEXT)`     | `BIGINT` or `SETOF BIGINT` | delete from `GEOMETRY_DATA` table based on an id or id array     |
| **`delete_implicit_geometry`**<br/>`(pid bigint, schema_name TEXT)` <br/> or `(pid_array bigint[], schema_name TEXT)` | `BIGINT` or `SETOF BIGINT` | delete from `IMPLICIT_GEOMETRY` table based on an id or id array |
| **`delete_appearance`**<br/>`(pid bigint, schema_name TEXT)` <br/> or `(pid_array bigint[], schema_name TEXT)`        | `BIGINT` or `SETOF BIGINT` | delete from `APPEARANCE` table based on an id or id array        |
| **`delete_surface_data`**<br/>`(pid bigint, schema_name TEXT)` <br/> or `(pid_array bigint[], schema_name TEXT)`      | `BIGINT` or `SETOF BIGINT` | delete from `SURFACE_DATA` table based on an id or id array      |
| **`delete_tex_image`**<br/>`(pid bigint, schema_name TEXT)` <br/> or `(pid_array bigint[], schema_name TEXT)`         | `BIGINT` or `SETOF BIGINT` | delete from `TEX_IMAGE` table based on an id or id array         |
| **`delete_address`  **<br/>`(pid bigint, schema_name TEXT)` <br/> or `(pid_array bigint[], schema_name TEXT)`         | `BIGINT` or `SETOF BIGINT` | delete from `ADDRESS` table based on an id or id array           |

## Envelope procedures

The `citydb_pkg` package provides functions that allow a user to calculate the maximum 3D bounding volume of a
feature or implicit geometry identified by its ID. For each feature type, a corresponding function is provided
starting with `envelope_` prefix. The bounding volume is calculated by evaluating all geometries of the feature
in all LoDs including
implicit geometries. Implicit geometries are processed using the `calc_implicit_geometry_envelope` function.
The collected geometries are then aggregated using the `ST_3DExtent function`, which returns a `BOX3D` object representing
the 3D bounding box. The `box2envelope` function turns this output into a diagonal cutting plane through the calculated
bounding box. This surface representation follows the definition of the `ENVELOPE` column of the feature table.
The Envelope functions also allow for updating the `ENVELOPE` column of the features with the calculated value
(by simply setting the `set_envelope` argument that is available for the `get_feature_envelope` function. This is
useful,
for instance, whenever one of the geometry representations of the feature has been changed or if the `ENVELOPE` column
could not be (correctly) filled during import and, for example, is NULL.

| Function                                                                                                                 | Return Type | Explanation                                                |
|--------------------------------------------------------------------------------------------------------------------------|-------------|------------------------------------------------------------|
| **`get_feature_envelope`**<br/> (`fid BIGINT, set_envelope INTEGER DEFAULT 0, schema_name TEXT DEFAULT 'citydb')`        | GEOMETRY    | returns the envelope geometry of a given feature           |
| **`box2envelope`**<br/> `(box BOX3D, schema_name TEXT DEFAULT 'citydb')`                                                 | GEOMETRY    | convert a box geometry to to envelope                      |
| **`update_bounds`**<br/> `(old_bbox GEOMETRY, new_bbox GEOMETRY, schema_name TEXT DEFAULT 'citydb')`                     | GEOMETRY    | returns the envelope geometry of two bounding boxes        |
| **`calc_implicit_geometry_envelope`** `(gid BIGINT, ref_pt GEOMETRY, matrix VARCHAR, schema_name TEXT DEFAULT 'citydb')` | GEOMETRY    | returns the envelope geometry of a given implicit geometry |

## Constraint procedures

The `citydb_pkg` package includes stored procedures to define constraints or change their behavior.
A user can temporarily disable certain foreign key relationships between tables, e.g. the numerous
references to the `GEOMETRY_DATA` table. The constraints are not dropped. While it comes at the risk of data inconsistency
it can improve the performance for bulk write operations such as huge imports or the deletion of thousands of city objects.

It is also possible to change the delete rule of foreign keys from ON `DELETE NO ACTION` (use ‘a’ as input) to `ON DELETE
SET NULL` (‘n’) or `ON DELETE CASCADE` (‘c’). Switching the delete rule will remove and recreate the foreign key
constraint. The delete rule does affect the layout of automatically generated delete scripts as no explicit code is
necessary in case of cascading deletes. However, we do not recommend to change the behavior of existing foreign key
relationships because some delete operations might not work properly anymore.

| Function                                                                                                                                                                                   | Explanation                                                           |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------|
| **`set_enabled_fkey`**<br/>`(fkey_trigger_oid OID, enable BOOLEAN DEFAULT TRUE)`                                                                                                           | Enables or disables a given foreign key constraint                    |
| **`set_enabled_geom_fkeys`**<br/>`(enable BOOLEAN DEFAULT TRUE, schema_name TEXT DEFAULT 'citydb')`                                                                                        | enables/disables references to `GEOMETRY_DATA` table                  |
| **`set_enabled_schema_fkeys`**<br/>`(enable BOOLEAN DEFAULT TRUE, schema_name TEXT DEFAULT 'citydb')`                                                                                      | enables/disables all foreign keys in a given schema                   |
| **`set_fkey_delete_rule`**<br/>`(fkey_name TEXT, table_name TEXT, column_name TEXT, ref_table TEXT, ref_column TEXT, on_delete_param CHAR DEFAULT 'a', schema_name TEXT DEFAULT 'citydb')` | Removes a constraint to add it again with given `ON DELETE` parameter |
| **`set_schema_fkeys_delete_rule`**<br/>`(on_delete_param CHAR DEFAULT 'a', schema_name TEXT DEFAULT 'citydb')`                                                                             | updating all the constraints in the specified schema                  |
