# change base image as you like
FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu16.04


# preserve libcudnn7 due to apt bug on version number
# install daily develepment tools
# install mxnet dependency
RUN apt-get update && \
    apt-mark hold libcudnn7 libcudnn7-dev && \
    apt-get install -y --no-install-recommends vim iotop cpio cron dnsutils ed file ftp info locales lshw lsof ltrace man-db mime-support rsync strace time wget bash-completion command-not-found iputils-tracepath manpages mtr-tiny nano openssh-client tcpdump telnet bzip2 gnupg iproute2 iputils-ping less lsb-release mawk net-tools netbase netcat-openbsd passwd procps sudo tzdata ubuntu-keyring software-properties-common at curl git patch openssh-server build-essential tmux htop zsh silversearcher-ag task-spooler \
    zip unzip cmake make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev \
    libopenblas-dev liblapack-dev libjemalloc-dev graphviz python-tk python3-tk python-dev python3-dev && \
    rm -rf /var/lib/apt/lists/*


# zsh and fzf
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    sed -i 's/robbyrussell/fishy/' ~/.zshrc && \
    sed -i 's/(git)/(git zsh-autosuggestions)/' ~/.zshrc && \
    sed -i 's/# DISABLE_AUTO_UPDATE/DISABLE_AUTO_UPDATE/' ~/.zshrc && \
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all

# use pyenv to manage python version
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc && \
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc && \
    echo 'export PYTHON_CONFIGURE_OPTS="--enable-shared"' >> ~/.zshrc && \
    echo 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.zshrc


RUN /usr/bin/zsh -c "source ~/.zshrc && \
                     pyenv install 3.6.8 && \
                     pyenv global 3.6.8 && \
                     eval zsh && \
                     pip install -i https://pypi.tuna.tsinghua.edu.cn/simple -U pipenv ipython 'numpy<1.16' scipy scikit-learn tqdm graphviz easydict matplotlib pyarrow pyzmq pillow cython requests pytz opencv-python"

RUN /usr/bin/zsh -c "source ~/.zshrc && \
                     pip install torch torchvision && \
                     rm -rf ~/.cache"

# allow ssh access to docker image
RUN chsh -s /usr/bin/zsh root && \
mkdir -p /var/run/sshd && \
sed -i '/PermitRootLogin/s/prohibit-password/yes/' /etc/ssh/sshd_config && \
echo root:1 | chpasswd
EXPOSE 22

RUN apt-get update && \
    apt-get install -y xauth && \
    echo "X11Forwarding yes" >> /etc/ssh/sshd_config && \
    echo "X11UseLocalhost no" >> /etc/ssh/sshd_config


# set env variables
RUN echo 'export TERM=xterm-256color\nexport PATH=$PATH:/usr/local/nvidia/bin:/usr/local/cuda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\nexport LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:/usr/local/nvidia/lib:/usr/local/nvidia/lib64:/usr/local/cuda/lib64/stubs\nexport LIBRARY_PATH=$LIBRARY_PATH:/usr/local/lib:/usr/local/nvidia/lib:/usr/local/nvidia/lib64:/usr/local/cuda/lib64/stubs\n' >> ~/.bashrc && \
echo 'export TERM=xterm-256color\nexport PATH=$PATH:/usr/local/nvidia/bin:/usr/local/cuda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\nexport LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:/usr/local/nvidia/lib:/usr/local/nvidia/lib64:/usr/local/cuda/lib64/stubs\nexport LIBRARY_PATH=$LIBRARY_PATH:/usr/local/lib:/usr/local/nvidia/lib:/usr/local/nvidia/lib64:/usr/local/cuda/lib64/stubs\n' >> ~/.zshrc && \
locale-gen en_US.UTF-8 && \
locale-gen zh_CN.UTF-8


# make docker image run forever
CMD ["/usr/sbin/sshd", "-D"]
