

# How to perform CPU load test which is clustered
## Overview
When you perform CPU load test with CLUSTERPRO, please follow this article.

## Linux
You can inspection user mode monitor resources (called userw) detect "Abnormal" by applying CPU load using stress-ng.

### system requirements 
- OS CentOS 7.5
- Number of CPUs 1
- Memory 2GB
- EXPRESSCLUSTER X 4.3 for Windows

### Detail
1. Installing the stress-ng 
 - [root@server ~]# yum -y install epel-release
 - [root@server ~]# yum -y install stress-ng
2. Example of running a command
 - [root@server ~]# stress-ng -c 4 -t 5m --taskset 0 --sched rr --sched-prio 1
   - -c：Specify the number of stress-ng processes. I chose "4" because "1" wasn't enough load.
   - -t：Specify execution time
   - --taskset：Specify CPU
   - --schrd：scheduling policy
   - --sched-prio：If you don't specify "1", other processes may interfere. So "1" is recommended.
3. If userw doesn't fail even after running the command, look at the userw log for "userw_keepalive Maxprogress time". If it is not found, it means that the load isn't so much applied, so change the optional argument.
Set the userw resource timeout low in the WebUI to increase the execution time.

### Reference information
[How to use the stress-ng command](https://qiita.com/hana_shin/items/0a3a615274717c89c0a4) 

[Stress Test CPU and Memory (VM) On a Linux / Unix With Stress-ng](https://www.cyberciti.biz/faq/stress-test-linux-unix-server-with-stress-ng/)


## Windows

You can inspection userw detect "Abnormal" by applying CPU load using Micorosoft's CpuStres tool.

### system requirements 
- CPU 1 (1 Core)
- Memory 4GB
- Windows Server 2016
- EXPRESSCLUSTER X 4.3 for Windows

### Detail
1. Reduce userw timeouts in cluster configurations.
Default value 300 seconds → 30 seconds
2. Download and launch CpuStres.
3. Change the CpuStres settings as follows:
   - Leave the default number of threads (4 threads).
   - Process-> Create Thread to increase threads
   - Allocate all threads to CPU:
   - Select each thread-> Thread-> Ideal CPU-> Select CPU to assign
   - Maximize the Activity Level of all threads:
   - Select all threads-> Thread-> Activity Level-> Maximum (100%)
   - Maximize Priority for all threads:
   - Select all threads-> Thread-> Priority-> Time Critical (+ Sat)
   - Make all threads Active:
   - Select all threads Thread-> Activate
   - If userw does not detect anomaly, reconfigure as follows and rerun CpuStres:
   - Make userw timeouts even shorter
   - Increase the number of threads in CpuStres
4. Note
 - Since the number of threads must be larger than the number of CPU cores, increase the number of threads in an environment with a large number of cores.Each CPU must be assigned at least as many threads as there are cores.
   - 2CPU For 4 cores (2 cores / CPU)
   - Example 1: 4 Thread creation
   - Allocate 2 threads to CPU 0 (1 thread / core)
   - Allocate 2 threads to CPU 1 (1 thread / core)
   - Example 2: 8 Thread creation
   - Allocate 4 threads to CPU 0 (2 threads / core)
   - Allocate 4 threads to CPU 1 (2 threads / core)

### Reference
[Microsoft CpuStres v2.0 Introduction](https://docs.microsoft.com/ja-jp/sysinternals/downloads/cpustres)

