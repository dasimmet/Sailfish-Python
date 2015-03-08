Appname:=$(shell cat appname.txt)
prefix:=/usr
temp:=/tmp/fpm-jolla
builddir:=./build
sdkpath:=$(HOME)/SailfishOS
dependencies=$(shell for file in `cat dependencies.txt`;do echo "-d "$${file};done;)
arch:=noarch
rpmname:=$(Appname)-$(arch).rpm
jolla_usb_ip:=192.168.2.15
jolla_wifi_ip:=Jolla
jolla_ip:=$(jolla_usb_ip)


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
	cd $(temp);fpm -f -s dir -t rpm $(dependencies) -p $(temp)/$(rpmname) -n $(Appname) -a $(arch) --prefix / *

rpm-jolla:
	cd $(temp);fpm -f -s dir -t rpm $(dependencies) -p $(temp)/$(rpmname) -n $(Appname) -a $(arch) --prefix / *

send-virt:
	cat $(temp)/$(rpmname) | ssh -p2223 -i $(sdkpath)/vmshare/ssh/private_keys/SailfishOS_Emulator/root root@localhost cat ">>" /tmp/$(rpmname) "&&" pkcon install-local -y /tmp/$(rpmname) "&&" rm /tmp/$(rpmname)
	
send-jolla-wifi:
	cat $(temp)/$(rpmname) | ssh root@$(jolla_wifi_ip) cat ">>" /tmp/$(rpmname) "&&" pkcon install-local -y /tmp/$(rpmname) "&&" rm /tmp/$(rpmname)

send-jolla-ap: jolla_wifi_ip:=192.168.1.1
send-jolla-ap:
	cat $(temp)/$(rpmname) | ssh root@$(jolla_wifi_ip) cat ">>" /tmp/$(rpmname) "&&" pkcon install-local -y /tmp/$(rpmname) "&&" rm /tmp/$(rpmname)

send-jolla:
	cat $(temp)/$(rpmname) | ssh root@$(jolla_usb_ip) cat ">>" /tmp/$(rpmname) "&&" pkcon install-local -y /tmp/$(rpmname) "&&" rm /tmp/$(rpmname)

clean: 
	rm -rf $(temp)
	rm -rf $(builddir)
	rm -rf ./$(rpmname)


