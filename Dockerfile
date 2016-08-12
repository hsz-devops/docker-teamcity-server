FROM jetbrains/teamcity-server

RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        less \
        bash \
        sudo \
        \
        mc \
        htop \
        \
        python3 \
        python3-pip \
    && \
    curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - && \
    apt-get install -y nodejs && \
    \
    pip3 install --upgrade pip setuptools wheel && \
    pip2 install --upgrade pip setuptools wheel && \
    rm $(which pip) && \
    ln -s $(which pip2) /usr/local/bin/pip && \
    pip --version | grep "python 2\." && \
    \
    pip2 install --upgrade \
        ansible \
        docker-compose \
    && \
    \
    rm -rf /var/lib/apt/lists/*

CMD ["/run-services.sh"]

