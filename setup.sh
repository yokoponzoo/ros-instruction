Y='\033[0;33m'
B='\033[1;34m'
G='\033[1;36m'
N='\033[0m'

# From http://wiki.ros.org/ja/kinetic/Installation/Ubuntu
print "  ${Y}/////////////////////////////////////////${N}"
print " ${Y}///      ${B}Start installing ros...${N}      ${Y}///${N}"
print "${Y}/////////////////////////////////////////${N}"
sleep 1
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
sudo apt update
sudo apt-get install ros-kinetic-desktop-full
sudo rosdep init
rosdep update
echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
source ~/.bashrc
print "${G}Success to install ros!${N}\n"
sleep 0.5

# From https://www.roboken.iit.tsukuba.ac.jp/platform/wiki/yp-spur/how-to-install
print "  ${Y}/////////////////////////////////////////${N}"
print " ${Y}///    ${B}Start installing yp-spur...${N}    ${Y}///${N}"
print "${Y}/////////////////////////////////////////${N}"
sleep 1
git clone http://www.roboken.iit.tsukuba.ac.jp/platform/repos/yp-spur.git ~/
cd ~/yp-spur
git branch roboken origin/roboken
git checkout roboken
./configure
make
sudo make install
cd -
rm -rf ~/yp-spur
print "${G}Success to install yp-spur!${N}\n"

print "  ${Y}/////////////////////////////////////////${N}"
print " ${Y}///    ${B}Start installing packages...${N}    ${Y}///${N}"
print "${Y}/////////////////////////////////////////${N}"
sleep 1
sudo apt install -y ros-kinetic-move-base-msgs ros-kinetic-amcl ros-kinetic-gmapping ros-kinetic-joy ros-kinetic-move-base ros-kinetic-urg-node ros-kinetic-ypspur-ros ros-kinetic-map-server
print "${G}Success to install all packages!${N}\n"

print "  ${Y}/////////////////////////////////////////${N}"
print " ${Y}///   ${B}Start creating project...${N}  ${Y}///${N}"
print "${Y}/////////////////////////////////////////${N}"
sleep 1
# Create a ros workspace in ~/my_workspace
mkdir -p ~/my_workspace/src
cd ~/my_workspace/src
catkin_init_workspace

cd ~/
git clone https://github.com/morioka-lab/ros
cp -rf ros/* ~/my_workspace/src/
cd ~/my_workspace
print "${G}Success to create new project in ~/my_workspace!${N}\n"
