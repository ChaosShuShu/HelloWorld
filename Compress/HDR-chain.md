# 一. 综述
HDR10 技术原理链路全景
```mermaid
graph LR
A[人眼视觉特性] --> B[PQ EOTF: 感知量化]
B --> C[BT.2020 色彩空间: 广色域]
C --> D[10-bit 量化: 避免色阶]
D --> E[静态元数据: 显示适配依据]
E --> F[Tone Mapping: 动态映射到显示能力]
```

> ✅ 核心思想：不是简单提升亮度，而是以人眼感知为基准，重新设计整个视频信号链。

# 二、详细原理分解

1. 起点：人眼视觉特性（Human Visual System, HVS）

- 亮度感知非线性：人眼对暗部细节敏感，对高亮区域相对迟钝（Weber-Fechner 定律）。
- 可感知亮度范围：从 0.005 nits（星光）到 1,000,000 nits（太阳），跨越 8 个数量级。
- 传统 SDR 的局限：Rec.709 + Gamma 2.4 仅覆盖 0–100 nits，无法表达真实世界高光（如阳光、火焰）。


> 📌 设计动机：需要一种与人眼感知一致的电光转换函数（EOTF），而非简单的 Gamma 曲线。

2. 核心技术 1：PQ EOTF（SMPTE ST 2084）
- 全称：Perceptual Quantizer（感知量化器）
- 原理：
    - 基于 Barten 模型（人眼对比度敏感度函数）
    - 将 __绝对亮度（nits）__ 映射到 __归一化码值（0–1）__
    - 保证每个码值步长对应相同的人眼可察觉差异（JND, Just Noticeable Difference）
- 数学特性：
    - 支持最高 10,000 nits（HDR10 上限）
    - 在 0–100 nits 区间分辨率高于 SDR，避免暗部色阶
    - 在 1000+ nits 区间平滑过渡，保留高光细节
>💡 关键公式（简化）：
$V = \left( c_1 + c_2 L^{m_1} \right)^{m_2}$ 

    其中,L 为亮度（nits），V 为码值，$c_1$,$c_2$,$m_1$,$m_2$,$c_1$,$c_2$,$m_1$,$m_2$为拟合参数。

    ✅ 优势：相比 HLG（Hybrid Log-Gamma），PQ 完全基于绝对亮度，适合预制作内容（如电影）。

3. 核心技术 2：BT.2020 色彩空间
- 色域范围：
    - 覆盖 75.8% CIE 1931 色域（Rec.709 仅 35.9%）
    - 包含更多绿色和红色（如激光投影可呈现的颜色）
- 色彩 primaries（CIE xy 坐标）：
    - Red: (0.708, 0.292)
    - Green: (0.170, 0.797)
    - Blue: (0.131, 0.046)
    - White: D65 (0.3127, 0.3290)
- 矩阵系数：bt2020_ncl（非恒定亮度）
>📌 注意：
大多数显示设备无法完全覆盖 BT.2020（高端 OLED ≈ 80% DCI-P3 ≈ 60% BT.2020），但母版使用 BT.2020 可保留未来兼容性。

4. 量化精度：10-bit 深度
- 为什么需要 10-bit？ 
    - PQ 曲线在低亮度区斜率大 → 相同码值变化对应更小亮度差
    - 若用 8-bit（256 级），暗部会出现明显色阶（banding）
- 计算示例：
    - SDR (Gamma 2.4, 8-bit)：100 nits 内约 256 级
    - HDR10 (PQ, 10-bit)：10,000 nits 内 1024 级，每 nit 分辨率更高
>✅ 结论：10-bit 是 HDR10 的最低要求，不可降级。

5. 静态元数据（Static Metadata）：显示适配的关键
HDR10 使用 静态元数据（CTA-861-G / SMPTE ST 2094-10），包含：

|       元数据      |       作用         |
|------------------|-------------------| 
|Mastering Display Color Volume	|描述母版显示器的色域和亮度能力（如峰值 1000 nits，色坐标 G/B/R/White）|
|MaxCLL（Maximum Content Light Level）|	视频中出现的最高像素亮度（nits）|
|MaxFALL（Maximum Frame-Average Light Level）|	单帧平均亮度的最大值（nits）|

>📌 为什么需要元数据？不同显示器能力差异巨大（手机 500 nits vs 专业监视器 4000 nits），必须知道母版条件才能正确 tone map。

>⚠️ HDR10 的局限：静态元数据整片统一，无法逐场景优化（Dolby Vision 的动态元数据可解决此问题）。

6. 终端处理：Tone Mapping（色调映射）
当 HDR10 内容在非理想显示器上播放时，需进行 tone mapping：
- 输入：PQ 信号 + 元数据 + 显示器能力（EDID 获取）
- 算法目标：
    - 保留高光细节（不 clipping）
    - 维持局部对比度
    - 避免整体画面变灰
- 常见策略：
    - 全局映射：将 0–1000 nits 线性压缩到 0–600 nits（简单但损失细节）
    - 基于元数据的映射：利用 MaxCLL/MaxFALL 动态调整曲线（更优）
>💡 播放器角色：
如 mpv 可通过 --hdr-compute-peak=yes 动态估计峰值亮度，弥补静态元数据不足。

