# Fast compile ffmpeg On IMGO server
```bash
./configure --prefix=/home/ops/shuchao/libins --pkgconfigdir=/home/ops/shuchao/libins/install/lib/pkgconfig --extra-cflags=-I/home/ops/shuchao/libins/install/include --extra-ldflags="-L/home/ops/shuchao/libins/install/lib -Wl,-rpath,/home/ops/shuchao/libins/install/lib " --extra-libs='-lpthread -lm' --enable-shared --disable-static --enable-gpl --enable-libzimg
```

```bash
./configure --pkg-config-flags=--static --enable-gpl --enable-nonfree --extra-ldflags=-lm -static --extra-ldflags=-ldl --enable-libfreetype --enable-libass --enable-libfdk-aac --enable-libxcoder --enable-openssl --enable-pthreads --extra-libs=-lrt -lpthread -static --enable-encoders --enable-decoders --enable-avfilter --enable-muxers --enable-demuxers --enable-parsers --extra-version=static --disable-debug --disable-shared --enable-static --extra-cflags=--static --disable-optimizations --disable-asm --disable-stripping --enable-debug=3 --disable-ffplay --enable-ffprobe --enable-libx264 --enable-libx265 --disable-cuda-nvcc --disable-cuda --disable-cuvid --disable-nvdec --disable-nvenc --disable-libvmaf --enable-static --disable-shared
```

# Fast compile ffmpeg On Studio
```bash
./configure --prefix=/home/chaos/ccProj/ffmpeg_build --pkgconfigdir=/home/chaos/ccProj/ffmpeg_build/install/lib/pkgconfig --extra-cflags=-I/home/chaos/ccProj/ffmpeg_build/install/include --extra-ldflags="-L/home/chaos/ccProj/ffmpeg_build/install/lib -Wl,-rpath,/home/chaos/ccProj/ffmpeg_build/install/lib " --extra-libs='-lpthread -lm' --enable-shared --disable-static --enable-gpl --enable-libzimg
```

## Debug Version
```bash
--enable-debug=3 --disable-optimizations --disable-stripping
```

# ffmpeg test command On IMGO server
```bash
./ffmpeg -i input.mp4 -vf "[INPUT]zscale=t=linear:npl=100,format=gbrpf32le,zscale=p=bt709,tonemap=tonemap=hable:desat=0,zscale=t=bt709:m=bt709:r=tv,format=yuv420p,fps=25[OUTPUT]" -f rawvideo /home/ops/shuchao/seq/output_ori.yuv
```

# run Docker container
```bash
docker run --shm-size 256G -t -i -e LANG=C.UTF-8 -v /home:/home -v /data:/data --name="ffmpeg_test" ubuntu18.04:ffmpeg_zhousq /bin/bash
```

# exec Docker container
```bash
sudo docker exec -it 8304214ae6f6 /bin/bash
```

# monut company cloud-disk
```bash
sudo mkdir -p /data/y
mount -t cifs -o username=---,password=--- //10.1.200.13/m3u8 /data/y
```

