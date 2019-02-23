# ROSセットアップ
森岡研で使用するロボットを動かすための環境をセットアップする手順書です。

## 事前に必要なもの
* Ubuntu 16.04.05 Xenial
* GitHubアカウントとmorioka-labへの招待

## 簡単セットアップ
以下のコマンドを実行しましょう。たまにパスワードとか求められるので見ておきましょう。

```shell
$ curl -sL --proto-redir -all,https https://raw.githubusercontent.com/morioka-lab/ros-instruction/master/setup.sh | bash
```

何か失敗した場合は[セットアップ手順](/docs/instruction.md)を見て手でやってみましょう。上のスクリプトはこの資料の中に書いてあることを自動で実行します。

## ロボットを動かしてみる
実際にロボットを動かすには[こちら](/docs/move_robot.md)を参考にしましょう。
