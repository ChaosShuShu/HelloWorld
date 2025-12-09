# Test Encoder

## run svt-avt base 
```shell
.\SvtAv1EncApp.exe -i D:\seq\yuv\1920x1080_yuv420p.yuv  -w 1920 -h 1080  -q 22 --frames 50 -b roi_test.ivf
```

### roi encode
.\SvtAv1EncApp.exe -i /media/microfost1/seq/yuv/1920x1080_yuv420p.yuv -w 1920 -h 1080  -q 22 --frames 50 -b roi_test.ivf --roi-map-file /media/microsoft1/data/output/roi/0.roi

### run svtav1 2pass CBR
.\SvtAv1EncApp -i ${src} -w 1920 -h 1080 --fps 25 --rc 1 --tbr 2041 --passes 2 --preset 5 --stats ${logpath}_pass_stats.stat --lookahead 35 --keyint 125 --tile-rows ${row} --tile-columns ${col} --hierarchical-levels 2 --enable-stat-report 0 --color-primaries bt709 --matrix-coefficients bt709 -b ${dst} > ${log} 2>&1

### Online 2pass av1
/data/y/mgtvcloud/bin_update_union/transcoder/tool/ffmpeg_av1  -i ${input}   -vf "[INPUT]scale='min(1920,trunc((1080*dar+0.5)/2)*2)':'min(1080,trunc((1920/dar+0.5)/2)*2)'[FID1];[FID1]setsar='r=1/1',fps=25[OUTPUT]"   -r 25 -c:v libsvtav1 -b:v 1379k -preset 5 -g 125 -keyint_min 125 -svtav1-params "pass=1:lookahead=35" -colorspace bt709 -color_primaries bt709 -pix_fmt yuv420p -flags +loop+qpel -an   -sws_flags fast_bilinear -me_range 24 -coder vlc -me_method dia -partitions +parti4x4+parti8x8+partp8x8 -fastfirstpass 1 -svtav1-passlogfile /data/y/mgtvcloud/log/20250604/362959/v_0_passlog_2025-06-04_09-37-26.stats -flags +psnr -t 430 -y  ${output}

#### Once Edition
./ffmpeg -i ../../shuchao/seq/av1Source.mp4  -vf "[INPUT]scale='min(1920,trunc((1080*dar+0.5)/2)*2)':'min(1080,trunc((1920/dar+0.5)/2)*2)'[FID1];[FID1]setsar='r=1/1',fps=25[OUTPUT]"   -r 25 -c:v libsvtav1 -b:v 1379k -preset 3 -g 125 -keyint_min 125 -svtav1-params "passes=2:lookahead=35:tile-rows=0:tile-columns=1:hierarchical-levels=2:fast-decode=2:stats="tmp.stats"" -colorspace bt709 -color_primaries bt709 -pix_fmt yuv420p -flags +loop+qpel -an   -sws_flags fast_bilinear -me_range 24 -coder vlc -t 430 -y tmp.mp4

## Full Vivid
```bash
$x265
./x265 --input-res 3840x2160 --fps 50 --keyint 125 --min-keyint 125 --no-scenecut --hdr-opt --colorprim bt2020 --transfer smpte2084 --colormatrix bt2020nc --master-display "G(13250,34500)B(7500,3000)R(34000,16000)WP(15635,16450)L(10000000,500)" --max-cll "1000,500" --no-hrd --input-depth 10 --repeat-headers --ref 3 --b-adapt 2 --bitrate 3456 --bframes 3 --no-open-gop -D 10 --frames 500 --input /media/microsoft1/seq/yuv/mgvivid_3840x2160_f50.yuv --output bs_ori_vivid_off.265 --vivid-opt 1 --vivid-level 2
```
```bash
$ffmpeg

```

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

## Compile encoder
```bash
--enable-libx265 --enable-libx264
```

# ffmpeg test command On IMGO server
```bash
$tonemap
./ffmpeg -i input.mp4 -vf "[INPUT]zscale=t=linear:npl=100,format=gbrpf32le,zscale=p=bt709,tonemap=tonemap=hable:desat=0,zscale=t=bt709:m=bt709:r=tv,format=yuv420p,fps=25[OUTPUT]" -f rawvideo /home/ops/shuchao/seq/output_ori.yuv
```

```bash
$tonemap and x264 encoding
./ffmpeg -i "a.mov" -vf "[INPUT]zscale=t=linear:npl=100,format=gbrpf32le,zscale=p=bt709,tonemap=tonemap=hable:desat=0,zscale=t=bt709:m=bt709:r=tv,format=yuv420p,fps=25[OUTPUT]" -r 25 -c:v libx264 -profile:v high -x264opts force-cfr:fps=25:keyint=125:min-keyint=125:scenecut=0:colorprim=bt709:transfer=bt709:colormatrix=bt709:ref=1:b-adapt=0:qp=15:deblock=0,0:psy-rd=1.0,0  -preset veryfast -color_range tv -colorspace bt709 -color_primaries bt709 -pix_fmt yuv420p -flags +loop+qpel -acodec libfdk_aac -strict -2 -ac 2 -ar 44100 -ab 384k -cutoff 20000 -psnr -y "b.ts"
```

# Docker
## run Docker container
```bash
docker run --shm-size 256G -t -i -e LANG=C.UTF-8 -v /home:/home -v /data:/data --name="ffmpeg_test" ubuntu18.04:ffmpeg_zhousq /bin/bash
```

## exec Docker container
```bash
sudo docker exec -it 8304214ae6f6 /bin/bash
```

## mount company cloud-disk
```bash
sudo mkdir -p /data/y
mount -t cifs -o username=m3u8,password=5c3op_we14pc0Cu //10.1.200.13/m3u8 /data/y
```
# Valgrind

## memory check
```bash
valgrind --leak-check=full --show-reachable=yes --track-origins=yes --log-file=valgrind.log cmd
```

## callgrind
```bash
valgrind --tool=callgrind --callgrind-out-file=callgrind.out 
```

# MG Server compile ffmpeg
```bash
./configure --prefix=/home/chaos/ccProj/ffmpeg_build --pkgconfigdir=/home/chaos/ccProj/ffmpeg_build/install/lib/pkgconfig --extra-cflags=-I/home/chaos/ccProj/ffmpeg_build/install/include --extra-ldflags="-L/home/chaos/ccProj/ffmpeg_build/install/lib -Wl,-rpath,/home/chaos/ccProj/ffmpeg_build/install/lib " --extra-libs='-lpthread -lm' --enable-shared --disable-static --enable-gpl --enable-libx265
```

