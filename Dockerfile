ARG version

FROM postgres:${version}-bookworm AS builder

ARG version
ENV DEBIAN_FRONTEND=noninteractive
ENV PG_DEV_PACKAGE=postgresql-server-dev-${version}
RUN --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    apt-get update && \
    apt-get install -y --no-install-recommends build-essential ca-certificates git autoconf automake libtool $PG_DEV_PACKAGE 

WORKDIR /tmp

RUN git clone https://github.com/hightman/scws && \
    cd scws && \
    touch README && \
    aclocal && \
    autoconf && \
    autoheader && \
    libtoolize && \
    automake --add-missing && \
    ./configure --prefix=/usr/local/scws && \
    make -j$(nproc) && \
    make install

ENV SCWS_HOME=/usr/local/scws
RUN git clone https://github.com/amutu/zhparser && \
    cd zhparser && \
    make -j$(nproc) && \
    make install

FROM postgres:${version}-bookworm

COPY --from=builder /usr/local/scws /usr/local/scws
COPY --from=builder /usr/lib/postgresql /usr/lib/postgresql
COPY --from=builder /usr/share/postgresql /usr/share/postgresql
COPY init.sql /docker-entrypoint-initdb.d/zhparser.sql