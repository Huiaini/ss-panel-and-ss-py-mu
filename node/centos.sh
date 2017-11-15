#!/bin/bash

Setting_node_information(){
	clear;echo "设定服务端信息:"
	read -p "(1/3)前端地址:" Front_end_address
	read -p "(2/3)节点ID:" Node_ID
	read -p "(3/3)Mukey:" Mukey
	if [[ ${Mukey} = '' ]];then
		Mukey='mupass';echo "未设置该项,默认Mukey值为:mupass"
	fi
	echo;echo "Great！即将开始安装...";echo;sleep 2.5
}

install_node_for_centos(){
	#yum -y update
	yum -y groupinstall "Development Tools"
	yum -y install git gcc wget curl python-setuptools
	wget "http://ssr-1252089354.coshk.myqcloud.com/get-pip.py"
	python get-pip.py;rm -rf python get-pip.py;mkdir python;cd python
	wget "http://ssr-1252089354.coshk.myqcloud.com/python.zip";unzip python.zip
	pip install *.whl;pip install *.tar.gz;cd /root;rm -rf python
	
	cd /root;wget "http://ssr-1252089354.coshk.myqcloud.com/libsodium-1.0.15.tar.gz"
	tar xf /root/libsodium-1.0.15.tar.gz;cd /root/libsodium-1.0.15;./configure;make -j2;make install;cd /root
	echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf;ldconfig
	
	wget -O /usr/bin/ss "https://raw.githubusercontent.com/qinghuas/ss-panel-and-ss-py-mu/master/node/ss";chmod 777 /usr/bin/ss
	yum -y install lsof lrzsz python-devel libffi-devel openssl-devel
	git clone -b manyuser https://github.com/glzjin/shadowsocks.git "/root/shadowsocks"
	cd /root/shadowsocks;cp apiconfig.py userapiconfig.py;cp config.json user-config.json
	
	sed -i "17c WEBAPI_URL = \'${Front_end_address}\'" /root/shadowsocks/userapiconfig.py
	sed -i "2c NODE_ID = ${Node_ID}" /root/shadowsocks/userapiconfig.py
	sed -i "18c WEBAPI_TOKEN = \'${Mukey}\'" /root/shadowsocks/userapiconfig.py
}

Setting_node_information
install_node_for_centos