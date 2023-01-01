# AutoDock-Vina-Docker
# https://github.com/Metaphorme/AutoDock-Vina-Docker
# MIT License
# Copyright (c) 2022 Metaphorme <https://github.com/Metaphorme>


FROM ubuntu:latest as builder

RUN /bin/bash -c " \
    set -ex \
    && apt-get update; apt-get install -y swig curl build-essential git libboost-all-dev \
    && git clone https://github.com/ccsb-scripps/AutoDock-Vina /app/AutoDock-Vina \
    && cd /app/AutoDock-Vina/build/linux/release; make \
    "


FROM continuumio/miniconda3:latest

LABEL org.opencontainers.image.authors="Metaphorme" \
      org.opencontainers.image.description="https://github.com/Metaphorme/AutoDock-Vina-Docker"

COPY --from=builder /app/AutoDock-Vina /opt/AutoDock-Vina

VOLUME /data

RUN /bin/bash -c " \
    set -ex \
    && apt-get update; apt-get install -y curl vim libgomp1 g++ make \
    && conda create -n vina python=3 \
    && source /root/.bashrc; conda activate vina \
    && conda config --env --add channels conda-forge \
    && conda install -c conda-forge numpy boost-cpp swig openbabel scipy; pip --no-cache-dir install meeko rdkit pandas \
    && sed -i 's/base/vina/g' /root/.bashrc \
    && cd /opt/AutoDock-Vina/build/python; python setup.py build install \
    && cd /tmp; curl -SL https://ccsb.scripps.edu/adfr/download/1038 | tar -zx; cd ADFRsuite_x86_64Linux_1.0; ./install.sh -d /opt/adfr/ -c 1 -l \
    && conda clean --all; apt-get purge -y --auto-remove g++ make; rm -rf /tmp/* \
    "

ENV PATH=$PATH:/opt/adfr/bin/:/opt/AutoDock-Vina/build/linux/release/

WORKDIR /data
