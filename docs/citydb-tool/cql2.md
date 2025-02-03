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

CityDBTool allows the use of the `-f` or `--filter` option followed by a CQL2 expression to filter data when exporting or
deleting records. This enables users to select only the relevant subset of data based on attribute values,
spatial conditions, or both.

**Two Encodings for CQL2**
1. **Text-based (string) encoding**
2. **JSON-based encoding**

Both encodings are supported by CityDBTool, giving you flexibility in how you structure your filters.

## Syntax

The general syntax for using CQL2 with CityDBTool is:

```bash
citydb [command] -f "<CQL2 Expression>"
```

Where `<CQL2 Expression>` is a valid CQL2 query that defines the filtering conditions for the data export.

## Writing CQL2 Expressions

A CQL2 expression consists of attribute names, operators, and values. It can also include spatial functions to handle geospatial conditions.

### Understanding Literals
In CQL2, literals are direct values that appear in your filter expressions. Common types of literals include:

- Strings: Enclosed in single quotes in text-based queries (e.g., \`'Forest tree 3'\`), or as JSON strings in JSON-based queries (e.g., \`"Forest tree 3"\`).
- Numbers: Used without quotes in both text-based and JSON-based queries (e.g., \`> 10\` or \`10\` in JSON).
- Booleans: Typically represented as \`true\` or \`false\`.
- Dates/Times: Represented in ISO-8601 format (e.g., \`'2023-01-31'\` or \`"2023-01-31"\` in JSON), if your data or schema supports date/time attributes.

### Attribute references

#### Implicit vs. Explicit Attribute References

When writing CQL2 queries, it's important to correctly reference attributes by their full property names rather than 
relying on implicit assumptions. While some query tools allow shorthand notations for convenience, 
the proper CQL2 syntax requires explicit attribute references.

For example, in some cases, a query like:

```bash
citydb export citygml --filter="height > 1"
```

might work as expected, but it is actually a simplified form. The correct way to reference attributes in CQL2 is to 
specify the full property path. In this case, the attribute height belongs to the bldg (building) namespace. 
The correct query should be:

```bash
citydb export citygml --filter="bldg.height > 1"
```

Similarly, for other attributes, always check the schema or model being used and ensure that you are specifying the 
correct namespace or object path.

Why Use Explicit Attribute Names?
Avoids Ambiguity: Some attributes may have the same name in different parts of the schema. Using full names ensures clarity.
Ensures Compatibility: Different versions of CityDB and its tools may change how shorthand references are handled. 
Explicit references ensure queries remain valid.
Better Integration with JSON Encoding: When using JSON-based CQL2 filters, explicit property references are always required.

JSON-based Equivalent
If you were to use the JSON-based representation, the correct way to write the same filter would be:

```json
{
  "op": ">",
  "args": [
    { "property": "bldg.height" },
    "1"
  ]
}
```

### Attribute Filtering

Filter based on attribute values using comparison operators such as =, !=, <, <=, >, and >=. Logical operators
AND, OR, and NOT can be used to combine conditions.

#### Basic Example
Text-based Filter
```bash
citydb export citygml --filter="name = 'Forest tree 3'" -o filtered_tree.gml
```

Json-based Filter
```json
{
  "op": "=",
  "args": [
    { "property": "name" },
    "Forest tree 3"
  ]
}
```

#### Combining with Logical Operators

Text-based Filter
```bash 
citydb export citygml --filter="name = 'Forest tree 3' AND height > '1'" -o filtered_tree.gml
```

Json-based Filter
```json
{
  "op": "AND",
  "args": [
    {
      "op": "=",
      "args": [
        { "property": "name" },
        "Forest tree 3"
      ]
    },
    {
      "op": ">",
      "args": [
        { "property": "height" },
        "1"
      ]
    }
  ]
}
```

#### Filtering with lists

Text-based Filter
```bash
citydb export citygml --filter="name IN ('Forest tree 1', 'Forest tree 2', 'Forest tree 3')" -o filtered_trees.gml
```

Json-based Filter
```json
{
  "op": "IN",
  "args": [
    { "property": "name" },
    ["Forest tree 1", "Forest tree 2", "Forest tree 3"]
  ]
}
```

### Spatial Filtering

Use spatial functions to filter based on the spatial relationship of geometries. Commonly used functions include:

- `intersects`: Returns true if two geometries intersect.
- `contains`: Returns true if one geometry contains another.
- `within`: Returns true if one geometry is within another.

#### Example

Text-based Filter
```bash
citydb export citygml --filter="S_INTERSECTS(Envelope, BBOX(-560.8678155819734, 604.1012795512906, -553.8099297783192, 627.1318523068805))" @options.txt -o=output.gml
```

Json-based Filter
```json
{
  "op": "func",
  "function": "S_INTERSECTS",
  "args": [
    { "property": "Envelope" },
    {
      "op": "func",
      "function": "BBOX",
      "args": [
        -560.8678155819734,
        604.1012795512906,
        -553.8099297783192,
        627.1318523068805
      ]
    }
  ]
}
```

