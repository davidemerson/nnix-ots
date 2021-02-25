FROM ruby:latest
	RUN groupadd -r ots && useradd -r -m -g ots ots
	RUN apt-get -y update
	RUN apt-get -y upgrade
	RUN apt-get -y install ntp libyaml-dev libevent-dev zlib1g zlib1g-dev openssl libssl-dev libxml2 libreadline-gplv2-dev redis-server build-

	RUN gem install bundler
	RUN mkdir -p /etc/onetime && chown ots /etc/onetime
	ADD . /home/ots/onetime
	RUN cd /home/ots/onetime && bundle install --frozen --deployment --without=dev

	RUN mkdir -p /var/log/onetime /var/run/onetime /var/lib/onetime
	RUN chown ots /var/log/onetime /var/run/onetime /var/lib/onetime
	RUN cp -r /home/ots/onetime/etc/* /etc/onetime


 EXPOSE 8081
ENTRYPOINT echo $ots_domain | xargs -I domurl sed -ir 's/:domain:/:domain: domurl/g' /etc/onetime/config \
&& echo $ots_host | xargs -I hosturl sed -ir 's/:host:/:host: hosturl/g' /etc/onetime/config \
&& echo $ots_ssl | xargs -I hostssl sed -ir 's/:ssl:/:ssl: hostssl/g' /etc/onetime/config \
&& dd if=/dev/urandom bs=40 count=1 | openssl sha1 | grep stdin | awk '{print $2}' | xargs -I key sed -ir 's/:secret:/:secret: key/g' /etc/onetime/config \
&& cd /home/ots/onetime/ \
&& bundle exec thin -e dev -R config.ru -p 8081 start