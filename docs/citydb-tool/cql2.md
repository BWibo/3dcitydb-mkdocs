---
title: CQL2 Query Language
subtitle: Filtering and Querying Data with CQL2
description:
# icon: material/filter
status: wip
---

# CQL2 Query Language

**CQL2** (Common Query Language 2) is an advanced query language used to filter and query spatial and attribute 
data within the **3DCityDB Tool**. It allows users to define precise queries for exporting or deleting features 
based on attribute values, spatial properties, or logical conditions.

CQL2 is a standard maintained by the **OGC (Open Geospatial Consortium)** and serves as an evolution of the 
original CQL language, providing better expressiveness and flexibility for data filtering.

Key Features of CQL2

- Expressive Syntax: Combines logical operators with a rich set of functions for building complex queries.
- Spatial Filtering: Supports geospatial functions to filter data based on spatial relationships.
- Ease of Use: Simple, human-readable expressions that are easy to construct and interpret.

---

## Using CQL2 with CityDBTool

CityDBTool allows the use of the -f or --filter option followed by a CQL2 expression to filter data when exporting or 
deleting records. This enables users to select only the relevant subset of data based on attribute values, 
spatial conditions, or both.

## Syntax

The general syntax for using CQL2 with CityDBTool is:

```bash
citydb [command] -f "<CQL2 Expression>"
```

Where `<CQL2 Expression>` is a valid CQL2 query that defines the filtering conditions for the data export.

## Writing CQL2 Expressions

A CQL2 expression consists of attribute names, operators, and values. It can also include spatial 
functions to handle geospatial conditions. 

### Attribute Filtering

Filter based on attribute values using comparison operators such as =, !=, <, <=, >, and >=. Logical operators 
AND, OR, and NOT can be used to combine conditions.

#### Example

```bash
citydb export citygml --filter="name = 'Forest tree 3'" -o filtered_tree.gml
```

### Spatial Filtering

Use spatial functions to filter based on the spatial relationship of geometries. Commonly used functions include:

- `intersects`: Returns true if two geometries intersect.
- `contains`: Returns true if one geometry contains another.
- `within`: Returns true if one geometry is within another.



