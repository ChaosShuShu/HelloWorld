# 参考帧列表

当前帧的参考帧列表共7个，分别为：
- 0: LAST
- 1: LAST2
- 2: LAST3
- 3: GOLDEN
- 4: BWDREF
- 5: ALTREF2
- 6: ALTREF

参考帧列表的生成规则为：（暂未理清）

# DPB 状态更新

DPB中最多存储8帧，svt-av1将DPB划分为不同的类别，以其时域结构为依据， 0-2帧为base层帧，3-4帧为Lay1层帧，5为Lay2层帧（还会为长期参考帧保留一帧， 另外一帧忘了， 括号中内容待重新确认）

AV1 的DPB更新策略较简单， 由每帧的FrameHeader中记录的当前DPB状态的更新标志:**ref_frame_flags**决定； **ref_frame_flags**为一个8bit数据，每bit对应DPB的一个槽位，bit为1表示当前帧解码完成后替换DPB中对应位置的帧并用作后续的参考帧。

svt-av1在编码时根据自己的策略更新DPB状态```svt_aom_picture_decision_kernel->av1_generate_rps_info```，并生成**ref_frame_flags**（目前尚未在标准中发现强制**的ref_frame_flags**生成策略， 待确认）。


# GOP结构

下方注释阐释了svt-av1在遇到SC或CRA帧时， 对前一"GOP"的剩余帧的帧类型划分方式
```cpp
/*
*        Distance to scene change ------------>
*
*                  0              1                 2                3+
*   I
*   n
*   t   0        I   I           n/a               n/a              n/a
*   r
*   a              p              p
*                   \            /
*   P   1        I   I          I   I              n/a              n/a
*   e
*   r               p                               p
*   i                \                             /
*   o            p    \         p   p             /   p
*   d             \    \       /     \           /   /
*       2     I    -----I     I       I         I----    I          n/a
*   |
*   |            p   p           p   p            p   p            p   p
*   |             \   \         /     \          /     \          /   /
*   |              P   \       /   p   \        /   p   \        /   P
*   |               \   \     /     \   \      /   /     \      /   /
*   V   3+   I       ----I   I       ----I    I----       I    I----       I
*/
```


# 代码流程
1. 设置帧是否作为参考的状态is_ref
2. 根据pred_struct选择不同设置ref_pic_list的策略并**设置ref_frame_flags**
    - FLAT IPP
    - LD + CQP/CRF
    - LD + CBR
    - RA
        - hierarchical level = 0
        - hierarchical level = 1
        - hierarchical level = 2
        - hierarchical level = 3
        - hierarchical level = 4
            - temporal level = 0
            - temporal level = 1 ...
            - temporal level = 2 ...
            - ...
