package com.nns.common;

import java.awt.image.DataBuffer;
import java.awt.image.IndexColorModel;

public class MonochromeColorModel extends IndexColorModel {

    private final static int[] MONO_PALETTE = {0x00000000, 0x00FFFFFF};
    
    private static MonochromeColorModel sInstance = new MonochromeColorModel();
    
    private  MonochromeColorModel() {
        super(1, 2, MONO_PALETTE, 0, false, -1, DataBuffer.TYPE_BYTE);
    }

    public static  IndexColorModel getInstance() {
        return sInstance;
    }

    public synchronized  Object getDataElements(int pRGB, Object pPixel) {
        // Get color components
        int r = pRGB >> 16 & 0xFF;
        int g = pRGB >>  8 & 0xFF;
        int b = pRGB       & 0xFF;

        // ITU standard:  Gray scale=(222*Red+707*Green+71*Blue)/1000
        int gray = (222 * r + 707 * g + 71 * b) / 1000;

        byte[] pixel;
        if (pPixel != null) {
            pixel = (byte[]) pPixel;
        }
        else {
            pixel = new byte[1];
        }

        if (gray <= 0x80) {
            pixel[0] = 0;
        }
        else {
            pixel[0] = 1;
        }

        return pixel;
    }
}
