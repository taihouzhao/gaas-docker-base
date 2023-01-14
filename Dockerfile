FROM nvidia/cuda:11.6.1-devel-ubuntu20.04

ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=Etc/UTC

RUN apt-get update \
    && apt-get install wget git vim python3-opencv -y \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh

ENV PATH="/root/miniconda3/bin:${PATH}"

RUN pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu116

RUN pip install git+https://github.com/huggingface/diffusers
RUN pip install --no-cache-dir accelerate transformers>=4.25.1 ftfy tensorboard modelcards

RUN git clone https://github.com/sczhou/CodeFormer
WORKDIR CodeFormer
RUN rm -rf .git assets inputs web-demos
RUN pip install --no-cache-dir --upgrade -r requirements.txt
RUN python basicsr/setup.py develop
RUN python scripts/download_pretrained_models.py all


ENV HF_HOME=/HF
