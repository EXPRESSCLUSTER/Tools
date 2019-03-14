# How to update UM8700 which is clustered
## Overview
When updating UM8700 which is clustered by EXPRESSCLUSTER, please follow the Procedure of this article.
Since UM8700 binary is stored on Mirror Disk, updating should be done on Active Server. This means that rolling update is impossible for this configuration.
And updated UM8700 binary is mirrored to Standby Server, 
(But it shuold be evaluated.)

## Assumption
- UM8700 Cluster is created by following the procedure which Ogata san provided.
- No errors on the cluster.
- Failover group is activated on Primary Server.
- Data on both servers are synchronized.

## Procedure
1. Execute [UM8700beforeUpdate.ps1](https://github.com/EXPRESSCLUSTER/Tools/blob/master/scripts/UM8700beforeUpdate.ps1) on Active Server and follow it.
2. Update UM8700 by following its update procedure
3. Execute [UM8700afterUpdate.ps1](https://github.com/EXPRESSCLUSTER/Tools/blob/master/scripts/UM8700afterUpdate.ps1) on Active Server and follow it.  
    \# If OS is rebooted in step 2, please wait for cluster service started, then execute the script.

## Detail
### UM8700beforeUpdate.ps1
The following operation is executed in the script.
1. Check cluster service is started on Primary Server. If not, the script is exitted.
2. Check the script is executed on Primary (Active) Server. If not, the script is exitted.
3. Check the data is synchronized. If not, the script is exitted.
4. Check Secondary Server is started. If not, the script is exitted.
5. Stop Secondary Server cluster service to avoid failover while updating UM8700.  
    If stopping is failed, the script is exitted.
6. Stop failover group to stop UM8700 application and configuration changes below.
7. Backup the cluster configuration.
8. Remove md resource (Mirror Disk) and regsync (Registry synchronization) resource from the cluster configuration.  
    Please refer [Supplement](https://github.com/EXPRESSCLUSTER/Tools/blob/master/HowToUpdateUM8700withCluster.md#supplement) for more detail.
9. Apply the removal to the cluster. Cluster suspend and resume will also occur to apply the config.
10. Stop Secondary Server cluster service to disable failover while updating UM8700.
### UM8700afterUpdate.ps1
The following operation is executed in the script.
1. Check cluster service is started on Primary Server. If not, the script is exitted.
2. Start Secondary Server cluster service which is stopped in UM8700beforeUpdate.ps1.
3. Restore the configuration, which is backed up before removing md and regsync resources, to re-add them.
4. Apply the re-adding to the cluster. Cluster suspend and resume will also occur to apply the config.
5. Start failover group on Primary Server. Then Mirroring from Primary to Secondary occurs automatically.
6. Check Mirroring is completed.
7. Remove backed up configuration.

## Supplement
### About Mirror Disk
Mirror Disk is accesible on Active Server while md resource is activated.
If cluster service is started, with some trick, there is a way to access to Mirror although md resource is not activated.
However, there is no way to access while cluster service is stopped.
(This is because to control Mirror Disk I/O by the cluster for Mirror Disk replication.)

This means that after OS is booted and before cluster service is started, we cannot access to Mirror Disk.
To avoid that, we should delay the timing to access to Mirror Disk.
Or we shuold remove md resource once to make Mirror Disk always accessible, then re-add it and execute initial synchronization from Primary to Secondary.
That's the reason why md resource is remove in [UM8700beforeUpdate.ps1](https://github.com/EXPRESSCLUSTER/Tools/blob/master/HowToUpdateUM8700withCluster.md#um8700beforeupdateps1).
(If we can make the timing to delay, we don't have to remove the resource.)

### About Registry Sync
This resource replicate changes on target registries from Active Server to Standby Server.
If any changes are made on target registries while the resource is not activated, it will not replicated to Stanby Server.

This means that any changes on the target registried after OS is booted and before regsync resource is started will be lost by failing over from Primary to Secondary.
To avoid that, we should delay the timing to change.
Or we shuold remove regsync resource once, then re-add md resource and execute initial synchronization from Primary to Secondary.
That's the reason why regsync resource is remove in [UM8700beforeUpdate.ps1](https://github.com/EXPRESSCLUSTER/Tools/blob/master/HowToUpdateUM8700withCluster.md#um8700beforeupdateps1).
(If we can make the timing to delay, we don't have to remove the resource.)
