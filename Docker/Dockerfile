FROM ghcr.io/void-linux/void-glibc

WORKDIR /bind

COPY x-install.sh /

COPY tlmgrDeps.sh /

COPY gimme /usr/bin/

RUN /x-install.sh && \
    echo a4 > /etc/papersize

ENV PATH="/opt/texlive/2025/bin/x86_64-linux:${PATH}"

RUN /tlmgrDeps.sh
