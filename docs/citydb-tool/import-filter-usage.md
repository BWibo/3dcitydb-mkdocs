#### Feature type filter

The `--type-name` option specifies one or more feature types to import. For each feature type, provide its type name as
defined in the [`OBJECTCLASS`](../3dcitydb/metadata-module.md#objectclass-table) table of the 3DCityDB `v5`. To avoid
ambiguity, you can use the namespace alias from the [`NAMESPACE`](../3dcitydb/metadata-module.md#namespace-table) table
as a prefix in the format `prefix:name`. Only features matching the specified type will be imported.

#### Feature identifier filter

The `--id` option enables filtering by one or more feature identifiers provided as a comma-separated list. Only features
with a matching `gml:id` value will be imported.

#### Bounding box filter

The `--bbox` option defines a 2D bounding box as a spatial filter using four coordinates for the lower-left and
upper-right corners. By default, the coordinates are assumed to be in the same CRS as the 3DCityDB instance. However,
you can specify the database SRID of the CRS as a fifth value (e.g., `4326` for WGS84). All values must be separated by
commas.

The bounding box filter is applied to the `gml:boundedBy` property of input features. The filter behavior is controlled
by the `--bbox-mode` option:

- `intersects`: Only features whose bounding box overlaps with the filter bounding box will be imported. This is the
  default mode.
- `contains`: Only features whose bounding box is entirely within the filter bounding box will be imported.
- `on_tile`: Only features whose bounding box center lies within the filter bounding box or on its left/bottom
  boundary will be imported. This mode ensures that when multiple filter bounding boxes are organized in a tile grid,
  each feature matches exactly one tile.

#### Count filter

The `--limit` option sets the maximum number of features to import. The `--start-index` option
defines the `0`-based index of the first feature to import. These options apply across all input files and can be used
separately or together to control the total number of features imported.

#### Appearance filter

The `--appearance-theme` option filters appearances based on their `<theme>`. You can specify
one or more themes as a comma-separated list. To filter appearances that have no theme property, use `none` as the value.
Only appearances associated with the specified themes will be imported. To exclude all appearances from the import,
use the `--no-appearances` option.