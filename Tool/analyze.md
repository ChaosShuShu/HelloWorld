# perf
perf -g ./my_program

# compile flags
-flto 通过链接时的全局分析，打破了传统编译的单文件优化限制，能显著提升程序性能或减小体积，但代价是更长的编译时间和更高的内存占用。推荐在发布构建（Release Build）中启用，调试阶段关闭。

