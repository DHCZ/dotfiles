ARG PYTORCH="1.3"
ARG CUDA="10.1"
ARG CUDNN="7"

FROM pytorch/pytorch:${PYTORCH}-cuda${CUDA}-cudnn${CUDNN}-devel

ENV TORCH_CUDA_ARCH_LIST="6.0 6.1 7.0+PTX"
ENV TORCH_NVCC_FLAGS="-Xfatbin -compress-all"
ENV CMAKE_PREFIX_PATH="$(dirname $(which conda))/../"
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


RUN conda install -y ipython
RUN pip install ninja yacs cython matplotlib tqdm opencv-python tensorboardX

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

RUN /usr/bin/zsh -c "source ~/.zshrc && \
                     eval zsh"

COPY .tmux.conf /root

# Repo
# Install mmdetection
RUN pip install "git+https://github.com/cocodataset/cocoapi.git#subdirectory=PythonAPI"
RUN git clone https://github.com/open-mmlab/mmdetection.git /mmdetection
WORKDIR /mmdetection
ENV FORCE_CUDA="1"
RUN pip install --no-cache-dir -e .

# init conda
RUN ["/opt/conda/condabin/conda", "init" , "zsh"]
# make docker image run forever
CMD ["/usr/sbin/sshd", "-D"]

