FROM rust:latest
RUN apt update
RUN apt upgrade -y

RUN apt install cmake -y

RUN cd /opt \
 && git clone https://github.com/google/flatbuffers.git \
 && git checkout tags/v2.0.0 -b latest-release

RUN cd /opt/flatbuffers \
 && cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release    

RUN cd /opt/flatbuffers \
 && make

RUN ln -s /opt/flatbuffers/flatc /usr/local/bin/flatc

RUN chmod +x /opt/flatbuffers/flatc

RUN rustc --version \
 && flatc --version
