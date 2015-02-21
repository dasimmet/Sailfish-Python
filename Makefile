Appname:=sailfish-python
prefix:=/usr
temp:=/tmp/make
builddir:=./build
sdkpath:=$(HOME)/SailfishOS
dependencies:=-d libsailfishapp-launcher -d python3-base -d pyotherside-qml-plugin-python3-qt5
arch:=noarch
rpmname:=$(Appname)-$(arch).rpm
jolla_usb_ip:=192.168.2.15
jolla_wifi_ip:=Jolla


all: clean build-tmp rpm-virt rpm-jolla

make-jolla: build-tmp rpm-jolla send-jolla
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
	cd $(temp);fpm -f -s dir -t rpm $(dependencies) -p $(CURDIR)/$(Appname)-$(arch).rpm -n $(Appname) -a $(arch) --prefix / *

rpm-jolla: arch:=noarch
rpm-jolla:
	cd $(temp);fpm -f -s dir -t rpm $(dependencies) -p $(CURDIR)/$(Appname)-$(arch).rpm -n $(Appname) -a $(arch) --prefix / *

send-virt:
	rsync -vrp --rsh='ssh -p2223 -i $(sdkpath)/vmshare/ssh/private_keys/SailfishOS_Emulator/root' ./$(Appname)-$(arch).rpm root@localhost:/home/nemo/Downloads
	ssh -p2223 -i $(sdkpath)/vmshare/ssh/private_keys/SailfishOS_Emulator/root root@localhost pkcon install-local -y /home/nemo/Downloads/$(Appname)-$(arch).rpm
	
send-jolla-wifi: arch:=noarch
send-jolla-wifi:
	rsync -vrp ./$(Appname)-$(arch).rpm root@$(jolla_wifi_ip):/home/nemo/Downloads
	ssh root@$(jolla_wifi_ip) pkcon install-local -y /home/nemo/Downloads/$(Appname)-$(arch).rpm
send-jolla-ap: arch:=noarch 
send-jolla-ap: jolla_wifi_ip:=192.168.1.1
send-jolla-ap:
	rsync -vrp ./$(Appname)-$(arch).rpm root@$(jolla_wifi_ip):/home/nemo/Downloads
	ssh root@$(jolla_wifi_ip) pkcon install-local -y /home/nemo/Downloads/$(Appname)-$(arch).rpm
send-jolla: arch:=noarch
send-jolla:
	rsync -vrp ./$(Appname)-$(arch).rpm root@$(jolla_usb_ip):/home/nemo/Downloads
	ssh root@$(jolla_usb_ip) pkcon install-local -y /home/nemo/Downloads/$(Appname)-$(arch).rpm

clean: 
	rm -rf $(temp)
	rm -rf $(builddir)


