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
  && echo root:root|chpasswd  
COPY  authorized_keys ~/.ssh/ 
RUN chown root:root ~/.ssh/authorized_keys  \
&& chmod 600 ~/.ssh/authorized_keys  
# Copy supervisord configuration file
COPY sshd.conf /etc/supervisor/conf.d/

WORKDIR /usr/local/openresty/nginx/html/

EXPOSE 443 80 9000 22

CMD ["/usr/bin/supervisord", "-n","-c", "/etc/supervisord.conf"]
