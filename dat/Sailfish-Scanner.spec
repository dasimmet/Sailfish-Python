Name:       scanner

Summary:    Image Cropping Tool
Version:    0.0.1
Release:    1
Group:      Applications/Internet
License:    BSD
Url:        https://github.com/dasimmet/sailfish-scanner
Source0:    %{name}-%{version}.tar.bz2
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Gui)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  pkgconfig(qt5embedwidget) >= 1.9.4

Requires: sailfishsilica-qt5 >= 0.11.8
Requires: jolla-ambient >= 0.3.24
Requires: pyotherside-qml-plugin-python3-qt5
Requires: python3-base
Requires: sailfish-components-media-qt5

%description
Sailfish Web Browser

%prep
%setup -q -n %{name}-%{version}

# >> setup
# << setup

%build
# >> build pre
# << build pre

%qmake5

make %{?jobs:-j%jobs}

# >> build post
# << build post

%install
rm -rf %{buildroot}
# >> install pre
# << install pre
%qmake5_install
chmod +x %{buildroot}/%{_oneshotdir}/*

# >> install post
# << install post

%post
# >> post
/usr/bin/update-desktop-database -q

# Upgrade, count is 2 or higher (depending on the number of versions installed)
if [ "$1" -ge 2 ]; then
%{_bindir}/add-oneshot --user --now cleanup-browser-startup-cache
fi
# << post

%files
%defattr(-,root,root,-)
# >> files
%{_bindir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/applications/open-url.desktop
%{_datadir}/%{name}/*
%{_datadir}/translations/sailfish-browser_eng_en.qm
%{_datadir}/dbus-1/services/*.service
%{_oneshotdir}/cleanup-browser-startup-cache
# << files
