FROM ubuntu:16.04

# docker build . -t zimbra/soap-harness:latest
# docker run --network dockerzcsdevmachine_default --name soap --dns 10.0.0.2 --dns 8.8.8.8 --hostname soap.test  -it --entrypoint /bin/bash zimbra/soap-harness:latest
#   export PATH=/usr/local/staf/bin:$PATH
#   /usr/local/staf/startSTAFProc.sh 
#   STAF local service add service SOAP LIBRARY JSTAF EXECUTE /opt/qa/soapvalidator/bin/zimbrastaf.jar
#   STAF local service add service LOG LIBRARY STAFLog


# Install Basic Packages
RUN apt-get update && \
    apt-get install -y \
    ant \
    ant-contrib \
    build-essential \
    curl \
    dnsmasq \
    dnsutils \
    gettext \
    git \
    git-flow \
    linux-tools-common \
    maven \
    net-tools \
    npm \
    openjdk-8-jdk \
    python \
    python-pip \
    ruby \
    rsyslog \
    software-properties-common \
    vim \
    wget

WORKDIR /tmp
COPY ./soapvalidator.tar.gz /tmp/soapvalidator.tar.gz
# COPY ./STAF3426-setup-linux-amd64-NoJVM.bin /tmp/STAF3426-setup-linux-amd64-NoJVM.bin
COPY ./init /tmp/init
# Unpack the QA soapvalidator tests to /opt/qa/soapvalidator
# Install STAF to /usr/local/staf
# Add the STAF libraries to the END of the list of places where libraries are searched
# Some of the libraries included with STAF are wonky and will bork normal commands
# if they are loaded first.
RUN curl -L -O http://downloads.sourceforge.net/project/staf/staf/V3.4.26/STAF3426-setup-linux-amd64-NoJVM.bin && \
    mkdir -p /opt/qa && \
    tar xzvf /tmp/soapvalidator.tar.gz -C /opt/qa/ && \
    chmod +x /tmp/STAF3426-setup-linux-amd64-NoJVM.bin && \
    /tmp/STAF3426-setup-linux-amd64-NoJVM.bin -i silent \
       -DACCEPT_LICENSE=1 \
       -DCHOSEN_INSTALL_SET=Custom \
       -DCHOSEN_INSTALL_FEATURE_LIST=STAF,ExtSvcs,Langs,Codepage && \
    cp /tmp/init /opt/qa/init && \
    chmod +x /opt/qa/init && \
    rm /tmp/STAF3426-setup-linux-amd64-NoJVM.bin && \
    rm /tmp/soapvalidator.tar.gz && \
    rm /tmp/init && \
    echo /usr/local/staf/lib > /etc/ld.so.conf.d/zzz-staf.conf && \
    ldconfig

