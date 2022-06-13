FROM ubuntu:latest

WORKDIR /home/work
RUN apt update && apt install -y wget cmake git openssh-server autoconf pkg-config build-essential
RUN mkdir /var/run/sshd
RUN echo root:1 | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# ssh login fix, otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN cd /home/work && \
	wget https://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/aarch64-linux-gnu/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz &&\
	tar xf gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz 
RUN git clone https://github.com/openssl/openssl.git && cd openssl/ && \
	../Configure linux-aarch64 --cross-compile-prefix=/home/work/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu- -static && \
	make -j16 && make install
