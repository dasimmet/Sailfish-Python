Appname:=$(shell cat appname.txt)
prefix:=/usr
temp:=/tmp/fpm
builddir:=./build
sdkpath:=$(HOME)/SailfishOS
dependencies:=-d libsailfishapp-launcher -d python3-base -d pyotherside-qml-plugin-python3-qt5
arch:=noarch
rpmname:=$(Appname)-$(arch).rpm
jolla_usb_ip:=192.168.2.15
jolla_wifi_ip:=Jolla


all: clean build-tmp rpm-virt rpm-jolla

make-jolla-usb: build-tmp rpm-jolla send-jolla
make-jolla-wifi: build-tmp rpm-jolla send-jolla-wifi
make-jolla-ap: build-tmp rpm-jolla send-jolla-ap
make-virt: build-tmp rpm-virt send-virt

build-tmp: 
	rm -rf $(temp)
	mkdir -p $(temp)/usr/share/applications
	mkdir -p $(temp)/usr/share/$(Appname)/src
	mkdir -p $(temp)/usr/share/$(Appname)/src
	mkdir -p $(temp)/usr/bin
	cp -ar ./qml $(temp)/usr/share/$(Appname)
	cp -ar ./src/*.py $(temp)/usr/share/$(Appname)/src
	cp -ar ./pyPackages $(temp)/usr/share/$(Appname)/src
	cp ./dat/$(Appname).desktop $(temp)/usr/share/applications/
	install -m 755 ./dat/$(Appname).sh $(temp)/usr/bin/$(Appname)

rpm-virt:
	cd $(temp);fpm -f -s dir -t rpm $(dependencies) -p $(CURDIR)/$(rpmname) -n $(Appname) -a $(arch) --prefix / *

rpm-jolla: arch:=noarch
rpm-jolla:
	cd $(temp);fpm -f -s dir -t rpm $(dependencies) -p $(CURDIR)/$(rpmname) -n $(Appname) -a $(arch) --prefix / *

send-virt:
	rsync -vrp --rsh='ssh -p2223 -i $(sdkpath)/vmshare/ssh/private_keys/SailfishOS_Emulator/root' ./$(rpmname) root@localhost:/tmp
	ssh -p2223 -i $(sdkpath)/vmshare/ssh/private_keys/SailfishOS_Emulator/root root@localhost pkcon install-local -y /tmp/$(rpmname) "&&" rm /tmp/$(rpmname)
	
send-jolla-wifi: arch:=noarch
send-jolla-wifi:
	rsync -vrp ./$(rpmname) root@$(jolla_wifi_ip):/tmp
	ssh root@$(jolla_wifi_ip) pkcon install-local -y /tmp/$(rpmname) "&&" rm /tmp/$(rpmname)

send-jolla-ap: arch:=noarch 
send-jolla-ap: jolla_wifi_ip:=192.168.1.1
send-jolla-ap:
	rsync -vrp ./$(rpmname) root@$(jolla_wifi_ip):/tmp
	ssh root@$(jolla_wifi_ip) pkcon install-local -y /tmp/$(rpmname) "&&" rm /tmp/$(rpmname)

send-jolla: arch:=noarch
send-jolla:
	rsync -vrp ./$(Appname)-$(arch).rpm root@$(jolla_usb_ip):/tmp
	ssh root@$(jolla_usb_ip) pkcon install-local -y /tmp/$(Appname)-$(arch).rpm "&&" rm /tmp/$(Appname)-$(arch).rpm


clean: 
	rm -rf $(temp)
	rm -rf $(builddir)
	rm -rf ./$(rpmname)


