Name:		hw3
Version:	0.2
Release:	1.el7
Summary:	Third homework for TechnoTrek
License:	MIT
Source0:	hw3
Source1:	hw3_crontab
Source2:	hw3.service
Source3:	hw3_logrotate.conf
Source4:	hw3_rsyslog.conf

%description
The RPM package that creates a simple logger of disk space usage.

%install
install -D -m 755 %{SOURCE0} $RPM_BUILD_ROOT/usr/sbin/hw3
install -D -m 644 %{SOURCE1} $RPM_BUILD_ROOT/etc/cron.d/hw3_crontab
install -D -m 644 %{SOURCE2} $RPM_BUILD_ROOT/etc/systemd/system/hw3.service
install -D -m 644 %{SOURCE3} $RPM_BUILD_ROOT/etc/logrotate.d/hw3_logrotate.conf
install -D -m 644 %{SOURCE4} $RPM_BUILD_ROOT/etc/rsyslog.d/hw3_rsyslog.conf
mkdir -pv                    $RPM_BUILD_ROOT/var/log/HW3

%post
systemctl enable hw3.service
systemctl restart rsyslog

%files
/usr/sbin/hw3
/etc/cron.d/hw3_crontab
/etc/systemd/system/hw3.service
/etc/logrotate.d/hw3_logrotate.conf
/etc/rsyslog.d/hw3_rsyslog.conf
%dir /var/log/HW3

%preun
if [ $1 -eq 0 ]
then
	systemctl disable hw3.service
	systemctl restart rsyslog
fi

