FROM ubuntu:20.10
ARG DEBIAN_FRONTEND=noninteractive
ENV PATH="$PATH:/root/.local/bin"
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
RUN mkdir /root/.agda \
 && mkdir /plfa \
 && mkdir /plfa/init
COPY agda-libraries-1 /root/.agda/libraries
COPY agda-defaults /root/.agda/defaults
COPY hello.agda /plfa/init/hello.agda
COPY nats.agda /plfa/init/nats.agda
RUN apt-get update \
 && apt-get install -y curl git emacs locales libtinfo-dev \
 && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
 && dpkg-reconfigure --frontend=noninteractive locales \
 && update-locale LANG=en_US.UTF-8 \
 && curl -sSL https://get.haskellstack.org/ | sh \
 && stack upgrade \
 && /bin/sh -c 'cd plfa ; git clone https://github.com/agda/agda.git ; cd agda ; git checkout v2.6.1.1 ; stack install --stack-yaml stack-8.8.3.yaml' \
 && /bin/sh -c 'cd plfa ; git clone https://github.com/agda/agda-stdlib.git agda-stdlib ; cd agda-stdlib ; git checkout v1.3' \
 && rm -r /plfa/agda/.git \
 && rm -r /plfa/agda-stdlib/.git \
 && rm -r /root/.stack \
 && /bin/sh -c 'cd plfa/init ; agda -v 2 hello.agda ; agda -v 2 nats.agda'
COPY agda-libraries-2 /root/.agda/libraries
COPY emacs-config /root/.emacs
