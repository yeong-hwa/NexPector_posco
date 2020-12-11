package com.nns.common;

import egovframework.rte.ptl.mvc.tags.ui.pagination.AbstractPaginationRenderer;

public class ImagePaginationRenderer extends AbstractPaginationRenderer {

    public ImagePaginationRenderer() {
        firstPageLabel = "";
        previousPageLabel = "<a href=\"#\" onclick=\"{0}({1}); return false;\"><image src=\"/images/botton/btn_pg2_l.gif\" border=0/></a>&#160;";
        currentPageLabel = "<strong>{0}</strong>&#160;";
        otherPageLabel = "<a href=\"#\" onclick=\"{0}({1}); return false;\">{2}</a>&#160;";
        nextPageLabel = "<a href=\"#\" onclick=\"{0}({1}); return false;\"><image src=\"/images/botton/btn_pg2_r.gif\" border=0/></a>&#160;";
        lastPageLabel = "";
    }
}
