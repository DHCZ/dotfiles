ARG CUDA="10.0"
ARG CUDNN="7"

FROM nvidia/cuda:${CUDA}-cudnn${CUDNN}-devel-ubuntu16.04

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# install basics
RUN apt-get update -y \
 && apt-get install -y apt-utils git curl ca-certificates bzip2 cmake tree htop bmon iotop g++ libgtk2.0-dev

RUN apt-get update -y && \
    apt-mark hold libcudnn7 libcudnn7-dev && \
    apt-get install -y --no-install-recommends vim iotop cpio cron dnsutils ed file ftp info locales lshw lsof ltrace man-db mime-support rsync strace time wget bash-completion command-not-found iputils-tracepath manpages mtr-tiny nano openssh-client tcpdump telnet bzip2 gnupg iproute2 iputils-ping less lsb-release mawk net-tools netbase netcat-openbsd passwd procps sudo tzdata ubuntu-keyring software-properties-common at curl git patch openssh-server build-essential tmux htop zsh silversearcher-ag task-spooler \
    zip unzip cmake make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev \
    libopenblas-dev liblapack-dev libjemalloc-dev graphviz python-tk python3-tk && \
    rm -rf /var/lib/apt/lists/*

# zsh and fzf
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    sed -i 's/robbyrussell/fishy/' ~/.zshrc && \
    sed -i 's/(git)/(git zsh-autosuggestions)/' ~/.zshrc && \
    sed -i 's/# DISABLE_AUTO_UPDATE/DISABLE_AUTO_UPDATE/' ~/.zshrc && \
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all

# Install Miniconda
RUN curl -so /miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
 && chmod +x /miniconda.sh \
 && /miniconda.sh -b -p /miniconda \
 && rm /miniconda.sh

ENV PATH=/miniconda/bin:$PATH

# Create a Python 3.6 environment
RUN /miniconda/bin/conda install -y conda-build \
 && /miniconda/bin/conda create -y --name py36 python=3.6.7 \
 && /miniconda/bin/conda clean -ya

ENV CONDA_DEFAULT_ENV=py36
ENV CONDA_PREFIX=/miniconda/envs/$CONDA_DEFAULT_ENV
ENV PATH=$CONDA_PREFIX/bin:$PATH
ENV CONDA_AUTO_UPDATE_CONDA=false

RUN conda install -y ipython
RUN pip install ninja yacs cython matplotlib tqdm opencv-python

# Install PyTorch 1.3 Nightly
RUN conda install -y pytorch torchvision cudatoolkit=10.0 -c pytorch && conda clean -ya

RUN apt-get update && apt-get install -y openssh-server locales

# Install mmdetection requirement
COPY requirements.txt .
RUN pip install -r requirements.txt

# allow ssh access to docker image
RUN mkdir -p /var/run/sshd && \
    echo 'root:1' | chpasswd
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
EXPOSE 22

RUN apt-get update && \
    apt-get install -y xauth && \
    echo "X11Forwarding yes" >> /etc/ssh/sshd_config && \
    echo "X11UseLocalhost no" >> /etc/ssh/sshd_config

# set env variables
RUN locale-gen en_US.UTF-8 && \
    locale-gen zh_CN.UTF-8

RUN echo 'export CONDA_DEFAULT_ENV=py36' >> ~/.zshrc && \
    echo 'export CONDA_PREFIX=/miniconda/envs/$CONDA_DEFAULT_ENV' >> ~/.zshrc && \
    echo 'export PATH=$CONDA_PREFIX/bin:$PATH' >> ~/.zshrc && \
    echo 'export CONDA_AUTO_UPDATE_CONDA=false' >> ~/.zshrc

RUN /usr/bin/zsh -c "source ~/.zshrc && \
                     eval zsh"

COPY .tmux.conf /root

# make docker image run forever
CMD ["/usr/sbin/sshd", "-D"]

