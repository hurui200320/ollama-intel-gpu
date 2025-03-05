FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=america/los_angeles

# Base packages
RUN apt update && \
    apt install --no-install-recommends -q -y \
    software-properties-common \
    ca-certificates \
    wget \
    ocl-icd-libopencl1 \
    nano

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
ENV OLLAMA_NUM_GPU=999
ENV GIN_MODE=release
ENV no_proxy=localhost,127.0.0.1
ENV ZES_ENABLE_SYSMAN=1
ENV SYCL_CACHE_PERSISTENT=1
ENV OLLAMA_KEEP_ALIVE=10m
# [optional] under most circumstances, the following environment variable may improve performance, but sometimes this may also cause performance degradation
ENV SYCL_PI_LEVEL_ZERO_USE_IMMEDIATE_COMMANDLISTS=1
# [optional] if you want to run on single GPU, use below command to limit GPU may improve performance
# ENV ONEAPI_DEVICE_SELECTOR=level_zero:0
# If you have more than one dGPUs, according to your configuration you can use configuration like below, it will use the first and second card.
# ENV ONEAPI_DEVICE_SELECTOR="level_zero:0;level_zero:1"

ENTRYPOINT ["./ollama", "serve"]
