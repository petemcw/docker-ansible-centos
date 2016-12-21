FROM centos:7
MAINTAINER Pete McWilliams

# environment
ENV HOME="/root"
ENV CONTAINER="docker"
ENV YUMLIST \
    epel-release \
    deltarpm \
    initscripts \
    sudo

# Install systemd -- See https://hub.docker.com/_/centos/
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
    systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;

# packages & configure
RUN \
    yum makecache -y -q fast && \
    yum install -y -q $YUMLIST && \
    yum update -y -q && \
    yum clean -y -q all && \
    rm -rf /tmp/* /var/tmp/* /usr/share/doc /usr/share/man

RUN \
    yum makecache -y -q fast && \
    yum install -y -q ansible && \
    yum clean -y -q all && \
    rm -rf /tmp/* /var/tmp/* /usr/share/doc /usr/share/man

# disable requiretty
RUN \
    sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers

# ansible inventory file
RUN \
    echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

VOLUME ["/sys/fs/cgroup"]
CMD ["/sbin/init"]
