| Option                                                                   | Description                                                               | Default value |
|--------------------------------------------------------------------------|---------------------------------------------------------------------------|---------------|
| `-t`, <code>--type-name=<[prefix:]name><br/>[,<[prefix:]name>...]</code> | Names of the features to process.                                         |               |
| `-i`, `--id=<id>[,<id>...]`                                              | Identifiers of the features to process.                                   |               |
| `-b`, <code>--bbox=&lt;x_min,y_min,x_max,y_max<br/>[,srid]></code>       | Bounding box to use as spatial filter.                                    |               |
| `--bbox-mode=<mode>`                                                     | Bounding box mode: `intersects`, `contains`, `on_tile`.                   | `intersects`  |
| `--limit=<count>`                                                        | Maximum number of features to process.                                    |               |
| `--start-index=<index>`                                                  | Index within the input set from which features are processed.             |               |
