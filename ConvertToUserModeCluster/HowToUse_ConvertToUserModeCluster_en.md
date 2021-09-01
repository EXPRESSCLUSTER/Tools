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

1. If you use EXPRESSCLUSTER X 4.2, download clpcfset from the following link, and save it to the same path with `ConvertToUserModeCluster.sh`.

    https://github.com/EXPRESSCLUSTER/CreateClusterOnLinux/releases

1. If you use EXPRESSCLUSTER X 4.3 or later, replace `./clpcfset` with `clpcfset` in `ConvertToUserModeCluster.sh` with text editor.
1. Copy `clp.conf` to the same path as `ConvertToUserModeCluster.sh`.
1. Execute `ConvertToUserModeCluster.sh`.

    e.g.
    ```
    $ ./ConvertToUserModeCluster.sh
    Converted lankhb to lanhb.
    Converted userw monitoring method to softdog.
    Converted Shutdown Monitor method to softdog.
    ```
1. Suspend the cluster

    ```
    $ clpcl --suspend
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
1. Restart ECX services.

    In case that ECX version is 4.2 or later
    ```
    $ clpcl -r --ib --web --alert
    ```
    In case that ECX version is older than 4.2
    ```
    $ clpcl -r --web --alert
    ```
1. Resume the cluster.

    ```
    $ clpcl --resume
    ```
1. Confirm that cluster settings has been changed.
    
    **Type** of heartbeat resources are **lanhb**.
    ```
    # clpstat --hb
    =======================  CLUSTER INFORMATION  =======================
    [HB0 : lanhb1]
      Type                                                   : lanhb
      Comment                                                : LAN Heartbeat
    =====================================================================
    ```
    
    **Method** of the User mode monitor resource is **softdog**.
    ```
    # clpstat --mon userw
    =======================  CLUSTER INFORMATION  =======================
    [Monitor5 : userw]
        Type                                                     : userw
        Comment                                                  :
        Method                                                   : softdog
        Use HB interval and timeout                              : On
    =====================================================================
    ```

    **Method** of Shutdown monitoring method in the cluster property is **softdog**.
    ```
    # clpstat --cl --detail | grep "Shutdown Monitoring Method"
        Shutdown Monitoring Method                               : softdog
    ```