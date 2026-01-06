# Picture Decision Kernel
1. 设置预测结构
2. 设置图像类型
3. 执行场景切换检测

# 
- 处理Picture Analysis结果（逐帧）
- 放入reorder队列按POC/picture_number顺序排列
- 放入pre_assigned_buffer并更新状态【存储对应帧的pps】
- 在I帧/包含完整minigop/EOS/预测结构为LD时释放Pre-assigned buffer
    - 设置每个minigop结构
        - initialize_mini_gop_activity_array()  根据配置的hierarchical_level更新允许的MiniGop结构(共31种，见mini_gop_stats_array)
        - generate_picture_window_split()       为允许的MiniGop结构更新起始索引、结束索引、hierarchical_level等状态信息
        - handle_incomplete_picture_window_map() 处理多出的不完整的图像窗，其hierarchical_level = 1(MIN_HIERARCHICAL_LEVEL)
        
        - get_pred_struct_for_all_frames() 设置每帧pcs的pred_struct_ptr:pred_struct—_period pred_type等
    - 处理每个minigop
        - 处理每帧1st:
            - 更新预测结构(提前终止RA周期)及图像类型。
            - 根据帧类型更新一些flag（I帧相关等）
        - 处理每帧2nd:
            - 设置解码顺序
            - 执行场景切换检测
            - 更新码控参数队列
            - 重置预分析(PA, PreAnalysis)参考帧列表
            - 设置decode_base_number（+minigop_length）
        - 存储Minigop图像（分别以Display/Decode顺序存储）
        - 处理Minigop每帧图像：
            - 生成RPS(Reference Picture Set)信息
            - 更新DPB状态（根据上一步的结果，更新ctx.dpb中的对应帧信息）
            - 

