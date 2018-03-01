#!/bin/sh
set -e

mkdir /var/log/haproxy
chmod a+w /var/log/haproxy

egrep 'UDPServerRun|ModLoad' /etc/rsyslog.conf
sed -i 's/#$UDPServerRun 514/$UDPServerRun 514/g' /etc/rsyslog.conf
sed -i 's/#$ModLoad imudp/$ModLoad imudp/g' /etc/rsyslog.conf
sed -n -e '/$ModLoad imudp/p' -e '/$UDPServerRun/p' /etc/rsyslog.conf
echo 'local0.*                       /var/log/haproxy/haproxy.log' >>/etc/rsyslog.conf
sed -i 's/\/var\/log\/haproxy.log/\/var\/log\/haproxy\/haproxy.log/g' /etc/rsyslog.d/*.conf

mkdir /etc/sysconfig
echo '# Options for rsyslogd \
# Syslogd options are deprecated since rsyslog v3. \
# If you want to use them, switch to compatibility mode 2 by "-c 2" \
# See rsyslogd(8) for more details \
SYSLOGD_OPTIONS="-r -m 0 -c 2" '>/etc/sysconfig/rsyslog

service rsyslog restart

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- haproxy "$@"
fi

if [ "$1" = 'haproxy' ]; then
	shift # "haproxy"
	# if the user wants "haproxy", let's add a couple useful flags
	#   -W  -- "master-worker mode" (similar to the old "haproxy-systemd-wrapper"; allows for reload via "SIGUSR2")
	#   -db -- disables background mode
	set -- haproxy -W -db "$@"
fi

exec "$@"
