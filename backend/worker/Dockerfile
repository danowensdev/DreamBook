FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

# Install miniconda
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
RUN apt-get update

RUN apt-get install -y git wget && rm -rf /var/lib/apt/lists/*

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 
RUN conda --version


RUN git clone https://github.com/CompVis/stable-diffusion.git

COPY "environment.yml" "stable-diffusion/environment.yaml"

RUN cd stable-diffusion && conda env create -f environment.yaml

COPY "src" "./src"

ENTRYPOINT ["conda" ,"run", "--no-capture-output", "-n", "ldm", "python3", "./src/server.py"]