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
- There must be only one User mode monitor resource.
- The name of userw must be "userw".
- The cluster where lankhb and lanhb are mixed is not supported.

## How to use `ConvertToUserModeCluster.sh`
1. Install xmlstarlet.

    ```sh
    $ yum -y install xmlstarlet
    ```
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
1. Suspend the cluster

    ```
    $ clpcl --suspend
    ```
1. Restart InformationBase service. **(If ECX version is 4.2 or later)**

    ```
    $ clpcl -r --ib
    ```
1. Restart WebManager service.

    ```
    $ clpcl -r --web
    ```
1. Resume the cluster.

    ```
    $ clpcl --resume
    ```