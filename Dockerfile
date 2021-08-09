FROM rust:latest
RUN apt update
RUN apt upgrade -y

RUN apt install cmake -y

# Download the latest flatbuffers tag
RUN cd /opt \
 && git clone https://github.com/google/flatbuffers.git \
 && cd /opt/flatbuffers \
 && git checkout tags/v2.0.0 -b latest-release

# Build the flatbuffers tools
RUN cd /opt/flatbuffers \
 && cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release    

RUN cd /opt/flatbuffers \
 && make

# Make flatc runnable and in the path
RUN ln -s /opt/flatbuffers/flatc /usr/local/bin/flatc \
 && chmod +x /opt/flatbuffers/flatc

# Since Cargo does not use the .ssh folder and git does, creating this config file forces
# Cargo to use the git client and so you can access other projects via ssh git URLs
# /root is the generic root home and /builder/home is the home for a google cloudbuild user.
RUN mkdir /root/.cargo \
 && echo "[net]\ngit-fetch-with-cli=true" > /root/.cargo/config.toml \
 && mkdir -p /builder/home/.cargo \
 && chmod a+wr /builder/home \
 && ln -s /root/.cargo /builder/home/ \
 && mkdir /workspace \
 && chmod a+wr /workspace \
 && ln -s /root/.cargo /workspace/

# Check the versions
RUN rustc --version \
 && flatc --version
