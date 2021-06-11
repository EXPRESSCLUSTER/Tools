# How to perform CPU load test with EXPRESSCLUSTER
## Overview
When you perform CPU load test with EXPRESSCLUSTER, please follow this article.

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
You can re-produce userw monitor tieout by making CPU high load with Micorosoft CpuStres.
About CpuStres, please refer "[Reference](https://github.com/EXPRESSCLUSTER/Tools/blob/master/HowToReproduceUserwTimieout_en.md#reference)"

### System Requirements 
- CPU 1 (1 Core)
- Memory 4GB
- Windows Server 2016
- EXPRESSCLUSTER X 4.3 for Windows

### Procedure
1. Edit userw timeout:
   - Default 300 seconds -> 30 seconds
2. Download and launch CpuStres.
3. Change the CpuStres settings as follows:
   - Theread number: 4 (default)
    - In the case you want to increase thread for higer load: Process-> Create Thread
   - Allocate all threads to CPU:
    - Select each thread-> Thread-> Ideal CPU-> Select CPU
   - Maximize the Activity Level of all threads:
    - Select all threads-> Thread-> Activity Level-> Maximum (100%)
   - Maximize Priority for all threads:
    - Select all threads-> Thread-> Priority-> Time Critical (+ Sat)
   - Make all threads Active:
    - Select all threads Thread-> Activate
4. If userw timeout error does not occur, re-run CpuStres with changing the settings as follows:
   - Chenge userw timeout more smaller.
   - Increase the threads number of CpuStres.

### Note
 - In order to make all cores high load, theread number should be larger than CPU core number.
 - Therefore, plese increse thread number in the case of multi core environment.
   - In the case of 2 CPU for 4 cores (2 cores / CPU)
 		- E.g. 1) Create 4 threads
			- Allocate 2 threads to CPU 0 (1 thread / core)
			- Allocate other 2 threads to CPU 1 (1 thread / core)
		- E.g. 2) Create 8 threads
			- Allocate 4 threads to CPU 0 (2 threads / core)
			- Allocate other 4 threads to CPU 1 (2 threads / core)

### Reference
[Microsoft CpuStres v2.0 Introduction](https://docs.microsoft.com/ja-jp/sysinternals/downloads/cpustres)
