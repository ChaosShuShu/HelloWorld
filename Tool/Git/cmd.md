# Valgrind

## memory check
```bash
valgrind --leak-check=full --show-reachable=yes --track-origins=yes --log-file=valgrind.log cmd
```

## callgrind
```bash
valgrind --tool=callgrind --callgrind-out-file=callgrind.out 
```

# MG compile ffmpeg
```bash
./configure --prefix=/home/chaos/ccProj/ffmpeg_build --pkgconfigdir=/home/chaos/ccProj/ffmpeg_build/install/lib/pkgconfig --extra-cflags=-I/home/chaos/ccProj/ffmpeg_build/install/include --extra-ldflags="-L/home/chaos/ccProj/ffmpeg_build/install/lib -Wl,-rpath,/home/chaos/ccProj/ffmpeg_build/install/lib " --extra-libs='-lpthread -lm' --enable-shared --disable-static --enable-gpl --enable-libx265
```
