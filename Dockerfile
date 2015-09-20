# Keepalived

FROM debian

MAINTAINER Yury Kavaliou <Yury_Kavaliou@epam.com>

RUN yum install -y keepalived
     tar \
     python-pip \
     && pip install python-consul

ADD https://github.com/hashicorp/consul-template/releases/download/v0.10.0/consul-template_0.10.0_linux_amd64.tar.gz /tmp/consul-template.tar.gz
RUN tar -xf /tmp/consul-template.tar.gz \
    && mv consul-template_0.10.0_linux_amd64/consul-template /bin/consul-template \
    && chmod a+x /bin/consul-template

COPY ./files/start_lb.sh /usr/local/sbin/start_lb.sh
COPY ./files/pre_init.py /usr/local/sbin/pre_init.py
COPY ./files/reinit.sh /usr/local/sbin/reinit.sh
COPY ./files/keepalived.ctmpl /etc/haproxy/keepalived.ctmpl

RUN chmod u+x /usr/local/sbin/start_lb.sh \
    /usr/local/sbin/pre_init.py \
    /usr/local/sbin/reinit.sh

RUN echo "net.ipv4.ip_nonlocal_bind = 1" >> /etc/sysctl.conf

COPY ./files/start_failover.sh /usr/local/sbin/start_failover.sh
RUN chmod u+x /usr/local/sbin/start_failover.sh

ENTRYPOINT [ "/bin/bash", "/usr/local/sbin/start_failover.sh" ]