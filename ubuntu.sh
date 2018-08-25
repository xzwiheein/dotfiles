#!/bin/bash
PWD=`pwd`
LOG_FILE="${PWD}/.xu_instll.log"
LOG_ADD="tee -a ${LOG_FILE}"
PALTFROM_VERSION=`uname -m`
if [ ! -f $LOG_FILE ];
then 	
    touch $LOG_FILE
fi
echo "#### LOG MESSAGE RECODE START ####" | $LOG_ADD
TIME=`date`
echo ">>>> TIME $TIME <<<<" | $LOG_ADD
ALL="source tools zsh ssh samba nfs NAT gcc vnc"
MODLE=$ALL
echo $MODLE | $LOG_ADD

if [ $# -eq 0 ];
then 
     echo "Input parameters ERROR,TO LESS." | $LOG_ADD
     exit 0
fi
if [ $1 = source ];
then
sudo cp /etc/apt/sources.list /etc/apt/sources.list.back
sudo sed -i '/^$/d' /etc/apt/sources.list
sudo sed -i 's/^# deb/deb/' /etc/apt/sources.list
sudo sed -i '/^#/d' /etc/apt/sources.list
sudo sed -i 's/security.ubuntu.com/mirrors.163.com/' /etc/apt/sources.list
sed -i 's/cn.archive.ubuntu.com/mirrors.163.com/' /etc/apt/sources.list
echo ">>>>>> SOURCES FILE SHOW START<<<<<<" | $LOG_ADD
echo "" | $LOG_ADD
cat /etc/apt/sources.list | $LOG_ADD
echo "" | $LOG_ADD
sudo apt-get update 2>> $LOG_FILE
echo "" | $LOG_ADD
echo ">>>>>> SOURCES FILE SHOW END<<<<<<" | $LOG_ADD
fi

if [ $1 = all -o $1 = tools ];
then
sudo apt-get install -y language-pack-zh-hans
sudo apt-get install -y vim zsh git
sudo apt-get install -y net-tools curl gcc
fi

if [ $1 = all -o $1 = zsh ];
then
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
###########################################################
#find String
stringnum=`cat .zshrc|grep -n "plugins=($"|cut -d: -f1`
stringnum=$((stringnum+1))
#replace String
sed -i $stringnum'd' .zshrc
stringnum=$((stringnum-1))
echo "      git autojump command-not-found extract z osx sudo last-working-dir wd">temp.txt
sed -i ${stringnum}'r temp.txt' .zshrc
rm -f temp.txt
sed -i 's/robbyrussell/ys/g' .zshrc
#Done
chsh
fi
##########################################################

# git clone https://github.com/chxuan/vimplus.git ~/.vimplus
# cd ~/.vimplus
# ./install -y.shi

if [ $1 = all -o $1 = ssh ];
then
sudo apt-get install -y openssh-server
sudo service sshd start
fi

if [ $1 = all -o $1 = samba ];
then
if [ $1 = all ];
then
sudo apt-get install -y samba samba-common system-config-samba python-glade2 
#smb-client smbfs
sudo groupadd samba -g 6000
fi
if [ $# -eq 2 ];
then
echo "
[$2]
comment = Shared Folder require password
path = /home/$2/samba_share
public = yes
writable = yes
#valid users = $2
create mask = 0777
directory mask = 0777
force user = nobody
force group = nogroup
available = yes
browseable = yes
"> temp.txt
sudo sed -i '$r temp.txt' /etc/samba/smb.conf
rm -f temp.txt
#sudo su $2
#mkdir /home/$2/samba_share
sudo chmod 777 -R /home/$2/samba_share
#exit
#sudo useradd $2 -g 6000 -s /sbin/nologin -d /dev/null
#mkdir /home/temp/share
sudo usermod -a -G samba $2
sudo usermod -a -G nogroup $2
sudo usermod -a -G xie nobody
sudo service smbd restart
echo "Plese run COMMAND:sudo smbpasswd -a $2"
fi
fi

if [ $1 = all -o $1 = nfs ];
then
echo "Install nfs"
sudo apt-get install -y nfs-kernel-server nfs-common
sudo mkdir /mnt/nfs
echo "/mnt/nfs *(rw,sync,no_root_squash,no_subtree_check)
/home/nfs *(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
sudo service portmap restart
sudo service nfs-kernel-server restart
sudo service rpcbind restart
showmount -e
fi

if [ $1 = ipcheak ];
then
ifconfig -a
nmcli dev show
fi


if [ $1 = NAT ];
then 
#sudo vim /etc/sysctl.conf
sudo sysctl -p

sudo sed -i 's/#net.ipv4.ip_forward/#net.ipv4.ip_forward/' /etc/sysctl.conf
sudo sed -i 's/exit/#exit/' /etc/rc.local 
echo '
#!/bin/bash
iptables -F
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -t nat -A POSTROUTING -o enp2s0 -j MASQUERADE
exit 0
' | sudo tee -a /etc/rc.local
fi

if [ $1 = all -o $1 = wangpan ];
then
sudo apt-get install -y python-pip
sudo pip install requests
sudo pip install bypy
echo "RUN bypy info"
fi

if [ $1 = all -o $1 = gcc ];
then
###############################
##gSoap
#sudo apt-get install -y libstdc++-6-dev
sudo apt-get install -y flex gcc
sudo apt-get install -y build-essential
sudo apt-get install -y libgtk2.0-dev libglib2.0-dev
sudo apt-get install -y gawk
sudo apt-get install -y checkinstall -y
sudo apt-get install -y libssl-dev
##########compile tools###################
#if [ $PALTFROM_VERSION = x86_64 ];
#then 
sudo apt-get install -y lib32z1 lib32ncurses5
sudo apt-get install -y libc6:i386
#sudo apt-get install -y libx32stdc++-6-dev
sudo apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386
sudo apt-get install -y gcc-multilib g++-multilib
#fi
fi
exit

if [ $1 = all -o $1 = vnc ];
then 
sudo apt-get install -y xrdp tightvncserver vnc4server
sudo apt-get install -y xubuntu-desktop
echo "xfce4-session" > ~/.xsession
sudo sed -i 's/console/nobody/' /etc/X11/Xwrapper.config
sudo service xrdp restart
fi

if [ $1 = teamviewer ];
then
sudo apt install -y gdebi-core
wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
sudo gdebi teamviewer_amd64.deb
fi
