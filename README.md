# AutoDock-Vina-Docker

[![Build AutoDock Image](https://github.com/Metaphorme/AutoDock-Vina-Docker/actions/workflows/build_autodock.yml/badge.svg)](https://github.com/Metaphorme/AutoDock-Vina-Docker/actions/workflows/build_autodock.yml)
[![Build MGLTools Image](https://github.com/Metaphorme/AutoDock-Vina-Docker/actions/workflows/build_mgltools.yml/badge.svg)](https://github.com/Metaphorme/AutoDock-Vina-Docker/actions/workflows/build_mgltools.yml)
[![UpdateChecker](https://img.shields.io/badge/Update%20Checker-latest-green?logo=TryHackMe)](https://github.com/Metaphorme/AutoDock-Vina-Docker/actions/workflows/update-checker.yml)
![License](https://img.shields.io/github/license/Metaphorme/AutoDock-Vina-Docker?logo=opensourceinitiative)

Package [AutoDock Vina](https://github.com/ccsb-scripps/AutoDock-Vina), [ADFR suite](https://ccsb.scripps.edu/adfr/), [Meeko](https://github.com/forlilab/Meeko), [MGLTools](https://ccsb.scripps.edu/mgltools/) into Docker image.

**Notice:** Please makesure you will obey the License of [AutoDock Vina](https://autodock-vina.readthedocs.io/en/latest/citations.html), [ADFR software suite Non-Commercial Use](https://ccsb.scripps.edu/adfr/license/), [Meeko](https://github.com/forlilab/Meeko/blob/develop/LICENSE) before downloading this Docker image.

## Introduction

We provide [vina](https://github.com/users/Metaphorme/packages/container/package/vina), [vina-python](https://github.com/users/Metaphorme/packages/container/package/vina-python), [vina-all](https://github.com/users/Metaphorme/packages/container/package/vina-all) package for you to choose. Please refer to the table below to compare the differences.

| Package                                                      | Included programs                                            | Arch        |
| :----------------------------------------------------------- | ------------------------------------------------------------ | ----------- |
| [vina](https://github.com/users/Metaphorme/packages/container/package/vina) | vina binary, vice versa                                      | amd64/arm64 |
| [vina-python](https://github.com/users/Metaphorme/packages/container/package/vina-python) | vina binary, vice versa, vina python bindings, Meeko         | amd64/arm64 |
| [vina-all](https://github.com/users/Metaphorme/packages/container/package/vina-all) | vina binary, vice versa, vina python bindings, Meeko, ADFR Suite | amd64       |
| [AutoDockTools (MGLTools)](https://github.com/users/Metaphorme/packages/container/package/mgltools) | MGLTools                                                     | amd64       |

Because of the lack arm64 support of **ADFR Suite** and **MGLTools**, we can't provide arm64 images with ADFR Suite and MGLTools.

## Get Docker Image

### From Github

```bash
# vina
# Build from https://github.com/ccsb-scripps/AutoDock-Vina/tree/release
docker pull ghcr.io/metaphorme/vina:release
# Build from https://github.com/ccsb-scripps/AutoDock-Vina/tree/develop
docker pull ghcr.io/metaphorme/vina:develop

# vina-python
# Build from https://github.com/ccsb-scripps/AutoDock-Vina/tree/release
docker pull ghcr.io/metaphorme/vina-python:release
# Build from https://github.com/ccsb-scripps/AutoDock-Vina/tree/develop
docker pull ghcr.io/metaphorme/vina-python:develop

# vina-all
# Build from https://github.com/ccsb-scripps/AutoDock-Vina/tree/release
docker pull ghcr.io/metaphorme/vina-all:release
# Build from https://github.com/ccsb-scripps/AutoDock-Vina/tree/develop
docker pull ghcr.io/metaphorme/vina-all:develop

# MGLTools
docker pull ghcr.io/metaphorme/mgltools
```

### Build in local

```bash
git clone https://github.com/Metaphorme/AutoDock-Vina-Docker.git
cd AutoDock-Vina-Docker
# To build Dockerfile-vina* image
docker build --build-arg BRANCHES=[release or develop] -t TAG_NAME - < Dockerfile-vina-[name]
# To build MGLTools image
docker build -t mgltools - < Dockerfile-mgltools
```

## Run Docker Image

## vina

* Exec commands and mount $PWD to /data

  ```bash
  docker run -v $PWD:/data --rm ghcr.io/metaphorme/vina:release \
        vina --ligand 1iep_ligand.pdbqt --maps 1iep_receptor --scoring ad4 \
             --exhaustiveness 32 --out 1iep_ligand_ad4_out.pdbqt
  ```

​		**Notice:** `$PWD` means the current working directory; `/data` is contained in $PATH.

## vina-python

* Enter the shell and mount $PWD to /data

  ```bash
  docker run -it -v $PWD:/data --rm ghcr.io/metaphorme/vina-python:release
  ```

  **Notice:** `$PWD` means the current working directory; `/data` is contained in $PATH.

* Commands (For example)

  ```bash
  # AutoDock Vina
  vina
  # AutoDock Vina Python bindings
  mk_prepare_ligand.py
  ```

* Software Locations

  ```bash
  # AutoDock Vina
  /opt/AutoDock-Vina
  # miniconda
  /opt/conda
  ```

## vina-all

* Enter the shell and mount $PWD to /data

  ```bash
  docker run -it -v $PWD:/data --rm ghcr.io/metaphorme/vina-all:release
  ```

	**Notice:** `$PWD` means the current working directory.

* Commands (For example)

  ```bash
  # AutoDock Vina
  vina
  # AutoDock Vina Python bindings
  mk_prepare_ligand.py
  # ADFR Suite
  prepare_receptor
  autogrid4
  # Python2
  pythonsh
  ```

* Software Locations

  ```bash
  # AutoDock Vina
  /opt/AutoDock-Vina
  # ADFR Suite
  /opt/adfr
  # miniconda
  /opt/conda
  ```

## MGLTools

**Notice: MGLTools image is working well on macOS, it havn't been tested on other platforms. It may not be able to work directly on Linux, for more info, please [check](https://stackoverflow.com/questions/48546124/what-is-linux-equivalent-of-host-docker-internal).**

* Setup [XQuartz](https://www.xquartz.org/)

* Enable GLX

  ```bash
  # Run in Terminal
  defaults write org.macosforge.xquartz.X11 enable_iglx -bool true
  ```

* Add localhost into access control list (Run every time you restart your computer)

  ```bash
  # Run in Terminal
  xhost +localhost
  ```

* Mount $PWD to /data and Run MGLTools

  ```bash
  docker run --rm -it -v $PWD:/data -v /tmp/.X11-unix:/tmp/.X11-unix ghcr.io/metaphorme/mgltools
  ```

**Notice: If the window of AutoDockTools disappeared, open XQuartz -> Windows -> AutoDockTools to turn it up.**

## Contribute

Contributions welcome! Please open an issue to discuess at first, fork this repository and submit a pull request.

## Credits

* [AutoDock Vina](https://vina.scripps.edu/)

* [ADFR suite](https://ccsb.scripps.edu/adfr/)

* [Meeko](https://github.com/forlilab/Meeko/blob/develop/LICENSE)

* [AutoDockTools (MGLTools)](https://github.com/users/Metaphorme/packages/container/package/mgltools)

* [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)

* [Mac OSX Catalinaに導入したDocker上でAutoDock Toolsを動かす](https://itsuka-naritai.com/2020/10/27/mac-osx-catalina%e3%81%ab%e5%b0%8e%e5%85%a5%e3%81%97%e3%81%9fdocker%e4%b8%8a%e3%81%a7autodock-tools%e3%82%92%e5%8b%95%e3%81%8b%e3%81%99/)

## License

* [AutoDock Vina](https://autodock-vina.readthedocs.io/en/latest/citations.html)

* [ADFR suite Non-Commercial Use](https://ccsb.scripps.edu/adfr/license/)

* [Meeko](https://github.com/forlilab/Meeko/blob/develop/LICENSE)

* [Metaphorme/AutoDock-Vina-Docker](https://github.com/Metaphorme/AutoDock-Vina-Docker/blob/main/LICENSE)

  ```
  MIT License
  
  Copyright (c) 2022 Diazepam
  
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:
  
  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.
  
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
  ```
