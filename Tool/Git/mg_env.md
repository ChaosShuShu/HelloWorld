# Extra ROI_transcode packages

## Config Conda & pip
  - conda config --add channels https://mirrors.bfsu.edu.cn/anaconda/cloud/pytorch/
  - conda config --add channels https://mirrors.bfsu.edu.cn/anaconda/pkgs/main/
  - conda config --add channels https://mirrors.bfsu.edu.cn/anaconda/pkgs/free/
  - conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch/linux-64/
  - conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch/
  - conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
  - conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/

  - conda create -n ENV_AME python=311
  - conda activate ENV_AME
  - pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

## Install packages
  - conda install pytorch==1.8.0 torchvision==0.9.0 torchaudio==0.8.0 cudatoolkit=11.1 -c pytorch -c conda-forge
  - pip install numpy==1.24 numba==0.54.1 scikit-image==0.19.0 
  - pip install onnx==1.12.0 onnxruntime-gpu==1.11.0
  - python -m pip install tb-nightly -i https://mirrors.aliyun.com/pypi/simple
  - pip install addict future lmdb opencv-python Pillow pyyaml request scipy tqdm yapf thop timm einops av
  - pip install malplotlib

## Extra config
2. install matplotlib
3. install pyclipper
4. install shapely


# Linux environment setup

## Terminal
1. Install zsh: `sudo apt-get install zsh`
2. Install oh-my-zsh: `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`

1. 查看当前默认 Shell
```bash
echo $SHELL
```
或者查看 /etc/passwd 文件中当前用户对应的 Shell：
```bash
grep $USER /etc/passwd
```
2. 查看可用的 Shell
在 Linux 系统中，所有可用的 Shell 都记录在 /etc/shells 文件中。你可以通过以下命令查看所有可用的 Shell：
```bash
cat /etc/shells
```

3. 更改默认 Shell
使用 chsh 命令更改默认 Shell。以下是具体步骤:
```bash

chsh    #步骤 1：运行 chsh 命令
#运行后，系统会提示你输入新的默认 Shell。

#在提示中输入目标 Shell 的完整路径。例如，如果你想将默认 Shell 更改为 zsh，输入：
/bin/zsh    #步骤 2：新的选择 Shell

#如果你选择的 Shell 不在 /etc/shells 文件中，系统可能会拒绝更改。
#更改完成后，退出当前会话并重新登录，以使更改生效。你可以再次运行以下命令验证更改：
echo $SHELL #步骤 3：确认更改
```

## VSCodium
1. CDT GDB Debug Adapter Extension + MemoryInspector
2. clangd
3. FittenCode
4. GitLens
