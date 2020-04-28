FROM ubuntu:bionic-20200311

ENV LANG C.UTF-8

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        avahi-daemon \
        avahi-utils \
        curl \
        gnupg2 \
        lsb-release \
        jq \
        iputils-ping \
        net-tools \
        openssh-server \
        python3 \
        python3-yaml \
        python3-pexpect \
        python3-flask \
        python3-psutil \
        python3-pip \
        python3-setuptools \
        sudo \
        ssh \
        git \
        dnsutils \
        vim \
        ipcalc
RUN pip3 install --upgrade \
        google-api-python-client \
        oauth2client \
        ansible

RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update -y && \
    apt-get install google-cloud-sdk -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./tutorials/setup-gcp/rdbox-gui/dist /root/git/rdbox/tutorials/setup-gcp/rdbox-gui/dist
COPY ./tutorials/setup-gcp/rdbox-gui/flask_rdbox /root/git/rdbox/tutorials/setup-gcp/rdbox-gui/flask_rdbox
COPY ./tutorials/setup-gcp/rdbox-gui/server.py /root/git/rdbox/tutorials/setup-gcp/rdbox-gui/server.py
COPY ./tutorials/setup-rdbox /root/git/rdbox/tutorials/setup-rdbox
COPY ./tutorials/setup-rdbox-hq /root/git/rdbox/tutorials/setup-rdbox-hq

CMD DEBUG_RDBOX_GUI=False /usr/bin/python3 /root/git/rdbox/tutorials/setup-gcp/rdbox-gui/server.py