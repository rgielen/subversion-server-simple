FROM rgielen/httpd-image-simple:latest
MAINTAINER "Rene Gielen" <rgielen@apache.org>

ENV SVN_HOME=/var/lib/svn
ENV SVN_CONFIG=/etc/apache2/dav_svn
ENV SVN_PASSWD=${SVN_CONFIG}/dav_svn.passwd

COPY sites-available/* /etc/apache2/sites-available/

RUN apt-get update && apt-get -y install subversion libapache2-mod-svn subversion-tools vim \
        && a2enmod dav_svn \
        && a2ensite dav_svn \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* \
        && rm -rf /tmp/*

RUN mkdir ${SVN_HOME} && chown www-data:www-data ${SVN_HOME} && chmod 770 ${SVN_HOME} && chmod g+s ${SVN_HOME}
RUN mkdir ${SVN_CONFIG} && chown root:www-data ${SVN_CONFIG} && chmod 750 ${SVN_CONFIG} && chmod g+s ${SVN_CONFIG}

COPY add-svn-user.sh /usr/local/bin
COPY add-svn-project.sh /usr/local/bin
COPY dav_svn.authz.sample /

VOLUME ${SVN_HOME}
VOLUME ${SVN_CONFIG}
