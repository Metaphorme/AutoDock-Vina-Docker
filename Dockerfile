# AutoDock-Vina-Docker
# https://github.com/Metaphorme/AutoDock-Vina-Docker
# MIT License
# Copyright (c) 2022 Metaphorme <https://github.com/Metaphorme>

FROM continuumio/miniconda3:latest


LABEL org.opencontainers.image.authors="Metaphorme" \
      org.opencontainers.image.documentation="https://github.com/Metaphorme/AutoDock-Vina-Docker"

ENV PATH=$PATH:/opt/adfr/bin/

VOLUME /data

RUN /bin/bash -c " \
    set -ex \
    && apt-get update; apt-get install -y swig curl build-essential git libboost-all-dev libgomp1 \
    && conda create -n vina python=3 \
    && source /root/.bashrc; conda activate vina \
    && conda config --env --add channels conda-forge \
    && conda install -c conda-forge numpy boost-cpp swig openbabel scipy; pip --no-cache-dir install meeko rdkit pandas \
    && sed -i 's/base/vina/g' /root/.bashrc \
    && git clone https://github.com/ccsb-scripps/AutoDock-Vina /tmp/AutoDock-Vina; cp -r /tmp/AutoDock-Vina /opt/ \
    && cd /tmp/AutoDock-Vina/build/linux/release; make; mv vina /usr/local/bin/ \
    && cd /tmp/AutoDock-Vina/build/python; python setup.py build install \
    && cd /tmp; curl -SL https://ccsb.scripps.edu/adfr/download/1038 | tar -zx; cd ADFRsuite_x86_64Linux_1.0; ./install.sh -d /opt/adfr/ -c 0 -l \
    && conda clean --all; apt-get purge -y --auto-remove build-essential git; rm -rf /tmp/* /var/lib/apt/lists/* \
    "

WORKDIR /data
