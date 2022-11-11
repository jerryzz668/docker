FROM nvidia/cuda:11.4.0-base

LABEL maintainer="jerry"

SHELL ["/bin/bash","-c"]

# COPY ./requirements.txt /workspace/
COPY . /workspace/

WORKDIR /workspace

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

RUN sed 's/deb/# deb/g' -i /etc/apt/sources.list.d/cuda.list \
  && apt update \
  && apt install -y build-essential libgl1-mesa-dev libglib2.0-dev openssh-server liblzma-dev \
  && apt install -y libssl-dev zlib1g-dev libbz2-dev libdb-dev libsqlite3-dev lsb-release \
  && apt install -y vim curl git iputils-ping net-tools telnet tmux unzip ca-certificates software-properties-common \
  && cp sources.list /etc/apt/sources.list \
  && mkdir /var/run/sshd \
  && sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
  && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
  && apt-get -y install libncursesw5-dev libgdbm-dev libc6-dev libreadline-dev libdb-dev \
  && apt-get -y install libpcap-dev xz-utils libexpat1-dev tk-dev openssl libffi-dev libc6-dev \
  && apt-get -y install ffmpeg libsm6 libxext6 \
  && apt-get update \
  && apt install -y python3-pip \
  && apt-get -y install python3-tk \
  && pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U \
  && pip3 install torch==1.12.1+cu113 torchvision==0.13.1+cu113 torchaudio==0.12.1 --extra-index-url https://download.pytorch.org/whl/cu113 --default-timeout=100 \
  && echo "test requirments===============" \
  && pip3 install --no-cache -r /workspace/requirements.txt --default-timeout=100 -i https://pypi.douban.com/simple/ \
  && apt clean \
  && sed 's/# deb/deb/g' -i /etc/apt/sources.list.d/cuda.list \
  && cp cudnn.h /usr/local/cuda/include/ \
  && cp lib64/* /usr/local/cuda/lib64/ \
  && chmod a+r /usr/local/cuda/include/cudnn.h \
  && chmod a+r /usr/local/cuda/lib64/libcudnn* \
  && rm -rf /workspace/*; exit 0

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
