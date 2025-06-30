# Quantization

QP: 0-255, DC is lower than AC

**Frame-level QP modulation**: given a QP_base, the QP_frame euqals:

|---| AC | DC |
|---|---|---|
| Y | QP_base | QP_base + Delta(Y,DC) |
| U | QP_base + Delta(U,AC) | QP_base + Delta(U,DC) |
| V | QP_base + Delta(V,AC) | QP_base + Delta(V,DC) |

Delta(X,Y) is derived from frame header.

**Block-level QP modulation**: given a caculated QP_frame, the QP_block equals:

QP_cb = clip(QP_frame + Delta_sb + Delta_seg, 1, 255)


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