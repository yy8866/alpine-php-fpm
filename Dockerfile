# Dockerfile - php-openresty
FROM FROM haohuicu/alpine-php-fpm:1.2.7214
RUN	sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories  \  	
  && apk update \
  && apk upgrade \
  && apk add --no-cache  \
  nfs-utils \
  rsync \
  git \
  openssh-server \
  && rm -rf /var/cache/apk/* \
  && mkdir /var/run/sshd \
  && echo 'root:root' |chpasswd \
  && sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
  && sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
  && mkdir /root/.ssh \
  && /usr/bin/ssh-keygen -A
  && mkdir -p -m0755 /var/run/sshd \  
  #authorized_keys
  && echo root:root|chpasswd  \
  && cat >> ~/.ssh/authorized_keys <<EOF
  ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQCqYhfaxk236dVqi/mfUWcwDtNQLnY4ReWHsoshqG9cDuoYajkWw0z9+gkxAdHN5xKRG1SyMNQYuiur7bBn5BksrELqwz9PbfkcVopUHQY/3v1y/16IFtBYgtkmaE87djQoTln3CX8AAzpcUkIlkrxwOGPGUakYZBHX+aoMvsR8YQ== skey_384797
  ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDL8Imdka5j/Of0iEOruKbdbSORLIQCjsDvFZ7k3OTxjfgQ4ZfAAYs0FcNCncA/3uSUZgv7uOHxJFztJiVoYJQih3vYCs+EZ0rryUQnFHvtLksOg4Ea6LgvEnKozwVDPelKztBOUocsP6i+swhPGZ5ENtg88vVtV1pbhUY5rUDwPTNKfqEMdLJPHAHSKFJcbua0fsmCbRHz/IpMaD+X/qDNti7Glvdb0yCzLdftJlwxjYWO8AmY5+I8UdpQYHI/jVOuP2KVjLMYewcoPdm+axgVEjU5uRBB0aU3HzCFvM/F0sekeifmTydiII4gfpWpkDHasHszkJ9cWXfykRAQKT0V root@VM_0_9_centos
  EOF \
 && chown root:root ~/.ssh/authorized_keys  \
 && chmod 600 ~/.ssh/authorized_keys  

# Copy supervisord configuration file
COPY sshd.conf /etc/supervisor/conf.d/

WORKDIR /usr/local/openresty/nginx/html/

EXPOSE 443 80 9000 22

CMD ["/usr/bin/supervisord", "-n","-c", "/etc/supervisord.conf"]
