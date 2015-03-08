Sailfish Python
==============

this is a pyotherside based app template for sailfish os. I simply cant get my head around the way rpm packages are built,so i found an alternative Way using fpm 
https://github.com/jordansissel/fpm

Build Dependencies:
------------------
this package are needed to build/install the package:

fpm -- to package a a root tree from a temporary directory to a rpm package

## Make Commands:
use these make commands to build/install your app for testing:

`make make-virt`

builds your package, and installs it on your Sailfish Emulator on localhost:2223, considering your Sailfish-SDK is installed at ~/SailfishOS

`make make-jolla-wifi [jolla_wifi_ip=jolla]`

builds your package, and installs it on your jolla phone, considering your development PC is authorized for root ssh login on the phone and it is found in your dns-space as "jolla"

`make make-jolla-usb [jolla_usb_ip=192.168.2.15]`

builds your package, and installs it on your jolla phone, considering your development PC is authorized for root ssh login on the phone, and connected via usb development mode set your jollas ip like above.


## Adding dependencies:
a basic set of dependencies for python3 apps are already added to dependencies.txt, but you can still add other ones to the list.

##Adding python Modules:
all python Modules in pyPackages (suffixed correctly) are included in the package. 
I like to keep both an armv7l and a x86 version in pyPackages , and package the one with the corresponding $(arch)-suffix at packaging. Select the package version within the qml code. I had success using pip wheel to build these packages directly on the jolla phone(armv7hl)/sailfish emulator(x86) and unpacking them to pyPackages. As an example, pillow (Python Imaging Library) is included in the repo.

## Renaming your App:
`/renamep.py "my-new-appname"`

