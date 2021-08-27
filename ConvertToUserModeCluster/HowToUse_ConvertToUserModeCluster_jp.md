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

1. クラスタ構成情報ファイル `clp.conf` を `ConvertToUserModeCluster.sh` と同じパスにコピーします。
1. `ConvertToUserModeCluster.sh` を実行します。

    実行例
    ```
    $ ./ConvertToUserModeCluster.sh
    Converted lankhb to lanhb.
    Converted userw monitoring method to softdog.
    Converted Shutdown Monitor method to softdog.
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
1. クラスタをサスペンドします。

    ```
    $ clpcl --suspend
    ```
1. CLUSTERPROの一部サービスを再起動します。

    CLUSTERPRO X 4.2 以降の場合
    ```
    $ clpcl -r --ib --web
    ```
    CLUSTERPRO X 4.1 以前の場合
    ```
    $ clpcl -r --web
    ```
1. クラスタをリジュームします。

    ```
    $ clpcl --resume
    ```