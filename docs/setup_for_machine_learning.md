# GPUインスタンス上にROS学習環境構築
(AWS EC2のGPUインスタンスで)森岡研の自律移動ロボットの学習を動かすためのセットアップ方法です。(走り書きに近い)

デフォルトではGPUインスタンスの上限数が0なので、申請が必要。EC2ダッシュボード左上のLimitsより、Request limit increaseリンクからサポートチケットを発行する。

適当にGPUインスタンスを指定して起動する。ここでOSはUbuntu16系を選ぶこと。


(おまけ) locale周りのwarningを消す

```
sudo su -
echo "LC_ALL=en_US.UTF-8" >> /etc/environment
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
locale-gen en_US.UTF-8
```


## Pythonのインストール


```
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(pyenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
sudo apt-get update --fix-missing
sudo apt-get install build-essential
sudo apt-get install -y build-essential zlib1g-dev libssl-dev libffi-dev
pyenv install 2.7.16
pyenv global 2.7.16
```


## CUDA/cuDNNを入れる
cudaのバージョンは10.0じゃなきゃだめ。
EC2インスタンスのストレージを広げるのを忘れないように。

    wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
    sudo dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
    sudo apt-get update
    sudo apt-get install cuda-10-0
    
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" | sudo tee /etc/apt/sources.list.d/nvidia-ml.list
    wget -qO - https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub | sudo apt-key add -
    sudo apt update
    sudo apt install libcudnn7-dev
    
    pip install tensorflow-gpu


### 監視ツールをインストールする
GPUの利用率などをCloudWatchで監視する事ができます。

https://aws.amazon.com/blogs/machine-learning/monitoring-gpu-utilization-with-amazon-cloudwatch/

    pip install nvidia-ml-py boto3



## Lambda Stackで一発環境構築(推奨)
CUDAやcuDNNのインストールを一発で行ってくれるLambda Stackが楽ちんです。

    LAMBDA_REPO=$(mktemp) && \
    wget -O${LAMBDA_REPO} https://lambdalabs.com/static/misc/lambda-stack-repo.deb && \
    sudo dpkg -i ${LAMBDA_REPO} && rm -f ${LAMBDA_REPO} && \
    sudo apt-get update && sudo apt-get install -y lambda-stack-cuda
    
    sudo apt install -y libbox2d-dev libsdl2-dev libsdl2-gfx-dev libsdl2-gfx-1.0 libsdl2-ttf-dev
    pip install tensorflow-gpu

## machine_learningを入れる
まず、git周りのセットアップを済ませておく(ssh鍵など)。だいたい鍵はMorioka1104
`python main.py`を実行して学習を走らせます。

```
sudo apt install -y libpython2.7 libbox2d-dev libsdl2-dev libsdl2-gfx-dev libsdl2-gfx-1.0 libsdl2-ttf-dev
git clone git@github.com:morioka-lab/machine_learning.git
cd ~/machine_learning/deep_reinforcement_learning/DDQN/scripts
mkdir ~/.pyenv/versions/2.7.16/lib/python2.7/fabot2d/
cp fabot2d.so ~/.pyenv/versions/2.7.16/lib/python2.7/fabot2d/
pip install numpy future six tensorflow-gpu keras
vim settings.py # TRAINをTrueにする。
python main.py
```

### ずっと走らせる
ただバックグラウンド実行させるだけだと途中でプロセスが死ぬので`nohup`してやります。

```
nohup python main.py >> 0429.log &
```

## まとめ
- Lambda Stackでインストール
- morioka-lab/machine_learningをclone
- 必要ライブラリをapt install
- gpumon.pyを作って.aws/credentialsを作成
- nohup pythonでgpumon.pyとmain.pyを実行

## 出たエラー達

### ImportError: dynamic module does not define module export function (PyInit_fabot2d)

    ubuntu@ip-172-31-47-230:~/machine_learning/deep_reinforcement_learning/DDQN/scripts$ python main.pyTraceback (most recent call last):
      File "main.py", line 6, in <module>
        from environment import Fabot2D
      File "/home/ubuntu/machine_learning/deep_reinforcement_learning/DDQN/scripts/environment.py", line 14, in <module>
        from fabot2d import World, ChainObstacleDef
    ImportError: dynamic module does not define module export function (PyInit_fabot2d)

fabot2d.soの場所が認識されていない。fabot2d.soを`~/.pyenv/versions/2.7.16/lib/python2.7/fabot2d/`に追加。

### RuntimeError: Failed to connect to the Mir Server

    ubuntu@ip-172-31-47-230:~/machine_learning/deep_reinforcement_learning/DDQN/scripts$ python main.py
    Using TensorFlow backend.
    2019-04-16 10:05:45.089699: I tensorflow/core/platform/cpu_feature_guard.cc:141] Your CPU supports instructions that this TensorFlow binary was not compiled to use: AVX2 FMA
    2019-04-16 10:05:45.095179: I tensorflow/core/platform/profile_utils/cpu_utils.cc:94] CPU Frequency: 2300050000 Hz
    2019-04-16 10:05:45.096783: I tensorflow/compiler/xla/service/service.cc:150] XLA service 0x2ee0b30 executing computations on platform Host. Devices:
    2019-04-16 10:05:45.096809: I tensorflow/compiler/xla/service/service.cc:158]   StreamExecutor device (0): <undefined>, <undefined>
    WARNING:tensorflow:From /home/ubuntu/.pyenv/versions/2.7.16/lib/python2.7/site-packages/tensorflow/python/framework/op_def_library.py:263: colocate_with (from tensorflow.python.framework.ops) is deprecated and will be removed in a future version.
    Instructions for updating:
    Colocations handled automatically by placer.
    WARNING:tensorflow:From /home/ubuntu/.pyenv/versions/2.7.16/lib/python2.7/site-packages/tensorflow/python/ops/math_ops.py:3066: to_int32 (from tensorflow.python.ops.math_ops) is deprecated and will be removed in a future version.
    Instructions for updating:
    Use tf.cast instead.
    Failed to load saved network
    Traceback (most recent call last):
      File "main.py", line 27, in <module>
        main()
      File "main.py", line 21, in main
        fabot2d.render()
      File "/home/ubuntu/machine_learning/deep_reinforcement_learning/DDQN/scripts/environment.py", line 249, in render
        self._world.draw()
    RuntimeError: Failed to connect to the Mir Server

settings.pyのTRAINがTrueになっていないので、画面に描写しようとしてエラーになる。`export DISPLAY=":0.0``"`とか打てばできるようにはなりそうだが、そもそも画面描写は今の所使う予定がないから却下。
ref: https://github.com/kivy/kivy/issues/3335#issuecomment-99083441

### ImportError: libBox2D.so.2.3.0: cannot open shared object file: No such file or directory
```
$ python main.py
Traceback (most recent call last):
  File "main.py", line 11, in <module>
    from environment import Fabot2D
  File "/home/asmsuechan/src/morioka-lab/machine_learning/deep_reinforcement_learning/DDQN/scripts/environment.py", line 14, in <module>
    from fabot2d import World, ChainObstacleDef
ImportError: libBox2D.so.2.3.0: cannot open shared object file: No such file or directory
```
