ifndef __install_ntp_included
__install_ntp_included := $(true)


define install_ntp
apt-get install -y ntp
export temp_conf = $(shell mktemp -ud)
sed -e "s/^server \([0-3]\).ubuntu.pool.ntp.org *$/server \1.au.pool.ntp.org/" /etc/ntp.conf > $$temp_conf
mv $$temp_conf /etc/ntp.conf
echo  -e '#!'"/bin/sh\nntpdate au.pool.ntp.org" > /etc/cron.daily/ntpupdate
chmod a+x /etc/cron.daily/ntpupdate
endef


endif #__install_ntp_included := $(true)
