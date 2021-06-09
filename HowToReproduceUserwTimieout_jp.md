
# stress-ngを用いたCPU負荷テスト
## はじめに
- 本ガイドは、CLUSTERPRO X 4.3 for Linux で stress-ngコマンドを使ってCPUに負荷をかけることでusewに異常をを起こすことができる負荷テストを紹介します。
- CLUSTERPRO X の詳細については、[こちら](https://jpn.nec.com/clusterpro/clpx/index.html)をご参照ください。



## 使用環境
Hyper-V上の仮想マシンを使用。
- OS　CentOS7.5
- CPU数　１

## 負荷テスト手順
1. stress-ng コマンドのインストール
- [root@server ~]# yum -y install epel-release
- [root@server ~]# yum -y install stress-ng
	
2. コマンドの実行例
-  [root@server ~]# stress-ng -c 4 -t 5m --taskset 0 --sched rr --sched-prio 1
	
	- -cオプション：stress-ngのプロセス数を指定。私は1つだと不十分に負荷であったため、4にしました。
	 - -tオプション：実行時間を指定
	 - --tasksetオプション：
	 - --schrd：rrポリシー
	 - --sched-prio：優先度。1に指定しておかないとほかのプロセスが邪魔する場合があるため1推奨

3. コマンドを実行してもuserwに異常が起きない場合
	- userwのログを見てuserw_keepalive Maxprogress timeを探す。ない場合は負荷があまりかかっていない状態をなのでオプションの引数を変更する。 
	- WebUIにてuserwリソースのタイムアウトを低く設定し、コマンドの実行時間を長くする。
	
## 参考情報
- [stress-ngコマンドの使い方](https://qiita.com/hana_shin/items/0a3a615274717c89c0a4)
- [Stress Test CPU and Memory (VM) On a Linux / Unix With Stress-ng](https://www.cyberciti.biz/faq/stress-test-linux-unix-server-with-stress-ng/)