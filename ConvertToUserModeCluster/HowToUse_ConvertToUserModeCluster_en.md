# How to use ConvertToUserModeCluster
## Overview

`ConvertToUserModeCluster.sh` converts an ECX configuration file to one that does not use kernel modules.

The converted points are
- Kernel mode LAN heartbeat -> LAN heartbeat
- keepalive -> softdog

### Tested environment
- CentOS Linux release 7.4.1708 (Core)
- EXPRESSCLUSTER X 4.2 for Linux

### Limitation
- The name of userw must be "userw".
- The cluster where lankhb and lanhb are mixed is not supported.

## How to use `ConvertToUserModeCluster.sh`
1. Copy `ConvertToUserModeCluster.sh` to a server where you want to execute this script.

    https://github.com/EXPRESSCLUSTER/Tools/blob/master/ConvertToUserModeCluster/ConvertToUserModeCluster.sh

1. Copy `clp.conf` to the same path as `ConvertToUserModeCluster.sh`.
1. Execute `ConvertToUserModeCluster.sh`.

    e.g.
    ```
    $ ./ConvertToUserModeCluster.sh
    Converted lankhb to lanhb.
    Converted userw monitoring method to softdog.
    Converted Shutdown Monitor method to softdog.
    ```
1. Apply the `clp.conf` to the cluster with clpcfctrl command.

    In case that `clp.conf` was created by WebUI on Linux machine, or pulled directly from the cluster
    ```
    $ clpcfctrl --push -l -x .
    ```
    In case that `clp.conf` was created by WebUI on Windows machine
    ```
    $ clpcfctrl --push -w -x .
    ```
1. Suspend the cluster

    ```
    $ clpcl --suspend
    ```
1. Restart ECX services.

    In case that ECX version is 4.2 or later
    ```
    $ clpcl -r --ib --web
    ```
    In case that ECX version is older than 4.2
    ```
    $ clpcl -r --web
    ```
1. Resume the cluster.

    ```
    $ clpcl --resume
    ```