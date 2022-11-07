FROM nvidia/cuda:11.4.0-base

LABEL maintainer="jerry"

SHELL ["/bin/bash","-c"]

COPY ./requirements.txt /workspace/

WORKDIR /workspace

RUN sed 's/deb/# deb/g' -i /etc/apt/sources.list.d/cuda.list \
  && apt update \
  && apt install -y build-essential libgl1-mesa-dev libglib2.0-dev openssh-server liblzma-dev \
  && apt install -y libssl-dev zlib1g-dev libbz2-dev libdb-dev libsqlite3-dev lsb-release \
  && apt install -y vim curl git iputils-ping net-tools telnet tmux unzip ca-certificates software-properties-common  \
  && mkdir /var/run/sshd \
  && sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
  && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
  && apt-get -y install libncursesw5-dev libgdbm-dev libc6-dev libreadline-dev libdb-dev \
  && apt-get -y install libpcap-dev xz-utils libexpat1-dev tk-dev openssl libffi-dev libc6-dev \
  && apt install -y python3-pip \
  && apt-get install python3-tk  \
  && apt-get install ffmpeg libsm6 libxext6  -y  \
  && pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U \
  && pip3 install --upgrade setuptools pip \
  && pip3 --default-timeout=100 install wheel \
  && pip3 install numpy matplotlib Pillow scipy jupyter pandas h5py easydict sklearn --default-timeout=1000  \
  && pip3 install torch==1.12.1+cu113 torchvision==0.13.1+cu113 torchaudio==0.12.1 --extra-index-url https://download.pytorch.org/whl/cu113 \
  && pip3 --default-timeout=100 install --no-cache -r /workspace/requirements.txt \
  && apt clean \
  && sed 's/# deb/deb/g' -i /etc/apt/sources.list.d/cuda.list \
  && rm -rf /workspace/*; exit 0

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
