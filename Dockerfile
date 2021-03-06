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
# For Google Cloudbuld builds, do the following before running cargo commands:
RUN mkdir /root/.cargo \
 && echo "[net]\ngit-fetch-with-cli=true" > /root/.cargo/config.toml

# Install toml-cli for toml file manipulation
RUN cargo install toml-cli --version  0.2.0

# Check the versions
RUN rustc --version \
 && flatc --version
