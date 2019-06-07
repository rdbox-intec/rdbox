# RDBOX (A Robotics Developers BOX)
[English Page Here.](https://github.com/rdbox-intec/rdbox/blob/master/README.md)

[![Github Release](https://img.shields.io/github/release/rdbox-intec/rdbox.svg)](https://github.com/rdbox-intec/rdbox/releases)

**OSI参照モデルのすべての層（L1からL7）を提供する** 、オープンソースのIoT / Roboticsプラットフォームです。。

:point_down:「ネットワークとコンピュータのグループ」は、自動的に構築され、自動的に維持されます。:point_down:

<div align="center">
<img src="./images/you_can_easily_make_by_rdbox.png" title="./images/you_can_easily_make_by_rdbox.png" width=720px></img>
</div>

あなた専用の、 **メッシュWi-Fiネットワークで覆われた空間** 及び、 **ロボットとIoT用に最適化された [Kubernetesコンピュータクラスタ](https://kubernetes.io/)** によって提供される計算資源を得ることができます。

他の「ロボット開発プラットフォーム」は、オンサイトネットワークおよびコンピュータ管理までのタスクはサポートしていません。しかし、本来この部分は非常に難易度が高く、導入・維持に時間を要するものです。

これらは、仮想マシン（[VirtualBox](https://www.virtualbox.org/) or [AWS](https://aws.amazon.com/jp/)）と[Raspberry Pi](https://www.raspberrypi.org/)に対して、 **2通りの操作（Run Script & Burn SDCard）** をするだけで簡単に取得できます。

## 導入方法
<img src="./images/prepare_by_you_of_rdbox.png" title="../images/prepare_by_you_of_rdbox.png" width=600px>

まずは、[最新のリリースノート](https://github.com/rdbox-intec/rdbox/releases)も参照してください。

RDBOXを試す場合は、[Wiki](https://github.com/rdbox-intec/rdbox/wiki/Home-ja)をチェックしてください。（日本語、英語の二ヶ国語対応。）

RDBOXは、小さな投資から始めて徐々に規模を拡大することが可能なアーキテクチャです。
* 私たちのユーティリティの一つ、[flashRDBOX](https://github.com/rdbox-intec/flashRDBOX)は、RaspberryPiへの対話型依存性注入（DI）を可能にします。 難しい操作は必要ありません。
* [TurtleBot3](http://emanual.robotis.com/docs/en/platform/turtlebot3/overview/)を所有している場合は、ROSアプリケーションの配置を含めた全てのチュートリアルを体験できます。
* [TurtleBot3](http://emanual.robotis.com/docs/en/platform/turtlebot3/overview/)を所有していない場合でも、RDBOXで開発環境を構築するための手順を学ぶことができます。

## RDBOXの特徴
あなたのプロジェクトの負荷を軽減する、 **3つの特徴**



### 1.「ROSロボット」を実行しているすべてのリソースを柔軟にコントロールします。
* ユーザは、今までの[roslaunch](http://wiki.ros.org/roslaunch)でアプリを展開するよりも簡単で創造的な開発経験を得るでしょう。 roslaunchよりも多くのロボット（群ロボット）を制御することが容易になります。
* Kubernetesによって、「ロボット上のROSノード」と「コンピュータリソース」を統合します。
    - **同一クラスタ内にx86とARMアーキテクチャのCPUを混在させることができます。**
    - 「Kubernetes Master」はAWS EC2または、あなたのPC上のVirtualBoxで実行されます。
* [メッシュWi-Fiネットワーク](https://www.open-mesh.org/projects/open-mesh/wiki) でロボットやその他IoT機器とを相互に接続します。
* [VPN Network](https://github.com/SoftEtherVPN/SoftEtherVPN_Stable)でクラウド上のコンピュータ郡/オンプレミスのコンピュータ郡/現場のロボットを相互に接続します。

![RDBOX_SHOW.gif](./images/RDBOX_SHOW.gif "show")

### **2. 自分で作ることができる!!**
* RDBOX Edgeデバイスは「Raspberry Pi 3B / 3B+」で作ることが出来ます。
* バックポートがインストールされる心配はありません。（すべてのソースコードとハードウェア組み立て手順が、我々のリポジトリで公開されています。）
* 「Raspberry Pi 3B / 3B+」はユーザにエッジ・コンピューティングとのWi-Fiネットワークと環境センサーなどを提供します。
* 組み立て手順と、RDBOX-Edge用SDカードイメージ（Raspbian Stretchベース）を提供します。

![parts_of_edge.jpeg](./images/parts_of_edge.jpeg "parts")

### **3. 高度なネットワーク接続**
* ロボット専用のローカルエリアネットワークを簡単に設定できます。
    - ユーザは、インターネットとサービスロボットの間にRDBOX-Edgeを接続するだけです。 簡単なステップで、ローカルエリアネットワークと開発環境を構築できます。 インターネットやネットワーキングに関する知識は必要ありません。
* NTP/DNS/DHCPを含む多くのネットワークアプリケーションがプリインストールされています。 ネットワークロボットの管理自動化に寄与します。
* 必要なのは電源だけです。 移動ロボットの移動範囲全体をWi-Fiネットワークでカバーします。

![RDBOX_FETURES.gif](./images/rdbox_fetures.png "fetures")


## 他のロボットプラットフォームと比較して
他の「ロボット開発プラットフォーム」と比較して **3つの利点** があります。

### 1. RDBOXは、OSI参照モデルのすべての層（L1からL7）を提供します。
* 他の「ロボット開発プラットフォーム」はそれをサポートしていません。 あなたは問題解決のために専門家に多額のお金を払う必要があるかもしれません。
   - RDBOX-Edgeは、メッシュWi-Fi経由でアクセスポイントを提供します。サービスロボットやIoT機器はそのアクセスポイントに接続するだけです。
   - VPNやファイアウォールなどのセキュリティ対策や、ネットワークアプリケーションなどの便利な機能を手に入れることが可能です。
### 2. RDBOXは市販の機器で作ることができます。
* ユーザはすでに持っているかもしれない、「ラップトップ」と「Raspberry Pi3B / 3B+」でRDBOXによる最新の開発スタイルを使い始めることができます。
### 3. RDBOXは他社のロボット開発プラットフォームの優れた点を取り入れて使うことが出来ます。
* 他社が得意とする「シミュレータ連携」と「既存のAPIサービス」を組み合わせて利用できます。
   - 物体認識等のAPI
   - Gazeboと連携した強化学習
   - などなど


## コンポーネント

### 我々が管理しているコンポーネント
* [flashRDBOX](https://github.com/rdbox-intec/flashRDBOX)
   - SDカードにSD画像ファイルを書き込むためのRDBOXコマンドツール。
* [go\-transproxy](https://github.com/rdbox-intec/go-transproxy)
   - HTTP、HTTPS、DNS、およびTCP用の透過プロキシサーバー。
* [rdbox\-middleware](https://github.com/rdbox-intec/rdbox-middleware)
   - RDBOX用のミドルウェア
* [image\-builder\-rpi](https://github.com/rdbox-intec/image-builder-rpi)
   - Dockerプリインストール済みのRaspberryPiのSDカードイメージ：HypriotOS

### 第三者が管理しているコンポーネント
* [hostapd](https://salsa.debian.org/debian/wpa)
   - hostapdは、IEEE 802.11 APおよびIEEE 802.1X / WPA / WPA2 / EAP / RADIUSオーセンティケーターです。
   - [我々独自のパッチを適用しています。](https://github.com/rdbox-intec/softether-patches)
* [SoftEtherVPN\_Stable](https://github.com/SoftEtherVPN/SoftEtherVPN_Stable) 
   - オープンクロスプラットフォームマルチプロトコルVPNソフトウェア。
   - [我々独自のパッチを適用しています。](https://github.com/rdbox-intec/wpa-patches)
- [bridge\-utils](https://git.kernel.org/pub/scm/linux/kernel/git/shemminger/bridge-utils.git/)
   - Linuxイーサネットブリッジを設定するためのユーティリティ。
- [dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html)
   - 小規模ネットワーク用のネットワークサービス。
- [nfs](http://nfs.sourceforge.net/)
   - NFSカーネルサーバーのサポート。
- など

## Licence
Licensed under the [MIT](/LICENSE) license.
