FROM fedora:20
MAINTAINER Steve Baker <steve@stevebaker.org>

ADD heat /opt/heat
ADD install-heat.sh /opt/install-heat.sh
RUN /opt/install-heat.sh
ADD config-heat.sh /opt/heat/config-heat.sh
