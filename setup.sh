#!/bin/bash

Y='\033[0;33m'
B='\033[1;34m'
G='\033[1;36m'
N='\033[0m'

# From http://wiki.ros.org/ja/kinetic/Installation/Ubuntu
printf "  ${Y}/////////////////////////////////////////${N}\n"
printf " ${Y}///      ${B}Start installing ros...${N}      ${Y}///${N}\n"
printf "${Y}/////////////////////////////////////////${N}\n"
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
sudo apt update
sudo apt-get install ros-kinetic-desktop-full
sudo rosdep init
rosdep update
echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
source ~/.bashrc
printf "${G}Success to install ros!${N}\n\n\n"
sleep 0.5

# From https://www.roboken.iit.tsukuba.ac.jp/platform/wiki/yp-spur/how-to-install
printf "  ${Y}/////////////////////////////////////////${N}\n"
printf " ${Y}///    ${B}Start installing yp-spur...${N}    ${Y}///${N}\n"
printf "${Y}/////////////////////////////////////////${N}\n"
sudo apt install -y git
git clone http://www.roboken.iit.tsukuba.ac.jp/platform/repos/yp-spur.git ~/yp-spur-tsukuba
cd ~/yp-spur-tsukuba
./configure
make
sudo make install
cd -
rm -rf ~/yp-spur-tsukuba

cd -
git clone https://github.com/openspur/yp-spur
cd yp-spur
mkdir build
cd build
cmake ..
make
sudo make install
sudo ldconfig
printf "${G}Success to install yp-spur!${N}\n\n\n"

# Install ros-related packages
printf "  ${Y}/////////////////////////////////////////${N}\n"
printf " ${Y}///   ${B}Start installing packages...${N}    ${Y}///${N}\n"
printf "${Y}/////////////////////////////////////////${N}\n"
sudo apt install -y ros-kinetic-move-base-msgs ros-kinetic-amcl ros-kinetic-gmapping ros-kinetic-joy ros-kinetic-move-base ros-kinetic-urg-node ros-kinetic-ypspur-ros ros-kinetic-map-server
printf "${G}Success to install all packages!${N}\n\n\n"

# Create a ros workspace in ~/my_workspace
printf "  ${Y}/////////////////////////////////////////${N}\n"
printf " ${Y}///     ${B}Start creating project...${N}     ${Y}///${N}\n"
printf "${Y}/////////////////////////////////////////${N}\n"
mkdir -p ~/my_workspace/src
cd ~/my_workspace/src
catkin_init_workspace

cd -
git clone https://github.com/morioka-lab/ros
cp -rf ros/* ~/my_workspace/src/
sed -i -e "s/<USERNAME>/${USER}/g" ~/my_workspace/src/icart_navigation/launch/map.launch
echo "source ~/my_workspace/devel/setup.bash" >> ~/.bashrc
pip install empy
printf "${G}Success to create new project in ~/my_workspace!${N}\n\n\n\n"
printf "${B}ROSのセットアップが完了しました。~/my_workspaceにワークスペースが作成されました。${N}\n\n\n\n"
