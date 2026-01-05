# fast-decode涉及参数变化

## loop restoration :

### self-guided restoration filter:

- @param >=1 并且分辨率大于360P

    sg_filter_lvl = 0;  关闭SelfGuided滤波
    
### DLF Deblock loop filter
  
    对于M5 Preset
    dlf_level  3->4
    ------------------------------------------
    zero_filter_strength_lvl    0->2(还有空间)
    prev_dlf_dist_th            0->10(还有空间)

#### dlf_level 影响的控制参数

1. dlf_avg 
    
    svt_av1_pick_filter_level()中使用, 影响搜索起点; 表示是否启用 **基于参考帧的滤波器强度平均值** 作为当前帧的初始 Loop Filter Level(去块滤波器强度);快速、低复杂度的滤波强度选择策略，避免每次都进行耗时的搜索. 

2. use_ref_avg_y && use_ref_avg_uv
    
    是否直接使用参考帧的滤波强度平均值作为当前帧的 Loop Filter Level(去块滤波强度). 

3. early_exit_convergence 在2里

    收敛点数量（1=首次收敛即退出，1=第二次收敛即退出, 0=关闭）; 在 search_filter_level() 函数内部的迭代或步进搜索过程中，若检测到“失真-滤波强度”曲线已趋于收敛（即继续增加滤波强度带来的收益极小），则提前退出搜索

### CDEF Constrained Directional Enhanced Filter
fast-decode 越大，使用高cdef_recon_level的preset门槛越低,cdef控制中的zero_fs_cost_bias和zero_filter_strength_lvl就越高

    对于M5 Preset
    cdef_recon_level            0   ->  1   ->  1
    ------------------------------------------
    zero_fs_cost_bias           0   ->  61  (还有空间[/64])
    zero_filter_strength_lvl    0   ->  2   (还有空间[0..4])
    prev_cdef_dist_th           0   ->  10  (还有空间)


### MFMV Motion Field Motion Vector
(非I帧且打开mfmv且容错模式为0时)

    对于M5 Preset
    mfmv_level          1   ->  1   ->  3
    
- @param = 0
    Preset <=5  : mfmv_level = 1
    Preset <=9  : mfmv_level = 2(不是360p以下)
    else        : cdef_recon_level = 4(不是360p以下)
- @param = 1
    Preset <=5  : mfmv_level = 1
    Preset <=7  : mfmv_level = 2(不是360p以下)
    else        : mfmv_level = 4(不是360p以下)
- @param = 2
    Preset <=5  : mfmv_level = 3(不是360p以下)
    else        : mfmv_level = 4(不是360p以下)

### MRP

### Filter Intra Level
use_accurate_part_ctx


## v2.0.0

### OBMC Level

### pic_depth_removal_level


### use_ref_frame_mvs

### wm_level    wrapped motion