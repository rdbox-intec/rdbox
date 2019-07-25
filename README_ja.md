# RDBOX (A Robotics Developers BOX)
[English Page Here.](https://github.com/rdbox-intec/rdbox/blob/master/README.md)

[![CircleCI](https://circleci.com/gh/rdbox-intec/image-builder-rpi.svg?style=svg)](https://circleci.com/gh/rdbox-intec/image-builder-rpi)
[![Github Release](https://img.shields.io/github/release/rdbox-intec/rdbox.svg)](https://github.com/rdbox-intec/rdbox/releases)
<a href='https://bintray.com/rdbox/deb/rdbox-middleware?source=watch' alt='Get automatic notifications about new "rdbox-middleware" versions'><img src='https://www.bintray.com/docs/images/bintray_badge_color.png' width=25px></a>

RDBOXはROSロボットのためのITインフラストラクチャです。 これらはあなたのロボットのようにとてもスマートに動きます。

<div align="center">
<img src="./images/you_can_easily_make_by_rdbox.png" title="./images/you_can_easily_make_by_rdbox.png" width=720px></img>
</div>

OSI参照モデルのすべての層でアプリを保護します。

<div align="center">
<img src="./images/L1-L7.png" title="./images/L1-L7.png" width=720px></img>
</div>

ROS向けのインフラストラクチャは自動的に構築され自動的に維持されます。
* あなただけのITインフラを手に入れることができます。
   - OSI参照モデルの **すべての層（L1からL7）** を提供します。
   - **メッシュWi-Fiネットワークで覆われたスペース** by [Raspberry Pi](https://www.raspberrypi.org/)
   - **堅牢なセキュリティ**
   - **計算資源** by [Kubernetes computer clusters](https://kubernetes.io/)
   - **ROS APPsの展開と更新** by [Kubernetes computer clusters](https://kubernetes.io/)
* 現場で作業するロボットをサポートします。
   - 既存のエンタープライズネットワークの一部を分離し、安全・便利に使用することが可能です。
      - [SoftEtherVPN\_Stable](https://github.com/SoftEtherVPN/SoftEtherVPN_Stable) 
      - [go\-transproxy](https://github.com/rdbox-intec/go-transproxy)
   - 他のロボット開発プラットフォームは現場でのサポートが不十分です。

これらは**2つのターゲット**に対する操作だけで簡単に手に入ります。
* Virtual machine ([VirtualBox](https://www.virtualbox.org/) or [AWS](https://aws.amazon.com/jp/)). 
   - Run the Script!!
* [Raspberry Pi](https://www.raspberrypi.org/).
   - Burn the SDCARD Image!!!


## How to use
<img src="./images/prepare_by_you_of_rdbox.png" title="../images/prepare_by_you_of_rdbox.png" width=600px>

まずは、[最新のリリースノート](https://github.com/rdbox-intec/rdbox/releases)も参照してください。

**RDBOXを試す場合は、[Wiki](https://github.com/rdbox-intec/rdbox/wiki/Home-ja)をチェックしてください。（日本語、英語の二ヶ国語対応。）**

* Example) [Install VirtualBox](https://github.com/rdbox-intec/rdbox/wiki/setup-rdbox-hq-vb-1-install_tools-en)
   - 続きは [Wiki page](https://github.com/rdbox-intec/rdbox/wiki/setup-rdbox-hq-vb-2-prepare_virtual_machine-en)へ

   ```bash
   $ mkdir ${HOME}/git
   $ cd {HOME}/git
   $ git clone --depth 1 https://github.com/rdbox-intec/rdbox.git
   $ cd ${HOME}/git/rdbox/tutorials/setup-rdbox-hq-vb/conf
   $ cp -p rdbox-hq-vb.params.sample rdbox-hq-vb.params
   $ vi rdbox-hq-vb.params
   $ cd ${HOME}/git/rdbox/tutorials/setup-rdbox-hq-vb/setup-VirtualBox
   $ sudo sh setupVirtualBox.sh
   $ cd ${HOME}/git/rdbox/tutorials/setup-rdbox-hq-vb/setup-vagrant
   $ sudo sh setupVagrant.sh
   ```

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
[MIT](/LICENSE).

## Contributing
以下はRDBOXにコントリビューションするための一連のガイドラインです。

これらは主にガイドラインであり、規則ではありません。

* RDBOXを構成する私たちのコンポーネントへの貢献は、同様の規則を適用します。
   - [flashRDBOX](https://github.com/rdbox-intec/flashRDBOX)
   - [go\-transproxy](https://github.com/rdbox-intec/go-transproxy)
   - [rdbox\-middleware](https://github.com/rdbox-intec/rdbox-middleware)
   - [image\-builder\-rpi](https://github.com/rdbox-intec/image-builder-rpi)

1. リポジトリをフォークします
2. `master` ブランチから派生したプルリクエスト用ブランチを作成します。
3. コードを書きます。
4. そのブランチからプルリクエストを送信して下さい。

## サポート & 問い合わせ
気軽にお問い合わせ下さい。

Stack Overflowで[#rdbox](https://stackoverflow.com/questions/tagged/rdbox)タグをつけて質問することもできます。

またはEメールも利用可能です。
RDBOX Project (info-rdbox@intec.co.jp)

** このプロジェクトが気に入りましたら、是非スターをお願いします。 **
