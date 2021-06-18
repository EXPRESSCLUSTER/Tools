# ユーザ空間監視リソースの異常検知再現方法
## はじめに
- 本ガイドは、CLUSTERPRO X 4.3 でユーザ空間監視リソース（userw）に異常を検知させることができる負荷テストを紹介します。
- CLUSTERPRO X の詳細については、[こちら](https://jpn.nec.com/clusterpro/clpx/index.html)をご参照ください。

## Linux 環境の場合
- stress-ngコマンドを用いてCPU負荷をかけることで、 userw に異常検知させることができます。

### 動作環境
Hyper-V上の仮想マシンを使用。
- CentOS7.5
- CPU １(1 Core)
- Memory 2GB
- CLUSTERPRO X 4.3 for Linux

### 負荷テスト手順
1. stress-ng コマンドのインストールする
- [root@server ~]# yum -y install epel-release
- [root@server ~]# yum -y install stress-ng
	
2. コマンドを実行する
-  [root@server ~]# stress-ng -c 4 -t 5m --taskset 0 --sched rr --sched-prio 1
	
	- -cオプション：stress-ngのプロセス数を指定。私は1つだと不十分に負荷であったため、4にしました。
	 - -tオプション：実行時間を指定
	 - --tasksetオプション：CPUを指定
	 - --schrd：スケジューリングポリシー
	 - --sched-prio：優先度。1に指定しておかないとほかのプロセスが邪魔する場合があるため1推奨

3. コマンドを実行してもuserwに異常が起きない場合
	- userwのログを見てuserw_keepalive Maxprogress timeを探す。ない場合は負荷があまりかかっていない状態をなのでオプションの引数を変更する。 
	- WebUIにてuserwリソースのタイムアウトを低く設定し、コマンドの実行時間を長くする。
	
### 参考情報
- [stress-ngコマンドの使い方](https://qiita.com/hana_shin/items/0a3a615274717c89c0a4)
- [Stress Test CPU and Memory (VM) On a Linux / Unix With Stress-ng](https://www.cyberciti.biz/faq/stress-test-linux-unix-server-with-stress-ng/)

## Windows 環境の場合
- Micorosoft の CpuStres ツールを用いてCPU負荷をかけることで、 userw に異常検知させることができます。

### 動作環境
- CPU 1 (1 Core)
- Memory 4GB
- Windows Server 2016
- CLUSTERPRO X 4.3 for Windows

### 負荷テスト手順
1. クラスタの構成で、userw のタイムアウトを短くします。
	- 既定値 300 秒 → 30 秒
1. CpuStres をダウンロードし、起動します。
1. CpuStres の設定を以下の通り変更します：
	- スレッド数は既定値 (4 スレッド) のままにします。
		- スレッドを増やす場合は Process -> Create Thread
	- 全スレッドを CPU に割り当てます：
		- 各スレッドを選択 -> Thread -> Ideal CPU -> 割り当てる CPU 選択
	- 全スレッドの Activity Level を最大にします：
		- 全スレッドを選択 -> Thread -> Activity Level -> Maximum (100%)
	- 全スレッドの Priority を最大にします：
		- 全スレッドを選択 -> Thread -> Priority -> Time Critical (+Sat)
	- 全スレッドを Active にします：
		- 全スレッドを選択 Thread -> Activate
1. userw が異常検知しない場合は、以下の通り再設定し、CpuStres を再実行します：
	- userw のタイムアウトをさらに短くする
	- CpuStres のスレッド数を増やす

### 注意
- スレッド数は CPU コア数より多い必要があるので、コア数が多い環境ではスレッド数も増やします。
- 各 CPU にはコア数以上のスレッドが割当たっている必要があります。
	- 2CPU 4コア (2コア/CPU) の場合
		- 例 1: 4 スレッド作成
			- 2 スレッドを CPU 0 に割り当て (1スレッド/コア)
			- 2 スレッドを CPU 1 に割り当て (1スレッド/コア)
		- 例 2: 8 スレッド作成
			- 4 スレッドを CPU 0 に割り当て (2スレッド/コア)
			- 4 スレッドを CPU 1 に割り当て (2スレッド/コア)

### 参考情報
- [Microsoft CpuStres v2.0 Introduction](https://docs.microsoft.com/ja-jp/sysinternals/downloads/cpustres)
