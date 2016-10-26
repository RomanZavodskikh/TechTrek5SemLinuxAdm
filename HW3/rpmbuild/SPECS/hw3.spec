Name:		hw3
Version:	0.1
Release:	1.el7
Summary:	Third homework for TechnoTrek
License:	MIT
Source0:	hw3
Source1:	hw3_crontab
Source2:	hw3.service
Source3:	hw3_logrotate.conf
Source4:	hw3_crontab_logrotate

%description
The RPM package that creates a simple logger of disk space usage.

%install
install -D -m 755 %{SOURCE0} $RPM_BUILD_ROOT/usr/sbin/hw3
install -D -m 644 %{SOURCE1} $RPM_BUILD_ROOT/etc/cron.d/hw3_crontab
install -D -m 644 %{SOURCE2} $RPM_BUILD_ROOT/etc/systemd/system/hw3.service
install -D -m 644 %{SOURCE3} $RPM_BUILD_ROOT/etc/hw3_logrotate.conf
install -D -m 644 %{SOURCE4} $RPM_BUILD_ROOT/etc/cron.d/hw3_crontab_logrotate

%post
mkdir -pv /var/log/HW3
touch /var/log/HW3/logrotate.state
systemctl enable hw3.service

%files
/usr/sbin/hw3
/etc/cron.d/hw3_crontab
/etc/cron.d/hw3_crontab_logrotate
/etc/systemd/system/hw3.service
/etc/hw3_logrotate.conf

%preun
systemctl disable hw3.service
rm -rf /var/log/HW3

