Name:        testaa
Version:    0.2
Release:    1%{?dist}
Summary:    test

License:    MIT
Requires:    glibc
BuildArch: noarch

%description
aaaaaa

%install

%post
echo =====POST=====
echo $1
echo =====POST=====


%preun
echo =====PREUN=====
echo $1
echo =====PREUN=====

%files
