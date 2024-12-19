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

---

## Why Use CQL2?

CQL2 can be used with commands like `export` and `delete` to:

- Query specific features based on **attribute values** (e.g., height, name, or year).
- Apply **logical filters** using `AND`, `OR`, and `NOT`.
- Use **spatial queries** (e.g., features within bounding boxes or intersecting geometries).
- Combine multiple conditions for highly targeted queries.


---

## CQL2 Syntax Overview

CQL2 syntax is easy to read and write, consisting of:

- **Attribute comparisons**: Use operators like `=`, `<`, `>`, `>=`, `<=`, `!=`.
- **Logical operators**: Combine filters with `AND`, `OR`, and `NOT`.
- **Spatial filters**: Use spatial operators like `INTERSECTS`, `WITHIN`, or `BBOX`.
---

## Supported Operators in CQL2

| Type               | Operator             | Description                                 | Example                          |
|---------------------|----------------------|---------------------------------------------|----------------------------------|
| **Comparison**      | `=`                  | Equals                                      | `height = 20`                    |
|                     | `!=`                 | Not equal                                   | `name != 'Park'`                 |
|                     | `<`, `>`, `<=`, `>=` | Less than, greater than, or equal conditions| `year_of_construction >= 2000`   |
| **Logical**         | `AND`, `OR`, `NOT`   | Combine or negate conditions                | `height > 20 AND name = 'Tower'` |
| **Spatial**         | `BBOX`               | Filter features within a bounding box       | `BBOX(geometry, 10, 20, 30, 40)` |
|                     | `INTERSECTS`         | Filter features that intersect a geometry   | `INTERSECTS(geometry, Polygon)`  |
|                     | `WITHIN`             | Filter features fully within a geometry     | `WITHIN(geometry, Region)`       |

---

## How to Use CQL2 in CityDB Tool

CQL2 can be passed as a query filter with the `--filter` option in commands like **`export`** and **`delete`**.

## Examples of CQL2 Queries

### Filtering by Attribute Values

To export only features where the name is 'Forest tree 3':

```bash
citydb export citygml --filter="name = 'Forest tree 3'" -o filtered_tree.gml
```

### Filter by Date

To delete features that are entirely above terrain:

```bash
citydb delete -f "relativeToTerrain = 'entirelyAboveTerrain'" @options.txt
```



