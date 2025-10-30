# 交叉编译流程

# 1 获取target信息

```shell
[target]:   uname -m    # 获取目标架构

[target]:   ldd --version   # 查看C标准库类型** 

[target]:   uname -r  # 查看内核版本(辅助)

[target]:   cat /etc/os-release  # 查看操作系统版本


```

graph TD
    A[目标系统] --> B{能运行 uname -m 吗?}
    B -->|是| C[记录架构: aarch64/armv7l/x86_64...]
    B -->|否| D[查硬件手册或文档]
    C --> E{ldd /bin/sh 或 readelf 看 interpreter}
    E -->|/lib/ld-linux-*.so.*| F[glibc → 用 *-linux-gnu]
    E -->|/lib/ld-musl-*.so.*| G[musl → 用 *-linux-musl]
    E -->|/system/bin/linker*| H[Android → 用 NDK]
    E -->|其他| I[查发行版或构建系统]