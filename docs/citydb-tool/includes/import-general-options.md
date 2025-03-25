| Option                                                      | Description                                                                                                    | Default value |
|-------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------|---------------|
| `<file>...`                                                 | One or more files and directories to process (glob patterns allowed).                                          |               |
| `--input-encoding=<encoding>`                               | Encoding of input file(s).                                                                                     |               |
| `--fail-fast`                                               | Fail fast on errors.                                                                                           |               |
| `--temp-dir=<dir>`                                          | Store temporary files in this directory.                                                                       |               |
| `-m`, `--import-mode=<mode>`                                | Import mode: `import_all`, `skip`, `delete`, `terminate`.                                                      | `import_all`  |
| `--threads=<threads>`                                       | Number of threads to use for parallel processing.                                                              |               |
| `--preview`                                                 | Run in preview mode. Features will not be imported.                                                            |               |
| `--index-mode=<mode>`                                       | Index mode: `keep`, `drop`, `drop_create`. Consider dropping indexes when processing large quantities of data. | `keep`        |
| `--compute-extent`                                          | Compute and overwrite extents of features.                                                                     |               |
| <code>--transform=&lt;m0,m1,...,m11&#124;swap-xy&gt;</code> | Transform coordinates using a 3x4 matrix in row-major order. Use `swap-xy` as a shortcut.                      |               |
