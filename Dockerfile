FROM jetbrains/teamcity-server

MAINTAINER HighSkillz <webdev@highskillz.com>

ENV DEBIAN_FRONTEND="noninteractive"

RUN \
    echo "===> Enabling Multiverse..."  && \
    sed -i "/^# deb.*multiverse/ s/^# //" /etc/apt/sources.list && \
    \
    echo "===> Speeding up apt and dpkg..."  && \
    echo "force-unsafe-io"                 > /etc/dpkg/dpkg.cfg.d/02apt-speedup && \
    echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache && \
    \
    echo "===> Initial packages update"  && \
    apt-get    update  && \
    apt-get -y install \
          apt-transport-https \
          lsb-release \
          software-properties-common \
    && \
    \
    echo "===> Adding PPAs..."  && \
    add-apt-repository -y ppa:ansible/ansible && \
    add-apt-repository -y ppa:brightbox/ruby-ng && \
    apt-get    update  && \
    \
    echo "===> Updating TLS certificates..."         && \
    apt-get -y install \
            ca-certificates \
            openssl \
            ssl-cert \
    && \
    \
    echo "===> Adding Python runtime..."  && \
    apt-get -y install  \
            python3 python3-pip \
    && \
    echo "===> Adding usefull packages for devops shell-works..."  && \
    apt-get -y install  \
            openssh-client \
            \
            bash \
            less \
            nano \
            \
            curl \
            wget \
            \
            realpath \
            virt-what \
            cpu-checker \
            zip \
            xz-utils \
            \
            git \
            \
            mc \
            screen \
            dos2unix \
            iotop \
            htop \
            atop \
            \
    && \
    pip3 install --upgrade pip setuptools wheel && \
    rm $(which pip) && \
    \
    echo "Make sure we can run ansible's docker scripts" && \
    pip3 install --upgrade \
            docker-py \
            docker-compose \
    && \
    \
    echo "===> Installing Ansible..."  && \
    apt-get -y install \
            ansible \
    && \
    \
    echo "===> Installing NodeJS 6.x..."  && \
    curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get -y install  \
          nodejs \
    && \
    \
    echo "===> Adding Ruby 2.x..."  && \
    apt-get -y install  \
            ruby \
    && \
    \
    echo "===> Cleaning up ..."  && \
    apt-get autoremove --purge -y && \
    apt-get clean              -y && \
    rm -rf \
      "${HOME}/.cache" \
      /var/lib/apt/lists/*  && \
    \
    echo "..."

RUN \
    ansible-playbook --version | head -n 1 && \
    python3 --version          | head -n 1 && \
    pip3 --version             | head -n 1 && \
    node --version             | head -n 1 && \
    ruby --version             | head -n 1 && \
    git  --version             | head -n 1 && \
    docker-compose --version   | head -n 1 && \
    openssl version            | head -n 1 && \
    \
    echo "OK!"

CMD ["/run-services.sh"]

