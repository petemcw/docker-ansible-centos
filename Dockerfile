FROM centos:6
MAINTAINER Pete McWilliams

# environment
ENV HOME="/root"
ENV YUMLIST \
    epel-release \
    deltarpm \
    sudo

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

CMD ["/sbin/init"]
