FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=america/los_angeles

# Base packages
RUN apt update && \
    apt install --no-install-recommends -q -y \
    software-properties-common \
    ca-certificates \
    wget \
    ocl-icd-libopencl1

# Intel GPU compute user-space drivers
RUN mkdir -p /tmp/gpu && \
 cd /tmp/gpu && \
 wget https://github.com/oneapi-src/level-zero/releases/download/v1.20.2/level-zero_1.20.2+u24.04_amd64.deb && \
 wget https://github.com/intel/intel-graphics-compiler/releases/download/v2.7.11/intel-igc-core-2_2.7.11+18581_amd64.deb && \
 wget https://github.com/intel/intel-graphics-compiler/releases/download/v2.7.11/intel-igc-opencl-2_2.7.11+18581_amd64.deb && \
 wget https://github.com/intel/compute-runtime/releases/download/25.05.32567.17/intel-level-zero-gpu_1.6.32567.17_amd64.deb && \
 wget https://github.com/intel/compute-runtime/releases/download/25.05.32567.17/intel-opencl-icd_25.05.32567.17_amd64.deb && \
 wget https://github.com/intel/compute-runtime/releases/download/25.05.32567.17/libigdgmm12_22.6.0_amd64.deb && \
 dpkg -i *.deb && \
 rm *.deb

# Install Ollama Portable Zip 
RUN cd / && \
  wget https://github.com/intel/ipex-llm/releases/download/v2.2.0-nightly/ollama-0.5.4-ipex-llm-2.2.0b20250226-ubuntu.tgz && \
  tar xvf ollama-0.5.4-ipex-llm-2.2.0b20250226-ubuntu.tgz --strip-components=1 -C /

ENV OLLAMA_HOST=0.0.0.0:11434
ENV ZES_ENABLE_SYSMAN=1

ENTRYPOINT ["/bin/bash", "/start-ollama.sh"]
