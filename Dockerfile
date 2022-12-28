FROM nvidia/cuda:11.6.1-devel-ubuntu20.04

RUN apt-get update \
    && apt-get install wget git g++ -y \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh

ENV PATH="/root/miniconda3/bin:${PATH}"

RUN conda create -n xformers python=3.10
SHELL ["conda", "run", "--no-capture-output", "-n=xformers", "/bin/bash", "-c"]

WORKDIR /tmp/xformers
RUN git clone --depth 1 https://github.com/facebookresearch/xformers.git /tmp/xformers \
    && git checkout main \
    && git submodule update --init --recursive

RUN pip install -r requirements.txt --extra-index-url https://download.pytorch.org/whl/cu116
RUN FORCE_CUDA=1 TORCH_CUDA_ARCH_LIST="6.0;6.1;6.2;7.0;7.2;7.5;8.0;8.6" pip wheel . --no-deps
RUN mkdir /out && cp /tmp/xformers/xformers-* /out/


RUN pip install --no-cache-dir --upgrade diffusers[training] accelerate transformers

ENV HF_HOME=/HF
ENV USE_MEMORY_EFFICIENT_ATTENTION=1
