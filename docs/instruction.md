# はじめに

# 必要な環境のインストール
ここでは最終的にrosが動くところまで確認します。まだロボットは動かしません。

環境は`Ubuntu 16.04.05 Xenial`を想定しています。残念ながら他の環境だと動かないことが結構あります。

## ROSのインストール
ROSに関しては、下の公式ドキュメントに従えばインストールできます。インストールするのはROSのkineticという名前のバージョンです。

http://wiki.ros.org/ja/kinetic/Installation/Ubuntu

## yp-spurのインストール
yp-spurとは筑波大学のどこかの研究室が公開している、モーターを動かすためのドライバらしいです。

以下のURLにあるインストールガイドに従ってインストールしましょう。ちなみに`git clone`してくる場所はどこでもいいです。とりあえず私は`~/`で作業しました。

https://www.roboken.iit.tsukuba.ac.jp/platform/wiki/yp-spur/how-to-install

# セットアップする
## ワークスペースの作成
まずはワークスペースのディレクトリを作成します。

```
$ mkdir -p my_workspace/src
```

次に`catkin_init_workspace`でワークスペースを初期化します。

```sh
$ cd my_workspace/src
$ catkin_init_workspace
Creating symlink "/home/asmsuechan/my_workspace/src/CMakeLists.txt" pointing to "/opt/ros/kinetic/share/catkin/cmake/toplevel.cmake"
```

## 森岡研の独自設定をダウンロードする
森岡研にある自律移動ロボットを動かすための設定等を以下の流れでダウンロードします。

1. GitHubに登録する
2. [森岡研のGitHub Organization](https://github.com/morioka-lab)への招待をもらう(そのうちbotでどうにかするけど今は手動。先生にアカウント欲しいって言ってください)
3. ~/my_workspace/srcでgit clone https://github.com/morioka-lab/rosを実行する

https://github.com/morioka-lab/ros が見えなかったら権限がありません。git/GitHub周りは聞いてください。

TODO: これ場所違うかも

```
$ cd ~/my_workspace/src
$ git clone https://github.com/morioka-lab/ros
```

## 必要なROSパッケージをインストールする

```
$ sudo apt install -y ros-kinetic-move-base-msgs ros-kinetic-amcl ros-kinetic-gmapping ros-kinetic-joy ros-kinetic-move-base ros-kinetic-urg-node ros-kinetic-ypspur-ros ros-kinetic-map-server
```

## catkin_make
次にワークスペースのルートディレクトリに移動して`catkin_make`します。

```sh
$ cd ..
$ catkin_make
Base path: /home/asmsuechan/my_workspace
Source space: /home/asmsuechan/my_workspace/src
Build space: /home/asmsuechan/my_workspace/build
(中略)
[ 89%] Built target ypspur_ros_gencpp
Scanning dependencies of target joint_position_to_joint_trajectory
Scanning dependencies of target ypspur_ros
[ 91%] Building CXX object ros/ypspur_ros/CMakeFiles/joint_position_to_joint_trajectory.dir/src/joint_position_to_joint_trajectory.cpp.o
[ 93%] Building CXX object ros/ypspur_ros/CMakeFiles/ypspur_ros.dir/src/ypspur_ros.cpp.o
[ 93%] Built target ypspur_ros_generate_messages_eus
Scanning dependencies of target ypspur_ros_generate_messages
[ 93%] Built target ypspur_ros_generate_messages
[ 95%] Linking CXX executable /home/asmsuechan/my_workspace/devel/lib/ypspur_ros/joint_tf_publisher
[ 95%] Built target joint_tf_publisher
[ 97%] Linking CXX executable /home/asmsuechan/my_workspace/devel/lib/ypspur_ros/joint_position_to_joint_trajectory
[ 97%] Built target joint_position_to_joint_trajectory
[100%] Linking CXX executable /home/asmsuechan/my_workspace/devel/lib/ypspur_ros/ypspur_ros
[100%] Built target ypspur_ros
```

### catkin_makeで何かエラーが出た時
以下のようなエラーが出た時はパッケージが足りていません。必要なパッケージを(ここでは`move_base_msgs`)をaptでインストールしましょう。

ここでポイントは、`sudo apt install ros-kinetic-move-base-msgs`のように`ros-kinetic-<パッケージ名>`であることと、パッケージ名は`_`を`-`に置き換えることです。

```
-- Could not find the required component 'move_base_msgs'. The following CMake error indicates that you either need to install the package with the same name or change your environment so that it can be found.
CMake Error at /opt/ros/kinetic/share/catkin/cmake/catkinConfig.cmake:83 (find_package):
  Could not find a package configuration file provided by "move_base_msgs"
  with any of the following names:
```

# rosを動かす
まず`roscore`を立ち上げます。これはrosを動かす上でのサーバーのようなものです。

```sh
$ roscore
... logging to /home/asmsuechan/.ros/log/ac4b97dc-3712-11e9-876a-78929cdc6bd5/roslaunch-asmsuechan-9523.log
Checking log directory for disk usage. This may take awhile.
Press Ctrl-C to interrupt
Done checking log file disk usage. Usage is <1GB.

started roslaunch server http://asmsuechan:33573/
ros_comm version 1.12.14


SUMMARY
========

PARAMETERS
 * /rosdistro: kinetic
 * /rosversion: 1.12.14

NODES

auto-starting new master
process[master]: started with pid [9568]
ROS_MASTER_URI=http://asmsuechan:11311/

setting /run_id to ac4b97dc-3712-11e9-876a-78929cdc6bd5
process[rosout-1]: started with pid [9636]
started core service [/rosout]
```

## ジョイスティックをつなぐ
まずはジョイスティックを繋いでみます。roscoreが立ち上がっていることを確認して、別のターミナルを開きましょう。

```
$ cd ~/my_workspace
$ rosrun joy joy_node
[ INFO] [1550892744.686574264]: Opened joystick: /dev/input/js0. deadzone_: 0.050000.
```

こうなれば接続完了です。では実際にジョイスティックからどんな値が得られているかを確認します。また別のターミナルを開きましょう。

```
$ cd ~/my_workspace
$ rostopic echo /joy
header:
  seq: 1
  stamp:
    secs: 1550892777
    nsecs: 616805122
  frame_id: ''
axes: [-0.0, -0.0, 0.0, -0.0, -0.0, 0.0]
buttons: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
---
header:
  seq: 2
  stamp:
    secs: 1550892777
    nsecs: 755331915
  frame_id: ''
axes: [-0.0, -0.0, 0.0, -0.0, -0.0, 0.0]
buttons: [0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
---
```

こんな感じの出力が得られればひとまず完了です。
