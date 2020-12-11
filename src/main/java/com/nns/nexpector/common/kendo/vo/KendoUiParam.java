package com.nns.nexpector.common.kendo.vo;

import java.util.List;

public class KendoUiParam {

    private int page;
    private int pageSize;
    private int skip;
    private int take;
    private List<Sort> sort;

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public int getSkip() {
        return skip;
    }

    public void setSkip(int skip) {
        this.skip = skip;
    }

    public int getTake() {
        return take;
    }

    public void setTake(int take) {
        this.take = take;
    }

    public List<Sort> getSort() {
        return sort;
    }

    public void setSort(List<Sort> sort) {
        this.sort = sort;
    }

    @Override
    public String toString() {
        final StringBuilder sb = new StringBuilder("KendoUiParam{");
        sb.append("page=").append(page);
        sb.append(", pageSize=").append(pageSize);
        sb.append(", skip=").append(skip);
        sb.append(", take=").append(take);
        sb.append(", sort=").append(sort);
        sb.append('}');
        return sb.toString();
    }
}
