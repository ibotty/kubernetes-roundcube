FROM centos/php-56-centos7
MAINTAINER Tobias Florek <tob@butter.sh>

ENV ROUNDCUBE_VERSION=1.2.3 \
    RCUBE_CONFIG_PATH=/etc/roundcube

ENTRYPOINT ["/usr/libexec/s2i/run"]

RUN set -x \
 && TARBALL="https://github.com/roundcube/roundcubemail/releases/download/$ROUNDCUBE_VERSION/roundcubemail-$ROUNDCUBE_VERSION-complete.tar.gz" \
 && cd /tmp \
 && curl -sSOOL "$TARBALL" "${TARBALL}.asc" \
 && gpg2 --keyserver hkp://pool.sks-keyservers.net/ --recv-keys F3E4C04BB3DB5D4215C45F7F5AB2BAA141C4F7D5 \
 && gpg2 --verify roundcubemail-$ROUNDCUBE_VERSION-complete.tar.gz{.asc,} \
 && tar xzf /tmp/roundcubemail-$ROUNDCUBE_VERSION-complete.tar.gz \
 && mv roundcubemail-$ROUNDCUBE_VERSION/ src \
 && rm -r src/installer \
 && mv src/composer.json-dist src/composer.json \
 && cd \
 && /usr/libexec/s2i/assemble \
 && rm -r /tmp/roundcube* .gnupg
