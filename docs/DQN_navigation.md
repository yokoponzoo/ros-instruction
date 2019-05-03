# DQN Navigation
`machine_learning/deep_reinforcement_learning/DDQN`で動かした学習結果を元にロボットを動かす方法です。

## セットアップ
```
$ python --version
2.7.15
$ pip install rospkg future numpy tensorflow keras mutagen pygame
```

## `dqn_navigation`の起動
```
$ roslaunch dqn_navigation dqn_navigation.launch
```

## rvizからロボットを動かす
```
$ roslaunch my_utility rviz.launch
```

rvizで2D Pose Estimateして、Goal Setでゴールを設定してやれば勝手に動いてくれます。
