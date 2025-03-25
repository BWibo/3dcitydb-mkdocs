| Option                                                   | Description                                                               | Default value |
|----------------------------------------------------------|---------------------------------------------------------------------------|---------------|
| `-t`, `--type-name=<[prefix:]name>[,<[prefix:]name>...]` | Names of the features to process.                                         |               |
| `-i`, `--id=<id>[,<id>...]`                              | Identifiers of the features to process.                                   |               |
| `-b`, `--bbox=<x_min,y_min,x_max,y_max[,srid]>`          | Bounding box to use as spatial filter.                                    |               |
| `--bbox-mode=<mode>`                                     | Bounding box mode: `intersects`, `contains`, `on_tile`.                   | `intersects`  |
| `--limit=<count>`                                        | Maximum number of features to process.                                    |               |
| `--start-index=<index>`                                  | Index within the input set from which features are processed.             |               |
| `--no-appearances`                                       | Do not process appearances.                                               |               |
| `-a`, `--appearance-theme=<theme>[,<theme>...]`          | Process appearances with a matching theme. Use `none` for the null theme. |               |
