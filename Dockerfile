FROM       hasufell/exherbo
MAINTAINER Julian Ospald <hasufell@posteo.de>


COPY ./config/paludis /etc/paludis

##### PACKAGE INSTALLATION #####

# update world with our options
RUN chgrp paludisbuild /dev/tty && \
	eclectic env update && \
	source /etc/profile && \
	cave sync && \
	cave resolve -z -1 repository/net -x && \
	cave update-world -s tor && \
	cave resolve -ks -Sa -sa -B world -x -f --permit-old-version '*/*' && \
	cave resolve -ks -Sa -sa -B world -x --permit-old-version '*/*' && \
	cave purge -x && \
	cave fix-linkage -x && \
	rm -rf /usr/portage/distfiles/*

RUN eclectic config accept-all

################################

RUN mkdir -p /var/run/tor /var/log/tor /var/lib/tor/data && \
	touch /var/log/tor/notices.log /var/log/tor/debug.log && \
	chown -R tor:tor /var/run/tor /var/log/tor /var/lib/tor

RUN cp /etc/tor/torrc.sample /etc/tor/torrc

EXPOSE 9050

CMD echo "$(grep $(hostname) /etc/hosts | awk '{ print $1 }') tor" >> /etc/hosts && \
	exec /usr/bin/tor -f /etc/torrc
