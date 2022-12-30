FROM nvidia/cuda:11.6.1-base-ubuntu20.04

RUN apt-get update \
    && apt-get install wget git -y \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh

ENV PATH="/root/miniconda3/bin:${PATH}"

RUN pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu116

RUN wget "https://github.com/ysmu/xformers-docker/releases/download/py3.10_cu11.6.1_arch6.0%3B6.1%3B6.2%3B7.0%3B7.2%3B7.5%3B8.0%3B8.6_main/xformers-0.0.15.dev0+4c06c79.d20221206-cp310-cp310-linux_x86_64.whl" \
    && pip install xformers-0.0.15.dev0+4c06c79.d20221206-cp310-cp310-linux_x86_64.whl

RUN pip install git+https://github.com/huggingface/diffusers
RUN pip install --no-cache-dir accelerate transformers>=4.25.1 ftfy tensorboard modelcards

ENV HF_HOME=/HF
ENV USE_MEMORY_EFFICIENT_ATTENTION=1

RUN python -m xformers.info 