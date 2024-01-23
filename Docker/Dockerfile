FROM ghcr.io/void-linux/void-glibc

WORKDIR /bind

COPY x-install.sh /

COPY tlmgrDeps.sh /

COPY gimme /usr/bin/

RUN /x-install.sh

ENV PATH="/opt/texlive/2023/bin/x86_64-linux:${PATH}"

RUN /tlmgrDeps.sh
