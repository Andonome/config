FROM voidlinux/voidlinux

WORKDIR /bind

COPY x-install.sh /

COPY tlmgrDeps.sh /

RUN /x-install.sh

ENV PATH="/opt/texlive/2023/bin/x86_64-linux:${PATH}"

RUN /tlmgrDeps.sh


