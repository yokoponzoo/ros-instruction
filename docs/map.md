# ロボットの地図に関して
## 1. rvizでマップを見る
rvizとはROS用の可視化ツールです。ros-desktop-fullをインストールすると一緒についてきます。

### 1.1 マップについて
以下の画像が中野キャンパス11Fのマップです。マップは普通の画像ファイルです。

![nakano11f](/docs/images/nakano_11f.png)

ここで使うマップは`~/my_workspace/src/maps/nakano/`の中にあります。

### 1.2 rvizを起動する
マップサーバーを起動します。

```
$ roslaunch icart_navigation map.launch
```

次に別ターミナルで以下のコマンドを実行しましょう。

```
$ roslaunch my_utility rviz.launch
```

これで以下のような画面が出てきたら成功です。

![ros-rviz](/docs/images/ros-rviz.png)
