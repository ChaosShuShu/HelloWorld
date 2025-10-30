## formula
```cpp
 qp2scale:common.cpp::x265_qp2qScale(qp)
 tuneCplxFactor = (m_ncu > 3600 && m_param->rc.cuTree) ? 2.5 : m_isGrainEnabled ? 1.9 : 1;
 m_cplxrSum = .01 * pow(7.0e5, m_qCompress) * pow(m_ncu, 0.5) * tuneCplxFactor;
 ```




 ## CUTree
 The CUTree is a new feature in x265 that allows for more efficient CU partitioning and rate control. It is enabled by default in x265 3.0 and later. The CUTree is designed to reduce the impact of the CU tree on rate control by reducing the number of CUs that need to be considered for rate control decisions. This can lead to significant improvements in rate control performance.


qp_adj in AQ:

$qp_{adj} = {(1+var_{y,u,v} * \frac{1}{2^{{bite\_depth}-1}})}^{0.1}$

 ```cpp
 void LookaheadTLD::calcAdaptiveQuantFrame(Frame *curFrame, x265_param* param)
{
    /* Actual adaptive quantization */
    int maxCol = curFrame->m_fencPic->m_picWidth;
    int maxRow = curFrame->m_fencPic->m_picHeight;
    int blockCount, loopIncr;
    float modeOneConst, modeTwoConst;
    if (param->rc.qgSize == 8)
    {
        blockCount = curFrame->m_lowres.maxBlocksInRowFullRes * curFrame->m_lowres.maxBlocksInColFullRes;
        modeOneConst = 11.427f;
        modeTwoConst = 8.f;
        loopIncr = 8;
    }
    else
    {
        blockCount = widthInCU * heightInCU;
        modeOneConst = 14.427f;
        modeTwoConst = 11.f;
        loopIncr = 16;
    }

    float* quantOffsets = curFrame->m_quantOffsets;
    for (int y = 0; y < 3; y++)
    {
        curFrame->m_lowres.wp_ssd[y] = 0;
        curFrame->m_lowres.wp_sum[y] = 0;
    }

    if (!(param->rc.bStatRead && param->rc.cuTree && IS_REFERENCED(curFrame)))
    {
        /* Calculate Qp offset for each 16x16 or 8x8 block in the frame */
        if (param->rc.aqMode == X265_AQ_NONE || param->rc.aqStrength == 0)
        {
            if (param->rc.aqMode && param->rc.aqStrength == 0)
            {
                if (quantOffsets)
                {
                    for (int cuxy = 0; cuxy < blockCount; cuxy++)
                    {
                        curFrame->m_lowres.qpCuTreeOffset[cuxy] = curFrame->m_lowres.qpAqOffset[cuxy] = quantOffsets[cuxy];
                        curFrame->m_lowres.invQscaleFactor[cuxy] = x265_exp2fix8(curFrame->m_lowres.qpCuTreeOffset[cuxy]);
                    }
                }
                else
                {
                    memset(curFrame->m_lowres.qpCuTreeOffset, 0, blockCount * sizeof(double));
                    memset(curFrame->m_lowres.qpAqOffset, 0, blockCount * sizeof(double));
                    for (int cuxy = 0; cuxy < blockCount; cuxy++)
                        curFrame->m_lowres.invQscaleFactor[cuxy] = 256;
                }
            }

            /* Need variance data for weighted prediction and dynamic refinement*/
            if (param->bEnableWeightedPred || param->bEnableWeightedBiPred)
            {
                for (int blockY = 0; blockY < maxRow; blockY += loopIncr)
                    for (int blockX = 0; blockX < maxCol; blockX += loopIncr)
                        acEnergyCu(curFrame, blockX, blockY, param->internalCsp, param->rc.qgSize);
            }
        }
        else
        {
            if (param->rc.hevcAq)
            {
                // New method for calculating variance and qp offset
                xPreanalyze(curFrame);
            }
            else
            {
                int blockXY = 0, inclinedEdge = 0;
                double avg_adj_pow2 = 0, avg_adj = 0, qp_adj = 0;
                double bias_strength = 0.f;
                double strength = 0.f;

                if (param->rc.aqMode == X265_AQ_EDGE)
                    edgeFilter(curFrame, param);

                if (param->rc.aqMode == X265_AQ_EDGE && param->recursionSkipMode == EDGE_BASED_RSKIP)
                {
                    pixel* src = curFrame->m_edgePic + curFrame->m_fencPic->m_lumaMarginY * curFrame->m_fencPic->m_stride + curFrame->m_fencPic->m_lumaMarginX;
                    primitives.planecopy_pp_shr(src, curFrame->m_fencPic->m_stride, curFrame->m_edgeBitPic,
                        curFrame->m_fencPic->m_stride, curFrame->m_fencPic->m_picWidth, curFrame->m_fencPic->m_picHeight, SHIFT_TO_BITPLANE);
                }

                if (param->rc.aqMode == X265_AQ_AUTO_VARIANCE || param->rc.aqMode == X265_AQ_AUTO_VARIANCE_BIASED || param->rc.aqMode == X265_AQ_EDGE)
                {
                    double bit_depth_correction = 1.f / (1 << (2 * (X265_DEPTH - 8)));
                    for (int blockY = 0; blockY < maxRow; blockY += loopIncr)
                    {
                        for (int blockX = 0; blockX < maxCol; blockX += loopIncr)
                        {
                            uint32_t energy, edgeDensity, avgAngle;
                            energy = acEnergyCu(curFrame, blockX, blockY, param->internalCsp, param->rc.qgSize);
                            if (param->rc.aqMode == X265_AQ_EDGE)
                            {
                                edgeDensity = edgeDensityCu(curFrame, avgAngle, blockX, blockY, param->rc.qgSize);
                                if (edgeDensity)
                                {
                                    qp_adj = pow(edgeDensity * bit_depth_correction + 1, 0.1);
                                    //Increasing the QP of a block if its edge orientation lies around the multiples of 45 degree
                                    if ((avgAngle >= EDGE_INCLINATION - 15 && avgAngle <= EDGE_INCLINATION + 15) || (avgAngle >= EDGE_INCLINATION + 75 && avgAngle <= EDGE_INCLINATION + 105))
                                        curFrame->m_lowres.edgeInclined[blockXY] = 1;
                                    else
                                        curFrame->m_lowres.edgeInclined[blockXY] = 0;
                                }
                                else
                                {
                                    qp_adj = pow(energy * bit_depth_correction + 1, 0.1);
                                    curFrame->m_lowres.edgeInclined[blockXY] = 0;
                                }
                            }
                            else
                                qp_adj = pow(energy * bit_depth_correction + 1, 0.1);
                            curFrame->m_lowres.qpCuTreeOffset[blockXY] = qp_adj;
                            avg_adj += qp_adj;
                            avg_adj_pow2 += qp_adj * qp_adj;
                            blockXY++;
                        }
                    }
                    avg_adj /= blockCount;
                    avg_adj_pow2 /= blockCount;
                    strength = param->rc.aqStrength * avg_adj;
                    avg_adj = avg_adj - 0.5f * (avg_adj_pow2 - modeTwoConst) / avg_adj;
                    bias_strength = param->rc.aqStrength;
                }
                else
                    strength = param->rc.aqStrength * 1.0397f;

                blockXY = 0;
                for (int blockY = 0; blockY < maxRow; blockY += loopIncr)
                {
                    for (int blockX = 0; blockX < maxCol; blockX += loopIncr)
                    {
                        if (param->rc.aqMode == X265_AQ_AUTO_VARIANCE_BIASED)
                        {
                            qp_adj = curFrame->m_lowres.qpCuTreeOffset[blockXY];
                            qp_adj = strength * (qp_adj - avg_adj) + bias_strength * (1.f - modeTwoConst / (qp_adj * qp_adj));
                        }
                        else if (param->rc.aqMode == X265_AQ_AUTO_VARIANCE)
                        {
                            qp_adj = curFrame->m_lowres.qpCuTreeOffset[blockXY];
                            qp_adj = strength * (qp_adj - avg_adj);
                        }
                        else if (param->rc.aqMode == X265_AQ_EDGE)
                        {
                            inclinedEdge = curFrame->m_lowres.edgeInclined[blockXY];
                            qp_adj = curFrame->m_lowres.qpCuTreeOffset[blockXY];
                            if(inclinedEdge && (qp_adj - avg_adj > 0))
                                qp_adj = ((strength + AQ_EDGE_BIAS) * (qp_adj - avg_adj));
                            else
                                qp_adj = strength * (qp_adj - avg_adj);
                        }
                        else
                        {
                            uint32_t energy = acEnergyCu(curFrame, blockX, blockY, param->internalCsp, param->rc.qgSize);
                            qp_adj = strength * (X265_LOG2(X265_MAX(energy, 1)) - (modeOneConst + 2 * (X265_DEPTH - 8)));
                        }

                        if (param->bHDR10Opt)
                        {
                            uint32_t sum = lumaSumCu(curFrame, blockX, blockY, param->rc.qgSize);
                            uint32_t lumaAvg = sum / (loopIncr * loopIncr);
                            if (lumaAvg < 301)
                                qp_adj += 3;
                            else if (lumaAvg >= 301 && lumaAvg < 367)
                                qp_adj += 2;
                            else if (lumaAvg >= 367 && lumaAvg < 434)
                                qp_adj += 1;
                            else if (lumaAvg >= 501 && lumaAvg < 567)
                                qp_adj -= 1;
                            else if (lumaAvg >= 567 && lumaAvg < 634)
                                qp_adj -= 2;
                            else if (lumaAvg >= 634 && lumaAvg < 701)
                                qp_adj -= 3;
                            else if (lumaAvg >= 701 && lumaAvg < 767)
                                qp_adj -= 4;
                            else if (lumaAvg >= 767 && lumaAvg < 834)
                                qp_adj -= 5;
                            else if (lumaAvg >= 834)
                                qp_adj -= 6;
                        }
                        if (quantOffsets != NULL)
                            qp_adj += quantOffsets[blockXY];
                        curFrame->m_lowres.qpAqOffset[blockXY] = qp_adj;
                        curFrame->m_lowres.qpCuTreeOffset[blockXY] = qp_adj;
                        curFrame->m_lowres.invQscaleFactor[blockXY] = x265_exp2fix8(qp_adj);
                        blockXY++;
                    }
                }
            }
        }

        if (param->rc.qgSize == 8)
        {
            for (int cuY = 0; cuY < heightInCU; cuY++)
            {
                for (int cuX = 0; cuX < widthInCU; cuX++)
                {
                    const int cuXY = cuX + cuY * widthInCU;
                    curFrame->m_lowres.invQscaleFactor8x8[cuXY] = (curFrame->m_lowres.invQscaleFactor[cuX * 2 + cuY * widthInCU * 4] +
                        curFrame->m_lowres.invQscaleFactor[cuX * 2 + cuY * widthInCU * 4 + 1] +
                        curFrame->m_lowres.invQscaleFactor[cuX * 2 + cuY * widthInCU * 4 + curFrame->m_lowres.maxBlocksInRowFullRes] +
                        curFrame->m_lowres.invQscaleFactor[cuX * 2 + cuY * widthInCU * 4 + curFrame->m_lowres.maxBlocksInRowFullRes + 1]) / 4;
                }
            }
        }
    }

    if (param->bEnableWeightedPred || param->bEnableWeightedBiPred)
    {
        if (param->rc.bStatRead && param->rc.cuTree && IS_REFERENCED(curFrame))
        {
            for (int blockY = 0; blockY < maxRow; blockY += loopIncr)
                for (int blockX = 0; blockX < maxCol; blockX += loopIncr)
                    acEnergyCu(curFrame, blockX, blockY, param->internalCsp, param->rc.qgSize);
        }

        int hShift = CHROMA_H_SHIFT(param->internalCsp);
        int vShift = CHROMA_V_SHIFT(param->internalCsp);
        maxCol = ((maxCol + 8) >> 4) << 4;
        maxRow = ((maxRow + 8) >> 4) << 4;
        int width[3]  = { maxCol, maxCol >> hShift, maxCol >> hShift };
        int height[3] = { maxRow, maxRow >> vShift, maxRow >> vShift };

        for (int i = 0; i < 3; i++)
        {
            uint64_t sum, ssd;
            sum = curFrame->m_lowres.wp_sum[i];
            ssd = curFrame->m_lowres.wp_ssd[i];
            curFrame->m_lowres.wp_ssd[i] = ssd - (sum * sum + (width[i] * height[i]) / 2) / (width[i] * height[i]);
        }
    }

    if (param->bDynamicRefine || param->bEnableFades)
    {
        uint64_t blockXY = 0, rowVariance = 0;
        curFrame->m_lowres.frameVariance = 0;
        for (int blockY = 0; blockY < maxRow; blockY += loopIncr)
        {
            for (int blockX = 0; blockX < maxCol; blockX += loopIncr)
            {
                curFrame->m_lowres.blockVariance[blockXY] = acEnergyCu(curFrame, blockX, blockY, param->internalCsp, param->rc.qgSize);
                rowVariance += curFrame->m_lowres.blockVariance[blockXY];
                blockXY++;
            }
            curFrame->m_lowres.frameVariance += (rowVariance / maxCol);
        }
        curFrame->m_lowres.frameVariance /= maxRow;
    }
}
 ```