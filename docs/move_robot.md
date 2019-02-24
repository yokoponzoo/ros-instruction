# ロボットを動かす
## 1. ジョイスティックでロボットを動かす
ジョイスティックでロボットを動かします。1で立ち上げたroscoreとrosrunはCtrl+Cで切っておきましょう。

```
$ roscd icart_navigation
$ cd launch
$ roslaunch waypoint_recorder.launch
```

これだけでロボットが動くようになるはずです。操作方法は、oが前進□が後進、スティックで左右に曲がります。

### (おまけ)別の地図で動かすには
デフォルトの地図は中野キャンパス11Fになっているのですが、別の地図を使いたいときは森岡研のGitHubからダウンロードしたros/の中にある地図の設定を書き換えます。

```
$ roscd icart_navigation
$ vim launch/map.launch
```

6行目の`<node pkg="map_server" type="map_server" name="map_server" args="/home/<USERNAME>/my_workspace/src/maps/nakano/nakano_11f.yaml" />`が地図の設定になります。ここを書き換えることにより別の場所の地図をロードできます。
