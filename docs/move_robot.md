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
