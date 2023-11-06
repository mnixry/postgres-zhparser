ARG version=16

FROM postgres:${version}-bookworm AS builder

RUN apt-get update && \
    apt-get install -y build-essential git-core autoconf automake libtool postgresql-server-dev-${version} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

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