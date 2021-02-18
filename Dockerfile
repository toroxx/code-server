FROM        openjdk:8

RUN         apt update \
    && apt install apt-transport-https ca-certificates wget dirmngr gnupg software-properties-common\
    fonts-powerline vim curl wget git unzip zip tar sudo -y



# add user
ENV         LANG=en_US.UTF-8
RUN         adduser --gecos '' --disabled-password toro \
    && echo "toro ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

# php + python
RUN         sudo apt install ant gradle maven mariadb-client lsb-release ca-certificates apt-transport-https \
            software-properties-common -y
RUN         sudo apt update

RUN         sudo apt install php -y \
            && sudo apt install php-xdebug php-opcache php-cli php-bcmath php-bz2 php-intl php-gd \
            php-mbstring php-mysql php-zip php-fpm php-ldap -y

# php composer

RUN         curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer
#            && sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# node JS
RUN         curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - \
    && sudo apt install nodejs

RUN         chsh -s /bin/bash \
    && ARCH="$(dpkg --print-architecture)" \
    && curl -fsSL "https://github.com/boxboat/fixuid/releases/download/v0.4.1/fixuid-0.4.1-linux-$ARCH.tar.gz" | tar -C /usr/local/bin -xzf - \
    && chown root:root /usr/local/bin/fixuid \
    && chmod 4755 /usr/local/bin/fixuid \
    && mkdir -p /etc/fixuid \  
    && printf "user: toro\ngroup: toro\n" > /etc/fixuid/config.yml

# nginx
#RUN         apt install nginx

# java
ENV         JAVA_HOME         /usr/lib/jvm/java-8-openjdk-amd64

ADD         scripts /scripts

USER        toro
WORKDIR     /home/toro

RUN         echo "install code-server " && curl -fsSL https://code-server.dev/install.sh | sh -s 
#-- --version 3.6.2


RUN         sudo mv /scripts/* /  \
    && sudo chmod +x /*.sh \
    && sudo mkdir -p /home/toro/.local/share/code-server \
    && sudo mv /settings.json /home/toro/.local/share/code-server/settings.json \
    && sudo chown -R toro:toro /home/toro/.local/share/code-server \
    && sudo apt install sshpass 



RUN sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && sudo chmod +x /usr/local/bin/docker-compose

RUN sudo apt-get update \
    #&& sudo apt-get install -y software-properties-common \
    #&& sudo apt-add-repository --yes --update ppa:ansible/ansible \
    #&& sudo apt-get update \
    && sudo apt install -y ansible connect-proxy

# verbose causes the process to remain in the foreground so that docker can track it
#CMD         "/bin/bash" #/run.sh"
CMD         ["/bin/bash"]