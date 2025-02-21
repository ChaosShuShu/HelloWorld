# Extra ROI_transcode packages
1. upgrade pillow from 9.3.0
2. install matplotlib
3. install pyclipper
4. install shapely
5. revert numpy to <1.22.3>


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
