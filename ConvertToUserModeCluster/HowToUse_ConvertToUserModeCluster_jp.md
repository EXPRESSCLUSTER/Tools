# ConvertToUserModeCluster
## 概要

`ConvertToUserModeCluster.sh` は CLUSTERPRO のクラスタ構成情報ファイルからカーネルモジュールを必要とする機能を削除するためのツールです。

クラスタ構成情報ファイル内の以下の設定を変更します。
- カーネルモード LAN ハートビート -> LAN ハートビート
- keepalive -> softdog

### 動作確認済み環境
- CentOS Linux release 7.4.1708 (Core)
- CLUSTERPRO X 4.2 for Linux

### 制限事項
- userw の名前は "userw" でなければならない。
- lankhb と lanhb が混在するクラスタ構成情報ファイルには未対応。

## 使用方法
1. `ConvertToUserModeCluster.sh` を本スクリプトを実行するサーバに保存します。

    https://github.com/EXPRESSCLUSTER/Tools/blob/master/ConvertToUserModeCluster/ConvertToUserModeCluster.sh

1. CLUSTERPRO X 4.2 を使用している場合は、以下のリンクから clpcfset の実行ファイルをダウンロードし、`ConvertToUserModeCluster.sh`と同じパスに配置します。

    https://github.com/EXPRESSCLUSTER/CreateClusterOnLinux/releases

1. CLUSTERPRO X 4.3 以降を使用している場合は、`ConvertToUserModeCluster.sh`内の`./clpcfset`を`clpcfset`に置換します。
1. クラスタ構成情報ファイル `clp.conf` を `ConvertToUserModeCluster.sh` と同じパスにコピーします。
1. `ConvertToUserModeCluster.sh` を実行します。

    実行例
    ```
    $ ./ConvertToUserModeCluster.sh
    Converted lankhb to lanhb.
    Converted userw monitoring method to softdog.
    Converted Shutdown Monitor method to softdog.
    ```
1. クラスタをサスペンドします。

    ```
    $ clpcl --suspend
    ```
1. clpcfctrl コマンドで `clp.conf` を各サーバに配信します。

    `clp.conf` を Linux 上の Cluster WebUI を使用して保存した場合、またはクラスタから直接コピーした場合。
    ```
    $ clpcfctrl --push -l -x .
    ```
    `clp.conf` を Windows 上の Cluster WebUI を使用して保存した場合
    ```
    $ clpcfctrl --push -w -x .
    ```

1. CLUSTERPROの一部サービスを再起動します。

    CLUSTERPRO X 4.2 以降の場合
    ```
    $ clpcl -r --ib --web --alert
    ```
    CLUSTERPRO X 4.1 以前の場合
    ```
    $ clpcl -r --web --alert
    ```
1. クラスタをリジュームします。

    ```
    $ clpcl --resume
    ```
1. 以下のコマンドでクラスタの設定が変更されたことを確認します。

    ハートビートリソースの **Type** が **lanhb**である。
    ```
    # clpstat --hb
    =======================  CLUSTER INFORMATION  =======================
    [HB0 : lanhb1]
      Type                                                   : lanhb
      Comment                                                : LAN Heartbeat
    =====================================================================
    ```
    
    ユーザ空間モニタリソースの **Method** が **softdog** である。
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

    クラスタプロパティ シャットダウン監視の **Method** が **softdog** である。
    ```
    # clpstat --cl --detail | grep "Shutdown Monitoring Method"
        Shutdown Monitoring Method                               : softdog
    ```