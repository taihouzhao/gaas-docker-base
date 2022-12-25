FROM nvidia/cuda:11.3.0-devel-ubuntu20.04

RUN apt-get update
RUN apt-get install wget git -y
RUN rm -rf /var/lib/apt/lists/*
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN mkdir /root/.conda
RUN bash Miniconda3-latest-Linux-x86_64.sh -b
RUN rm -f Miniconda3-latest-Linux-x86_64.sh
ENV PATH="/root/miniconda3/bin:${PATH}"

RUN conda install pytorch==1.12.1 torchvision==0.13.1 torchaudio==0.12.1 cudatoolkit=11.3 -c pytorch -y
ENV TORCH_CUDA_ARCH_LIST="6.1 7.5 8.6"
RUN conda install xformers -c xformers/label/dev

RUN pip install --no-cache-dir --upgrade diffusers[training] accelerate transformers

ENV HF_HOME=/HF
ENV USE_MEMORY_EFFICIENT_ATTENTION=1
