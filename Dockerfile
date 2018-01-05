FROM alpine

MAINTAINER Nicolas Belan <bsd_2000@yahoo.fr>

ARG HITCH_VERSION=1.4.6
ARG HITCH_CHECKSUM=4dbf533706129bfd7a45f6dff020e2ba281a4abc
ARG HITCH_WEBPATH=https://hitch-tls.org/source

ENV HITCH_USER nobody
ENV HITCH_GROUP nogroup
ENV HITCH_CONFIG /etc/hitch/hitch.conf
ENV HITCH_WORKERS 2
ENV HITCH_PARAMS ""
ENV HITCH_BACKEND "web"
ENV HITCH_BACKEND_PORT 80

RUN apk add --no-cache openssl libev

RUN apk add --no-cache --virtual .build-deps curl libev-dev openssl-dev autoconf libtool py-docutils make automake pkgconfig gcc musl-dev byacc flex

RUN mkdir /usr/src \
    && cd /usr/src \
    && curl -SL -o hitch.tar.gz ${HITCH_WEBPATH}/hitch-${HITCH_VERSION}.tar.gz

RUN cd /usr/src && echo "${HITCH_CHECKSUM}  hitch.tar.gz" > sha1sums.txt \
    && sha1sum hitch.tar.gz && sha1sum -c sha1sums.txt

RUN cd /usr/src && tar xzf hitch.tar.gz \
    && cd hitch-${HITCH_VERSION} \
    && ./configure --bindir=/usr/bin --sbindir=/usr/sbin --libexecdir=/usr/libexec --sysconfdir=/etc --localstatedir=/var --libdir=/usr/lib \
    && make \
    && make install \
    && cd /usr/src \
    && rm hitch.tar.gz sha1sums.txt \
    && apk del .build-deps

RUN mkdir /etc/hitch

COPY hitch.conf /etc/hitch/hitch.conf

ADD run.sh /usr/sbin/run.sh

RUN chmod +x /usr/sbin/run.sh

EXPOSE 443

CMD ["run.sh"]
