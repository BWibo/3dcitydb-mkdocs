---
title: CQL2
subtitle: CQL2
description:
# icon: material/emoticon-happy
status: wip
---

CQL2 (Common Query Language 2) is an advanced query language used for filtering and retrieving geospatial data. It extends the original CQL (Common Query Language) by providing more sophisticated capabilities for querying geospatial datasets. CQL2 supports a wide range of operators and functions for constructing complex queries, including spatial and non-spatial filters.

## Examples

### Example 1: Filter by Attribute

To export features where the attribute building:height is greater than 50 meters:

```bash 
citydb export citygml -f "building:height > 50" -o output.gml
```

### Example 2: Spatial Filter

To export features within a specific bounding box:

```bash 
citydb export citygml -f "INTERSECTS(geometry, ENVELOPE(10, 20, 30, 40))" -o output.gml
```

