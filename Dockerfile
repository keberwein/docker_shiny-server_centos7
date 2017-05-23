FROM centos:centos7
MAINTAINER kris eberwein

RUN yum -y install epel-release
# RUN yum update -y
# RUN yum upgrade -y
RUN yum clean all -y
# RUN yum reinstall -y glibc-common
RUN yum install -y locales java-1.7.0-openjdk-devel tar wget

# R devtools pre-requisites:
RUN yum install -y git xml2 libxml2-devel curl curl-devel openssl-devel
# Plotly needs libcurl
RUN yum install libcurl-devel -y

WORKDIR /home/root
RUN yum install -y R

RUN R -e "install.packages(c('shiny', 'rmarkdown', 'devtools', 'RJDBC', 'dplyr', 'plotly', 'RPostgreSQL', 'lubridate', 'DT'), repos='http://cran.r-project.org', INSTALL_opts='--no-html')"

#-----------------------

# Add RStudio binaries to PATH
# export PATH="/usr/lib/rstudio-server/bin/:$PATH"
ENV PATH /usr/lib/rstudio-server/bin/:$PATH 
ENV LANG en_US.UTF-8

RUN yum install -y openssl098e supervisor passwd pandoc

# RUN wget http://download2.rstudio.org/rstudio-server-rhel-0.99.484-x86_64.rpm
# Go for the bleading edge:
RUN wget https://s3.amazonaws.com/rstudio-dailybuilds/rstudio-server-rhel-0.99.697-x86_64.rpm
RUN yum -y install --nogpgcheck rstudio-server-rhel-0.99.697-x86_64.rpm \
	&& rm -rf rstudio-server-rhel-0.99.484-x86_64.rpm

RUN groupadd rstudio \
	&& useradd -g rstudio rstudio \
	&& echo rstudio | passwd rstudio --stdin 

RUN wget https://download3.rstudio.org/centos5.9/x86_64/shiny-server-1.4.0.756-rh5-x86_64.rpm
RUN yum -y install --nogpgcheck shiny-server-1.4.0.756-rh5-x86_64.rpm \
	&& rm -rf shiny-server-1.4.0.756-rh5-x86_64.rpm

RUN mkdir -p /var/log/shiny-server \
	&& chown shiny:shiny /var/log/shiny-server \
	&& chown shiny:shiny -R /srv/shiny-server \
	&& chmod 755 -R /srv/shiny-server \
	&& chown shiny:shiny -R /opt/shiny-server/samples/sample-apps \
	&& chmod 755 -R /opt/shiny-server/samples/sample-apps 

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN mkdir -p /var/log/supervisor \
	&& chmod 755 -R /var/log/supervisor


EXPOSE 8787 3838


CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"] 
