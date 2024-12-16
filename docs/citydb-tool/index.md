---
title: General
subtitle: General
description:
# icon: material/emoticon-happy
status: wip
---

## Todos

- What versions can be used with `citydb-tool`

## Intro

- What is `citydb-tool`?
- General capabilities
    - Filtering options
    - Indexing
    - ...

The citydb command-line interface for the 3D City Database provides several general options that can be used with any command. These options allow you to configure logging, load configuration files, manage plugins, and more.

## Usage

```bash
citydb [OPTIONS] COMMAND
```

## Options

| Option                        | Description                                                                 |
|-------------------------------|-----------------------------------------------------------------------------|
| `[@<filename>...]`            | One or more argument files containing options.                              |
| `--config-file=<file>`        | Load configuration from this file.                                          |
| `-L`, `--log-level=<level>`   | Log level: `fatal`, `error`, `warn`, `info`, `debug`, `trace` (default: `info`). |
| `--log-file=<file>`           | Write log messages to this file.                                            |
| `--pid-file=<file>`           | Create a file containing the process ID.                                     |
| `--plugins=<dir>`             | Load plugins from this directory.                                           |
| `--use-plugins=<plugin[=true\|false][,<plugin[=true\|false]...]` | Enable or disable plugins with a matching fully qualified class name (default: `true`). |
| `-h`, `--help`                | Show this help message and exit.                                            |
| `-V`, `--version`             | Print version information and exit.                                         |

### Example

To display the help message for the citydb tool, use the following command:

```bash
citydb --help
```

## Validate

## Env vars
