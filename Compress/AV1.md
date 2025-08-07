# Quantization

QP: 0-255, DC is lower than AC

**Frame-level QP modulation**: given a $QP_{base}$, the QP_frame euqals:

|---| AC | DC |
|---|---|---|
| Y | $QP_{base}$ | $QP_{base}$ + $\Delta QP_{Y,DC}$ |
| U | $QP_{base}$ + $\Delta QP_{U,AC}$ | $QP_{base}$ + $\Delta QP_{U,DC}$ |
| V | $QP_{base}$ + $\Delta QP_{V,AC}$ | $QP_{base}$ + $\Delta QP_{V,DC}$ |

$\Delta QP_{X,Y}$ 从FrameHeader中得到.

**Block-level QP modulation**: given a caculated QP_frame, the QP_block equals:

$QP_{cb} = clip(QP_{frame} + \Delta QP_{sb} + \Delta QP_{seg}, 1, 255)$

$\Delta QP_{seg}$ 可通过配置ROI_File得到.

# High-level syntax

SVT-AV1 has default IVF '*container*', it dont produce pure bitstream which mixed with "IVF Unit".

- **Sequence header**: similar to SPS
- **Temporal Delimiters**: All Obus follows a same temporal Delimiter use the same time stamp until the next Temporal Delimiter. Compression data with a frame at various spatial and fidelkity resolutions belong to the same temporal `unit`.
- **Frame header**: similar to Slice Header(contaim the frame type, reference frame list, etc.)
- **Tile Group**: Similar to Slice data, but it contains a littel side information.
- **Frame**: Frame header + Tile Group, allow less overhead cost by obu header.
- **Metadata**: carryies extra information, such as HDR, scalability and timecode.
- **Tile List**: Similar to Tile Group, however, each tile has a additional header of reference frame.

# Reference Frame

解码帧区最大帧数:8, 当前帧能从DPB中任意帧作为参考帧,参考索引为1-7. 一般来讲1-4是leading的, 5-7是trailing的(leading:POC<当前帧, trailing:POC>当前帧). 

复合预测: 
- unidirectional compound prediction 两个参考帧都是同一个方向的(前向或者后向)
- bidirectional compound prediction 两个参考帧是不同方向的.

在预测理论中, 通过同向参考帧外推的预测 通常不如 不同向参考帧向内插值的预测.因此, 单向复合预测两参考帧的组合被限制为(1,2)(1,3)(1,4)/(5,7),序号为参考帧索引.双向复合预测则没有限制仍为3x4种.**[推测:通过延长参考帧时域覆盖度,提高外推的预测准确度]**

## 可选参考帧Alternate reference frame

ARF指将被编码存储在DPB中可控制是否显示的帧, 可作为后续帧的参考帧. 为了传输一帧用于显示, codec既可以新编码一帧, 也可以直接使用DPB中的帧(show existing frame).后续被直接用于显示的ARF,在"金字塔"型结构中可被高效地用于编码后续帧.

此外, 编码器可以设置合成能 降低一段显示帧的总体预测误差 的帧.一个具体的例子就是在连续的原始帧上通过对起运动轨迹时域滤波来生成ARF, 以此保留共有信息并且大大降低每帧的采集噪声.

## 帧缩放

AV1标准支持通过设置 将原始帧下采样后编码, 之后再上采样出同样分辨率的重构帧.在某些帧特别难编码时这个技术将十分有用.

其中, 下采样因子限制在8/16 至15/16; 恢复时先直接上采样至原始size, 之后经过环路恢复滤波器滤波.上采样与环路恢复滤波器参数都在标准中有明确规定. 为了确保硬件在进行此处理时相比常规编码不增加额外代价, 缩放操作仅针对水平方向进行.经恢复后的帧将作为后续帧的参考帧.

# Segmentation
在量化的过程中发现, Block级别的QP修改会涉及一个Segmentation的QPOffset,其描述为一帧可以分类为最多8类Seg...,从码流FrameHeader->uncompressed_header->segmentation_params可以发现Seg相关信息, 每个Seg有独属的QP偏移,环路滤波参数,参考帧,SKIP模式,全局MV等.

## 编码器顶层架构
SVT—AV1是以“工序”`Process`为核心设计的。工序可以是软件中的执行线程，也可以是硬件中的IP核。工序会执行一个或多个编码任务（如运动估计、码率控制、去块滤波等）。工序可以是基于图像控制导向的，也可以是数据处理导向的。控制型工序的一个典型例子是 `图像管理工序`，它决定了预测的结构以及根据解码参考图像缓冲区确定输入图像何时能够用于编码；数据处理型工序的一个典型例子是运动估计工序，它对输入图像进行运动估计以计算运动矢量。每道控制工序只能运行一个实例，因为如果控制决策不是相互协调的，就可能引发数据泄露或死锁等问题。

为了方便在不同平台下的并行处理(例如多核通用CPU、GPU、DSP、FPGA等)，跨工序的通信越少越好。因此SVT-AV1的一个关键设计特征是工序是`无状态`的，所有跟工序状态相关的信息都被转移到跨工序的控制和数据信息中。系统计算管理器（System Resource Manager， SRM）通过FIFO缓冲区管理控制和数据信息的一致性。后续将详述此部分。

这样的架构能够支持让一个SB(Super Block)能灵活地通过整个编码器管道进行编码；当然，编码任务也可以选择在进入下一个任务前处理掉所有的SB。以后者为例，运动估计时，可以先处理掉一帧的全部SB再进入下一个任务。对于码率控制比较重要的统计数据会在在工序流水线前期就进行收集并用于之后的任务。<u>并且为了保持低延时，码率控制会在所有运动估计工序完成前就处理完。</u> 图像的QP是在QP被确定时通过可用的信息推导出的，在编码环路工序中QP可能会以SB为单位改变。

在SVT-AV1编码器中，图像可以被划分为Segment。编码器也能支持不同层级的并行化。
- 工序级并行：  可同时运行不同的工序，并且每一道工序也可以执行编码管道中的不同任务。
- 图像级并行：  一道工序可同时启动多个实例来同时处理不同的图像。
- 段级并行  ：  一个特定工序可同时启动多个实例来同时处理不同的Segment。